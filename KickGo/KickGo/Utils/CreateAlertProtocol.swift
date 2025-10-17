
import UIKit

/// 참고 https://sandclock-itblog.tistory.com/168
/// 반복적으로 사용하는 Alert함수를 프로토코를 활용하여 중복을 없애고 유지보수 향상
/// 1.중복 제거 ( Alert를 띄우는 함수가 여러곳에 포함)
/// 2. 유지보수 향상( 이 파일에서 수정하면 앱 전체 수정 가능
/// 3. 가독성 향상( 다른 코드가 없기 때문에 보기 수월)
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
