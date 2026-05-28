//
//  GenderListViewReactor.swift
//  GenderList
//

import Foundation
import ReactorKit
import RxSwift

struct ListSnapshot: Equatable {
    let items: [GenderProfileItemViewModel]
    let isSelectMode: Bool
    let selectedIndexes: Set<Int>
    
    static let empty = ListSnapshot(items: [], isSelectMode: false, selectedIndexes: [])
}

final class GenderListViewReactor: Reactor {
    enum Action {
        case configure
        case toggleSelectMode
        case toggleColumnStyle
        case scrollToBottom
        case pullToRefresh
        case selectItem(IndexPath)
        case removeSelected
    }
    
    enum Mutation {
        case setSelectMode(Bool)
        case setColumnStyle(ColumnStyle)
        case setItems([GenderProfileItemViewModel])
        case toggleSelected(Int)
        case clearSelected
        case setMoveToDetail(GenderProfileItemViewModel)
        case setError(String)
    }
    
    struct State {
        var columnStyle: ColumnStyle = .two
        var isSelectMode: Bool = false
        var items: [GenderProfileItemViewModel] = []
        var selectedIndexes: Set<Int> = []
        
        var selectButtonTitle: String { isSelectMode ? "취소" : "선택" }
        
        var listSnapshot: ListSnapshot {
            ListSnapshot(items: items, isSelectMode: isSelectMode, selectedIndexes: selectedIndexes)
        }
        
        @Pulse var moveToDetail: GenderProfileItemViewModel?
        @Pulse var error: String?
    }
    
    let initialState = State()
    
    private let fetchHelper: DefaultGenderListFetchHelper
    
    init() {
        self.fetchHelper = DefaultGenderListFetchHelper(
            usecase: DefaultGenderListUsecase(
                genderListRepository: DefaultGenderListRepository(service: DefaultNetworkService())
            )
        )
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .configure:
            return fetchHelper.fetch()
                .map { Mutation.setItems($0) }
                .catch { .just(.setError($0.localizedDescription)) }
        case .toggleSelectMode:
            let newMode = !currentState.isSelectMode
            
            if newMode {
                return .just(.setSelectMode(true))
            } else {
                return .concat([
                    .just(.setSelectMode(false)),
                    .just(.clearSelected)
                ])
            }
        case .toggleColumnStyle:
            let next: ColumnStyle = (currentState.columnStyle == .one) ? .two : .one
            return .just(.setColumnStyle(next))
        case .scrollToBottom:
            guard fetchHelper.fetchStatus == .ready else { return .empty() }
            
            return fetchHelper.fetch()
                .map { Mutation.setItems($0) }
                .catch { .just(.setError($0.localizedDescription)) }
        case .pullToRefresh:
            return fetchHelper.reset()
                .map { Mutation.setItems($0) }
                .catch { .just(.setError($0.localizedDescription)) }
        case .selectItem(let indexPath):
            if currentState.isSelectMode {
                return .just(.toggleSelected(indexPath.row))
            } else {
                guard indexPath.row < currentState.items.count else { return .empty() }
                
                return .just(.setMoveToDetail(currentState.items[indexPath.row]))
            }
        case .removeSelected:
            guard !currentState.selectedIndexes.isEmpty else { return .empty() }
            
            let newItems = fetchHelper.remove(at: Array(currentState.selectedIndexes))
            
            return .concat([
                .just(.setItems(newItems)),
                .just(.clearSelected)
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setSelectMode(let on):
            newState.isSelectMode = on
        case .setColumnStyle(let style):
            newState.columnStyle = style
        case .setItems(let items):
            newState.items = items
        case .toggleSelected(let idx):
            if newState.selectedIndexes.contains(idx) {
                newState.selectedIndexes.remove(idx)
            } else {
                newState.selectedIndexes.insert(idx)
            }
        case .clearSelected:
            newState.selectedIndexes.removeAll()
        case .setMoveToDetail(let item):
            newState.moveToDetail = item
        case .setError(let msg):
            newState.error = msg
        }
        
        return newState
    }
}
