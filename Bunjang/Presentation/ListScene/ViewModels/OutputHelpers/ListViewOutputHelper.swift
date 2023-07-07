//
//  ListViewOutputHelper.swift
//  Bunjang
//
//  Created by RONICK on 2023/07/07.
//

import RxSwift

class ListViewOutputHelper: ListViewOutput {
    
    var disposeBag = DisposeBag()
    
    var fetchHelper: DefaultGenderListFetchHelper
    
    var selectedItemIndexes = [Int]()
    
    init(usecase: GenderListUsecase = DefaultGenderListUsecase(
        genderListRepository: DefaultGenderListRepository(service: DefaultNetworkService()))
    ) {
        self.fetchHelper = DefaultGenderListFetchHelper(usecase: usecase)
    }
    
    func createGenderListOutput(input: ListViewModel.Input) -> genderListOutput {
        let genderList = BehaviorSubject<[Gender]>.init(value: [])
        let genderListError = PublishSubject<String>()
        
        var genderType = ""
        
        input.tabInitialized
            .flatMap {
                genderType = $0
                return self.fetchHelper.fetch(genderType: $0)
            }.subscribe(onNext: { list in
                genderList.onNext(list)
            }, onError: {
                genderListError.onNext($0.localizedDescription)
            }).disposed(by: disposeBag)
        
        input.scrolledToBottom
            .filter { self.fetchHelper.fetchStatus == .ready }
            .flatMap { self.fetchHelper.fetch(genderType: genderType) }
            .subscribe(onNext: { list in
                genderList.onNext(list)
            }, onError: {
                genderListError.onNext($0.localizedDescription)
            }).disposed(by: disposeBag)
        
        input.didPullToRefresh
            .flatMap { self.fetchHelper.reset(genderType: genderType) }
            .subscribe(onNext: { list in
                genderList.onNext(list)
            }, onError: {
                genderListError.onNext($0.localizedDescription)
            }).disposed(by: disposeBag)
        
        input.removeBarButtonTapped
            .flatMap { $0 }
            .map { self.fetchHelper.remove(at: self.selectedItemIndexes) }
            .subscribe(onNext: { list in
                self.selectedItemIndexes.removeAll()
                genderList.onNext(list)
            }).disposed(by: disposeBag)
        
        return (genderList, genderListError)    }
    
    func createSelectionEventOutput(input: ListViewModel.Input, genderList: BehaviorSubject<[Gender]>) -> selectionEventOutput {
        var isSelectMode = false
        let cancelSelectedList = PublishSubject<Void>()
        
        input.selectButtonTapped
            .flatMap { $0 }
            .subscribe(onNext: {
                isSelectMode = $0
                if !$0 {
                    cancelSelectedList.onNext(Void())
                }
            }).disposed(by: disposeBag)
        
        let markItem = PublishSubject<IndexPath>()
        let moveToDetail = PublishSubject<Gender?>()
        input.itemTapped
            .map { SelectedItemInfo(indexPath: $0, isSelectMode: isSelectMode) }
            .subscribe(onNext: { itemInfo in
                if itemInfo.isSelectMode {
                    if self.selectedItemIndexes.contains(itemInfo.indexPath.row) {
                        self.selectedItemIndexes.removeAll { $0 == itemInfo.indexPath.row }
                    } else {
                        self.selectedItemIndexes.append(itemInfo.indexPath.row)
                    }
                    markItem.onNext(itemInfo.indexPath)
                } else {
                    let genderInfo = try? genderList.value()[itemInfo.indexPath.row]
                    moveToDetail.onNext(genderInfo)
                }
            }).disposed(by: disposeBag)
        
        return (cancelSelectedList, markItem, moveToDetail)
    }
    
    func removeAllSelectedItems() {
        selectedItemIndexes.removeAll()
    }
}
