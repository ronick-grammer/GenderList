//
//  GenderListViewReactor.swift
//  GenderList
//

import Foundation
import ReactorKit
import RxSwift

final class GenderListViewReactor: Reactor {
    enum Action {
        case toggleSelectMode
        case toggleColumnStyle
        case selectTab(Int)
        case swipePage(Int)
        case configure(genderType: String)
        case scrolledToBottom(genderType: String)
        case pullToRefresh(genderType: String)
        case itemTapped(genderType: String, indexPath: IndexPath)
        case removeSelected
    }

    enum Mutation {
        case setSelectMode(Bool)
        case setColumnStyle(ColumnStyle)
        case setSelectedTab(PageInfo)
        case setItems([GenderProfileItemViewModel], genderType: String)
        case toggleSelected(Int, genderType: String)
        case clearAllSelected
        case setPageScrollTo(Int)
        case setMoveToDetail(GenderProfileItemViewModel)
        case setError(String)
    }

    struct ListSubState {
        var items: [GenderProfileItemViewModel] = []
        var selectedIndexes: Set<Int> = []
    }

    struct State {
        let tabs: [String] = ["male", "female"]
        var columnStyle: ColumnStyle = .two
        var selectedTab: PageInfo = (prev: 0, current: 0)
        var isSelectMode: Bool = false
        var lists: [String: ListSubState] = [
            "male": .init(),
            "female": .init()
        ]

        var selectButtonTitle: String { isSelectMode ? "취소" : "선택" }

        @Pulse var pageScrollTo: Int?
        @Pulse var moveToDetail: GenderProfileItemViewModel?
        @Pulse var error: String?
    }

    let initialState = State()
    private let fetchHelpers: [String: DefaultGenderListFetchHelper]

    init() {
        let makeHelper = {
            DefaultGenderListFetchHelper(
                usecase: DefaultGenderListUsecase(
                    genderListRepository: DefaultGenderListRepository(service: DefaultNetworkService())
                )
            )
        }
        self.fetchHelpers = [
            "male": makeHelper(),
            "female": makeHelper()
        ]
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .toggleSelectMode:
            let newMode = !currentState.isSelectMode
            if newMode {
                return .just(.setSelectMode(true))
            } else {
                return .concat([
                    .just(.setSelectMode(false)),
                    .just(.clearAllSelected)
                ])
            }

        case .toggleColumnStyle:
            let next: ColumnStyle = (currentState.columnStyle == .one) ? .two : .one
            return .just(.setColumnStyle(next))

        case .selectTab(let index):
            return .just(.setPageScrollTo(index))

        case .swipePage(let index):
            let prev = currentState.selectedTab.current
            return .just(.setSelectedTab((prev: prev, current: index)))

        case .configure(let genderType):
            guard let helper = fetchHelpers[genderType] else { return .empty() }
            return helper.fetch(genderType: genderType)
                .map { Mutation.setItems($0, genderType: genderType) }
                .catch { .just(.setError($0.localizedDescription)) }

        case .scrolledToBottom(let genderType):
            guard let helper = fetchHelpers[genderType], helper.fetchStatus == .ready else {
                return .empty()
            }
            return helper.fetch(genderType: genderType)
                .map { Mutation.setItems($0, genderType: genderType) }
                .catch { .just(.setError($0.localizedDescription)) }

        case .pullToRefresh(let genderType):
            guard let helper = fetchHelpers[genderType] else { return .empty() }
            return helper.reset(genderType: genderType)
                .map { Mutation.setItems($0, genderType: genderType) }
                .catch { .just(.setError($0.localizedDescription)) }

        case .itemTapped(let genderType, let indexPath):
            if currentState.isSelectMode {
                return .just(.toggleSelected(indexPath.row, genderType: genderType))
            } else {
                guard let items = currentState.lists[genderType]?.items,
                      indexPath.row < items.count else {
                    return .empty()
                }
                return .just(.setMoveToDetail(items[indexPath.row]))
            }

        case .removeSelected:
            var mutations: [Mutation] = []
            for genderType in currentState.tabs {
                guard let sub = currentState.lists[genderType],
                      !sub.selectedIndexes.isEmpty,
                      let helper = fetchHelpers[genderType] else { continue }
                let newItems = helper.remove(at: Array(sub.selectedIndexes))
                mutations.append(.setItems(newItems, genderType: genderType))
            }
            mutations.append(.clearAllSelected)
            return .concat(mutations.map { .just($0) })
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSelectMode(let on):
            newState.isSelectMode = on
        case .setColumnStyle(let style):
            newState.columnStyle = style
        case .setSelectedTab(let info):
            newState.selectedTab = info
        case .setItems(let items, let genderType):
            var sub = newState.lists[genderType] ?? .init()
            sub.items = items
            newState.lists[genderType] = sub
        case .toggleSelected(let idx, let genderType):
            var sub = newState.lists[genderType] ?? .init()
            if sub.selectedIndexes.contains(idx) {
                sub.selectedIndexes.remove(idx)
            } else {
                sub.selectedIndexes.insert(idx)
            }
            newState.lists[genderType] = sub
        case .clearAllSelected:
            for key in newState.lists.keys {
                newState.lists[key]?.selectedIndexes.removeAll()
            }
        case .setPageScrollTo(let idx):
            newState.pageScrollTo = idx
        case .setMoveToDetail(let item):
            newState.moveToDetail = item
        case .setError(let msg):
            newState.error = msg
        }
        return newState
    }
}
