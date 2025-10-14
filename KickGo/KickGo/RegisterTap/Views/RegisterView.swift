
import Foundation
import UIKit
import SnapKit

class RegisterView: UIView {
    
    //상단 숫자
    let numsLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = viewNumsColor
        label.textColor = .white
        label.text = "1"
        label.textAlignment = .center
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        return label
    }()
    // 킥보드 정보 label
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "킥보드 정보"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    //킥보드 정보 상세설명 label
    let detailLabel: UILabel = {
        let label = UILabel()
        label.text = "킥보드의 기본 정보를 입력해주세요."
        return label
    }()
    
    //킥보드 정보 입력 컨테이너 뷰
    let registerContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    //킥보드 모델명 label,textField
    let modelNameLabel: UILabel = {
        let label = UILabel()
        label.text = "킥보드 모델명"
        return label
    }()
    let modelNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = bgColor
        textField.placeholder = "예: KickGo Pro Max"
        textField.autocapitalizationType = .none
        return textField
    }()
    
    //시리얼 번호 label,textField
    let serialNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "시리얼 번호"
        return label
    }()
    let serialNumberTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = bgColor
        textField.placeholder = "킥보드에 표시된 시리얼 번호를 입력하세요."
        textField.autocapitalizationType = .none
        return textField
    }()
    //배터리 잔량(%) label, textField
    let batteryLabel: UILabel = {
        let label = UILabel()
        label.text = "배터리 잔량(%)"
        return label
    }()
    
    let batteryTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = bgColor
        textField.placeholder = "현재 배터리 잔량을 입력하세요."
        textField.autocapitalizationType = .none
        return textField
    }()
    
    //하단 취소, 다음 컨테이너뷰
    let bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = bgColor
        button.layer.cornerRadius = 12
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = bgColor
        button.layer.cornerRadius = 12
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        //self(RegisterView)에 상속
        [numsLabel, infoLabel, detailLabel,registerContainerView,bottomContainerView].forEach{
            self.addSubview($0)
        }
        //registerContainerView에 상속
        [modelNameLabel,modelNameTextField, serialNumberLabel, serialNumberTextField, batteryLabel, batteryTextField].forEach{
            registerContainerView.addSubview($0)
        }
        //bottomContainerView에 상속
        [cancelButton,nextButton].forEach{
            bottomContainerView.addSubview($0)
        }
        
    }
    func setupLayout() {
        numsLabel.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide).inset(30)
            $0.width.height.equalTo(32)
            $0.centerX.equalToSuperview()
        }
        infoLabel.snp.makeConstraints{
            $0.top.equalTo(numsLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        detailLabel.snp.makeConstraints{
            $0.top.equalTo(infoLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        registerContainerView.snp.makeConstraints{
            $0.top.equalTo(detailLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        bottomContainerView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.top.equalTo(cancelButton.snp.top).offset(-16)
        }
        
        registerSetUpLayout()
        bottomContainerSetUpLayout()
    }
    
    
    //registerContainerView 하위 요소 오토레이아웃 설정
    func registerSetUpLayout() {
        
        // 모델명
        modelNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        modelNameTextField.snp.makeConstraints {
            $0.top.equalTo(modelNameLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(modelNameLabel)
            $0.height.equalTo(50)
        }
        
        // 시리얼 번호
        serialNumberLabel.snp.makeConstraints {
            $0.top.equalTo(modelNameTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(modelNameLabel)
        }
        serialNumberTextField.snp.makeConstraints {
            $0.top.equalTo(serialNumberLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(modelNameLabel)
            $0.height.equalTo(50)
        }
        
        // 배터리 잔량
        batteryLabel.snp.makeConstraints {
            $0.top.equalTo(serialNumberTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(modelNameLabel)
        }
        batteryTextField.snp.makeConstraints {
            $0.top.equalTo(batteryLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(modelNameLabel)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    //bottomContainerView 하위 요소 오토레이아웃 설정
    func bottomContainerSetUpLayout() {
        // 취소 버튼
        cancelButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        // 다음 버튼
        nextButton.snp.makeConstraints {
            $0.width.equalTo(cancelButton)
            $0.centerY.height.equalTo(cancelButton)
            $0.trailing.equalToSuperview().inset(20)
            $0.leading.equalTo(cancelButton.snp.trailing).offset(20)
            
        }
    }
}
