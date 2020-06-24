//
//  AlertViewController.swift
//  T_Mobile_Work
//
//  Created by Anand Nanavaty on 24/06/20.
//  Copyright © 2020 Anand Nanavaty. All rights reserved.
//

import UIKit
extension UIViewController {
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
