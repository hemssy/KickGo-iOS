import UIKit

protocol CreateAlert{
    func alertShow(title: String, message: String, completion: (() -> Void)?)
}

extension CreateAlert where Self: UIViewController{
    
    func alertShow(title: String, message: String, completion: (() -> Void)? = nil){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let completAction = UIAlertAction(title: "확인", style: .default) { (_) in
            completion?()
        }
        alert.addAction(completAction)
        self.present(alert, animated: true)
    }
}
