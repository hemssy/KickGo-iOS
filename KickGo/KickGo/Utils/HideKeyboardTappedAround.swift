
import Foundation

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIView{
    func hideKeyboardWhenTappedAround() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
}
