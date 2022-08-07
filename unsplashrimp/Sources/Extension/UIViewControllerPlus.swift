//
//  UIViewControllerPlus.swift
//  unsplashrimp
//
//  Created by HAKKYU KIM on 2022/07/02.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { action in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
        
    }
}
