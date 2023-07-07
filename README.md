# GenderList

<p align="left">  
<img src="https://github.com/ronick-grammer/GenderList/assets/73280175/03dbf156-22af-4302-a327-d88394f48866" alt="simulator" width="25%">
</p>

#### open API: https://randomuser.me/documentation

#### 구현사항 

1. 현업에서 해왔던 기술들 기반으로 작업하였습니다
2. open source 사용에 제한을 두지 않았습니다
3. 남자/여자 탭을 구현하여 남자탭에는 남자리스트만, 여자탬에는 여자 리스트만 노출되도록 하였습니다.
   - 남자/여자 탭은 예시일 뿐 탭 구성은 자유롭게(유동성있게) 만들었습니다.
4. 좌우 스와이프 기능을 구현하였습니다.
5. 탭 선택시 해당 리스트로 이동이 되도록 하였습니다.
6. 스크롤뷰를 당겨서 놓을 경우 새로고침이 되는 Pull to refresh 기능을 구현하였습니다.
7. 스크롤링시 자동으로 다음 리스트를 가져 올 수 있도록 하였습니다.(무한 스크롤링)
8. 에러 예외처리를 하였습니다.
9. 리스트중 하나 혹은 여러개를 선택하여 삭제할 수 있도록 하였습니다.
10. 사진 선택시 사진을 자세히 볼 수 있는 화면으로 이동해야 합니다.
    - 사진은 2배까지 볼 수 있도록 확대 / 축소 기능이 있어야 합니다.
11. 리스트 구현시 1단형/2단형 (1열, 2열) 구성으로 전환할 수 있는 형태로 구현하였습니다.
    - 1/2단 변경 버튼 클릭시 모든 탭의 화면에 영향을 주도록 하였습니다.
12. UI 구성에는 제한을 두지 않았습니다.

#### 아키텍처 패턴: Clean Architecture
#### 디자인 패턴: MVVM, Input/Output
#### 라이브러리: SnapKit, RxSwift, RxCocoa, Alamofire, Kingfisher 

#### 레이어 구조
```
├── Application
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Data
│   └── Repositories
│       └── DefaultGenderListRepository.swift
├── Domain
│   ├── Entities
│   │   ├── GenderList.swift
│   │   └── GenderListQuery.swift
│   └── Usecases
│       └── GenderListUsecase.swift
├── Infrastructure
│   └── Networks
│       └── NetworkService.swift
├── Interfaces
│   └── Repositories
│       └── GenderListRepository.swift
└── Presentation
    ├── ListScene
    │   ├── ViewModels
    │   │   ├── InitialViewModel.swift
    │   │   ├── ListPageViewModel.swift
    │   │   ├── ListViewModel.swift
    │   │   ├── OutputHelpers
    │   │   │   └── ListViewOutputHelper.swift
    │   │   ├── TabListViewModel.swift
    │   │   └── TabViewModel.swift
    │   └── Views
    │       ├── Detail
    │       │   ├── DetailView.swift
    │       │   └── DetailViewController.swift
    │       ├── InitialViewController.swift
    │       ├── List
    │       │   ├── ListCollectionView.swift
    │       │   ├── ListCollectionViewCell.swift
    │       │   ├── PageCollectionView.swift
    │       │   ├── PageCollectionViewCell.swift
    │       │   └── TabPageView.swift
    │       └── Tab
    │           ├── TabCollectionView.swift
    │           └── TabCollectionViewCell.swift
    ├── Protocols
    │   ├── Bindable.swift
    │   ├── OutputProtocols
    │   │   └── ListViewOutput.swift
    │   ├── PagenationGenerator.swift
    │   └── ViewModelType.swift
    └── Utils
        ├── ColumnStyle.swift
        ├── DefaultPagenationGenerator.swift
        ├── Extensions
        │   ├── ListPageView+Rx.swift
        │   ├── TabView+Rx.swift
        │   ├── UICollectionView+Extension.swift
        │   ├── UICollectionView+Rx.swift
        │   └── UIView+Extension.swift
        ├── FetchStatus.swift
        └── GenderListFetchHelper.swift
```
