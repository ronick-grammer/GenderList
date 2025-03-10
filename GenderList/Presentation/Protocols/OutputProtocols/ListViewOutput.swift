//
//  ListViewOutput.swift
//  GenderList
//
//  Created by RONICK on 2023/07/07.
//

import RxSwift

protocol ListViewOutput {
    typealias SelectedItemInfo = (
        indexPath: IndexPath,
        isSelectMode: Bool
    )
    
    typealias genderListOutput = (
        genderList: BehaviorSubject<[GenderProfileItemViewModel]>,
        genderListError: PublishSubject<String>
    )
    
    typealias selectionEventOutput = (
        cancelSelectedList: PublishSubject<Void>,
        markItem: PublishSubject<IndexPath>,
        moveToDetail: PublishSubject<GenderProfileItemViewModel?>
    )
    
    var disposeBag: DisposeBag { get }
    
    var fetchHelper: DefaultGenderListFetchHelper { set get }
    
    var selectedItemIndexes: [Int] { set get }
    
    func createGenderListOutput(input: ListViewModel.Input) -> genderListOutput
    
    func createSelectionEventOutput(input: ListViewModel.Input, genderList: BehaviorSubject<[GenderProfileItemViewModel]>) -> selectionEventOutput
    
    func removeAllSelectedItems()
}
