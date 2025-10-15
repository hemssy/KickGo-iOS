
import Foundation
import UIKit
import SnapKit

class SignUpVIewController: UIViewController {
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
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color2563EB
        button.layer.cornerRadius = 12
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "회원가입"
        view.backgroundColor = .white
        setupUI()
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
    
}
