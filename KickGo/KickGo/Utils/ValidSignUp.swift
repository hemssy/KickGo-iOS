import Foundation

extension String {
    var isValidEmail: Bool {
        let regExp = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        
        return NSPredicate(format: "SELF MATCHES %@", regExp).evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        let regExp = "^01[0][0-9]{8}$"
        
        return NSPredicate(format: "SELF MATCHES %@", regExp).evaluate(with: self)
    }
}
