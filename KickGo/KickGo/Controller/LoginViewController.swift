
import Foundation
import UIKit
import SnapKit

class LoginViewController: UIViewController, CreateAlert {
    private let logoBgView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = Color2563EB
        uiView.layer.cornerRadius = 20
        return uiView
    }()
    private let logoImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "bicycle")
        img.contentMode = .scaleAspectFit
        img.tintColor = .white
        return img
    }()
    private let appNameImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "kickgo_logo_text")
        img.contentMode = .scaleAspectFit
        return img
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "스마트한 킥보드 라이딩"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray
        return label
    }()
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = .zero
        gradientLayer.colors = [ColorEFF6FF.cgColor, UIColor.white.cgColor]
        return gradientLayer
    }()
    let IDTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.placeholder = "이메일 주소"
        textField.autocapitalizationType = .none
        return textField
    }()
    let PasswordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.placeholder = "비밀번호"
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let LoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color2563EB
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        label.text = "아직 계정이 없으신가요?"
        return label
    }()
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(Color2563EB, for: .normal)
        return button
    }()
    private let signUpStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.insertSublayer(gradientLayer, at: 0)
        navigationItem.hidesBackButton = true
        hideKeyboardWhenTappedAround()
        setupUI()
        setupLayout()
        lastLoginfo()
        LoginButton.addTarget(self, action: #selector (loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    //view에 추가하는 역할과 Auto Layout 제약조건을 설정하는 역할 함수 구분
    private func setupUI() {
        [appNameImageView,logoBgView,subtitleLabel,IDTextField,PasswordTextField,LoginButton,signUpStackView].forEach{ view.addSubview($0)}
        logoBgView.addSubview(logoImageView)
        
        [signUpLabel,signUpButton].forEach{ signUpStackView.addArrangedSubview($0)}
    }
    
    private func setupLayout(){
        appNameImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(130)
        }
        
        logoBgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(appNameImageView.snp.top).offset(-20)
            make.width.height.equalTo(80)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(36)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(appNameImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        IDTextField.snp.makeConstraints{ make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        PasswordTextField.snp.makeConstraints{ make in
            make.top.equalTo(IDTextField.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(IDTextField)
        }
        
        LoginButton.snp.makeConstraints{ make in
            make.top.equalTo(PasswordTextField.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(IDTextField)
        }
        
        signUpStackView.snp.makeConstraints { make in
            make.top.equalTo(LoginButton.snp.bottom).offset(130)
            make.centerX.equalToSuperview()
        }
    }
    
    /// 에러 처리 개선 :  do-try-catch 와 커스텀 에러 타입으로 처리
    /// 예상 질문 : UserDefaults를 사용한 이유
    /// 장점 : 빠르게 개발 가능함. 별도의 라이브러리 없이 즉시 사용가능
    /// 단점 : 보안이 매우 취약함.
    /// 단기간에 빠르게 만들어야 하기 때문에 사용했으며 보안이 약하기 때문에 이후 정보들을 키체인에 저장 하거나 외부 서버를 이용해야한다.
    @objc private func loginButtonTapped() {
        do {
            let mainVC = MainViewController()
            
            guard let id = IDTextField.text, !id.isEmpty,
                  let textFieldPassword = PasswordTextField.text, !textFieldPassword.isEmpty else {
                throw LoginError.emptyField
            }
            guard let userDict = UserDefaults.standard.dictionary(forKey: id),
                  let password = userDict["password"] as? String else {
                throw LoginError.incorrectID
            }
            guard textFieldPassword == password else {
                throw LoginError.incorrectpaswword
            }
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set(id, forKey: "loggedInUserID")
            
            UserDefaults.standard.set(id, forKey: "lastUseEmail")
            UserDefaults.standard.set(textFieldPassword, forKey: "lastUsePassword")
            
            navigationController?.pushViewController(mainVC, animated: true)
        } catch{
            if let loginError = error as? LoginError{
                alertShow(title: "로그인 실패", message: loginError.message)
            } else {
                alertShow(title: "로그인 실패", message: "오류 발생")
            }
        }
    }
    
    private func lastLoginfo(){
        if let lastUsedEmail = UserDefaults.standard.string(forKey: "lastUseEmail"){
            IDTextField.text = lastUsedEmail
        }
        if let lastUsedPassword = UserDefaults.standard.string(forKey: "lastUsePassword"){
            PasswordTextField.text = lastUsedPassword
        }
    }

    
    @objc private func signupButtonTapped() {
        let signupVC = SignUpVIewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
}
