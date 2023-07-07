//
//  UIView+Extensions.swift
//  Bunjang
//
//  Created by RONICK on 2023/07/04.
//

import UIKit
import SnapKit

extension UIView {
    func makeToast(_ message : String, withDuration: Double, delay: Double) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 14.0)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds  =  true
            
        addSubview(toastLabel)
        toastLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(600)
        }
        
        UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 1.0
        }, completion: { (isCompleted) in
            UIView.animate(withDuration: withDuration, delay: delay, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        })
    }

}
