
import Foundation
import UIKit
import SnapKit

class LoginViewController: UIViewController {
    private let logoBgView = UIView()
    private let logoImageView = UIImageView(image: UIImage(systemName: "bicycle"))
    private let appNameImageView = UIImageView(image: UIImage(named: "kickgo_logo_text"))
    private let subtitleLabel = UILabel()
    
    private let firstColor = ColorEFF6FF
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = .zero
        gradientLayer.colors = [firstColor.cgColor, UIColor.white.cgColor]
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
    let PasswordNameTextField: UITextField = {
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
        // 상단 back버튼 숨기기
        navigationItem.hidesBackButton = true
        
        hideKeyboardWhenTappedAround()
        setupUI()
        lastLoginfo()
        LoginButton.addTarget(self, action: #selector (loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        
    }
    
    private func setupUI() {
        // 앱 이름 이미지 (중앙 기준이 됨)
        appNameImageView.contentMode = .scaleAspectFit
        view.addSubview(appNameImageView)
        appNameImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(130)
        }
        
        // 로고 배경 + 자전거 아이콘 (앱 이름 위쪽)
        logoBgView.backgroundColor = UIColor(red: 0.15, green: 0.39, blue: 0.93, alpha: 1.0) // 피그마 배경색 #2563EB
        logoBgView.layer.cornerRadius = 20
        view.addSubview(logoBgView)
        logoBgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(appNameImageView.snp.top).offset(-20)
            make.width.height.equalTo(80)
        }
        
        logoImageView.tintColor = .white
        logoImageView.contentMode = .scaleAspectFit
        logoBgView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(36)
        }
        
        // 슬로건 (앱 이름 아래쪽)
        subtitleLabel.text = "스마트한 킥보드 라이딩"
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = .gray
        view.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(appNameImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        // 이메일 입력 (슬로건 아래)
        view.addSubview(IDTextField)
        IDTextField.snp.makeConstraints{ make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        // 비밀번호 입력 (이메일 아래)
        view.addSubview(PasswordNameTextField)
        PasswordNameTextField.snp.makeConstraints{ make in
            make.top.equalTo(IDTextField.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(IDTextField)
        }
        // 로그인 버튼 (비밀번호 아래)
        view.addSubview(LoginButton)
        LoginButton.snp.makeConstraints{ make in
            make.top.equalTo(PasswordNameTextField.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(IDTextField)
        }
        
        // 회원가입 텍스트 + 버튼 스텍뷰
        signUpStackView.addArrangedSubview(signUpLabel)
        signUpStackView.addArrangedSubview(signUpButton)
        
        view.addSubview(signUpStackView)
        
        signUpStackView.snp.makeConstraints { make in
            make.top.equalTo(LoginButton.snp.bottom).offset(130)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func loginButtonTapped() {
        let mainVC = MainViewController()
        guard let id = IDTextField.text, !id.isEmpty,
              let textFieldPassword = PasswordNameTextField.text, !textFieldPassword.isEmpty else {
            showAlert(title: "로그인 실패", message: "이메일과 비밀번호를 입력하세요.")
            return
        }
        
        guard let userDict = UserDefaults.standard.dictionary(forKey: id),
              let password = userDict["password"] as? String else {
            showAlert(title: "로그인 실패", message: "존재하지 않는 이메일입니다.")
            return
        }
        
        if PasswordNameTextField.text == password {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set(id, forKey: "loggedInUserID")
            
            UserDefaults.standard.set(id, forKey: "lastUseEmail")
            UserDefaults.standard.set(textFieldPassword, forKey: "lastUsePassword")
            
            navigationController?.pushViewController(mainVC, animated: true)
        } else {
            showAlert(title: "로그인 실패", message: "비밀번호가 올바르지 않습니다.")
        }
    }
    
    private func lastLoginfo(){
        if let lastUsedEmail = UserDefaults.standard.string(forKey: "lastUseEmail"){
            IDTextField.text = lastUsedEmail
        }
        if let lastUsedPassword = UserDefaults.standard.string(forKey: "lastUsePassword"){
            PasswordNameTextField.text = lastUsedPassword
        }
    }

    
    @objc private func signupButtonTapped() {
        let signupVC = SignUpVIewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let completAction = UIAlertAction(title: "확인", style: .default) { (_) in
            completion?()
        }
        alert.addAction(completAction)
        present(alert, animated: true)
    }
    
}
