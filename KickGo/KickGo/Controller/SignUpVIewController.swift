
import Foundation
import UIKit
import SnapKit

class SignUpVIewController: UIViewController {
    let defaults = UserDefaults.standard
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        return label
    }()
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = ColorF3F4F6
        textField.placeholder = "예: 김킥고"
        textField.autocapitalizationType = .none
        return textField
    }()
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        return label
    }()
    private let emailLabelTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = ColorF3F4F6
        textField.placeholder = "예: kickgo@example.com"
        textField.autocapitalizationType = .none
        return textField
    }()
    private let phoneNumsLabel: UILabel = {
        let label = UILabel()
        label.text = "전화번호"
        return label
    }()
    private let phoneNumsTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = ColorF3F4F6
        textField.placeholder = "010-0000-0000"
        textField.autocapitalizationType = .none
        return textField
    }()
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        return label
    }()
    private let passwordLabelTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = ColorF3F4F6
        textField.placeholder = ""
        textField.autocapitalizationType = .none
        return textField
    }()
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입 완료", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = ColorE5E7EB
        button.layer.cornerRadius = 12
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "회원가입"
        view.backgroundColor = .white
        signUpButton.addTarget(self, action: #selector(completeSignUp), for: .touchUpInside)
        setupTargets()
        setupUI()
        
        // UserDefault 데이터 경로
        if let libraryDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first {
            print("UserDefaults 경로: \(libraryDirectory.path)/Preferences")
        }
    }
    
    func setupUI(){
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.centerX.equalTo(view)
        }
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(nameLabel)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(24)
            make.leading.trailing.equalTo(nameLabel)
        }
        view.addSubview(emailLabelTextField)
        emailLabelTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(nameLabel)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        view.addSubview(phoneNumsLabel)
        phoneNumsLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabelTextField.snp.bottom).offset(24)
            make.leading.trailing.equalTo(nameLabel)
        }
        view.addSubview(phoneNumsTextField)
        phoneNumsTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumsLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(nameLabel)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        view.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumsTextField.snp.bottom).offset(24)
            make.leading.trailing.equalTo(nameLabel)
        }
        view.addSubview(passwordLabelTextField)
        passwordLabelTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(nameLabel)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(passwordLabelTextField.snp.bottom).offset(48)
            make.leading.trailing.equalTo(nameLabel)
            make.width.equalTo(300)
            make.height.equalTo(60)
        }
    }
    
    @objc private func completeSignUp() {
        let loginVC = LoginViewController()
        // 데이터 수집
        let userDictionary: [String : Any] = [
            "name": nameTextField.text ?? "",
            "id": emailLabelTextField.text ?? "",
            "phoneNums": phoneNumsTextField.text ?? "",
            "password": passwordLabelTextField.text ?? ""
        ]
        
        
        defaults.set(userDictionary, forKey: emailLabelTextField.text ?? "")
        
        navigationController?.pushViewController(loginVC, animated: true)
    }
    // 입력값 감시 및 다음버튼 활성화 제어
    private func setupTargets() {
        // 3개 텍스트필드의 입력 변화를 감지
        [nameTextField,emailLabelTextField,phoneNumsTextField,passwordLabelTextField].forEach {
            $0.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        }
        
        // 초기에는 비활성화 상태
        signUpButton.isEnabled = false
        signUpButton.backgroundColor = ColorE5E7EB
    }
    
    @objc private func textFieldsChanged() {
        // 세 칸 모두 입력되어야 활성화
        let filled = !(nameTextField.text?.isEmpty ?? true) &&
        !(emailLabelTextField.text?.isEmpty ?? true) &&
        !(phoneNumsTextField.text?.isEmpty ?? true) &&
        !(passwordLabelTextField.text?.isEmpty ?? true)
        // 버튼 상태 업데이트
        signUpButton.isEnabled = filled
        
        if filled {
            // 활성화 상태(정보를 다 입력했을 때)
            signUpButton.backgroundColor = Color2563EB
            signUpButton.setTitleColor(.white, for: .normal)
        } else {
            // 비활성화 상태(정보 하나라도 누락됐을 때)
            signUpButton.backgroundColor = ColorE5E7EB
            signUpButton.setTitleColor(.darkGray, for: .normal)
        }
    }
    
}

