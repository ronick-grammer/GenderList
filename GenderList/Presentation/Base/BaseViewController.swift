//
//  BaseViewController.swift
//  GenderList
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupIfNeeded()
    }

    func setupViews() {}
    func setupConstraints() {}
    func setupIfNeeded() {}
}
