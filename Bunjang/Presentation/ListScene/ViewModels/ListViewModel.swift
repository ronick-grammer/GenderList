//
//  ListViewModel.swift
//  Bunjang
//
//  Created by Ronick on 6/24/23.
//

import RxSwift

final class ListViewModel: ViewModelType {
    
    struct Input {
        /// 탭 화면(남자 or 여자) 리스트 초기화 이벤트
        let tabInitialized: PublishSubject<String>
        
        /// 스크롤을 맨 밑으로 내렸을 때 발생하는 이벤트
        let scrolledToBottom: Observable<Void>
        
        /// 새로고침 이벤트
        let didPullToRefresh: PublishSubject<Void>
        
        /// 리스트 아이템 클릭 이벤트
        let itemTapped: Observable<IndexPath>
        
        /// 선택 버튼 클릭 이벤트
        var selectButtonTapped: PublishSubject<Observable<Bool>>
        
        /// 제거 버튼 클릭 이벤트
        var removeBarButtonTapped: PublishSubject<Observable<Void>>
    }
    
    struct Output {
        /// 성별 리스트
        let genderList: BehaviorSubject<[Gender]>
        
        /// 성별 리스트 에러
        let genderListError: Observable<String>
                
        /// 선택된 리스트 취소
        let cancelSelectedList: Observable<Void>
        
        /// 선택한 아이템 마킹 처리
        let markItem: Observable<IndexPath>
        
        /// 선택한 아이템의 상세화면 이동
        let moveToDetail: Observable<Gender?>
    }
    
    var disposeBag = DisposeBag()
        
    private let listViewOutputHelper: ListViewOutput
    
    init(outputHelper: ListViewOutput = ListViewOutputHelper()) {
        listViewOutputHelper = outputHelper
    }
        
    func transform(input: Input) -> Output {
        let genderListOutput = listViewOutputHelper.createGenderListOutput(input: input)
        let selectionEventOutput = listViewOutputHelper.createSelectionEventOutput(
            input: input,
            genderList: genderListOutput.genderList
        )
        
        return Output(
            genderList: genderListOutput.genderList,
            genderListError: genderListOutput.genderListError,
            cancelSelectedList: selectionEventOutput.cancelSelectedList,
            markItem: selectionEventOutput.markItem,
            moveToDetail: selectionEventOutput.moveToDetail
        )
    }
    
    func removeAllSelectedItems() {
        listViewOutputHelper.removeAllSelectedItems()
    }
    
    func isSelected(index: Int) -> Bool {
        listViewOutputHelper.selectedItemIndexes.contains(index)
    }
}
