
import Foundation
import UIKit
import SnapKit

class RegisterView: UIView {
    
    //상단 숫자
    let numsLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Color2563EB
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
        textField.backgroundColor = ColorF3F4F6
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
        textField.backgroundColor = ColorF3F4F6
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
        textField.backgroundColor = ColorF3F4F6
        textField.placeholder = "현재 배터리 잔량을 입력하세요."
        textField.autocapitalizationType = .none
        textField.keyboardType = .numberPad
        return textField
    }()
    
    //다음 컨테이너뷰
    let bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = ColorF3F4F6
        button.layer.cornerRadius = 12
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupLayout()
        setupTargets()
        hideKeyboardWhenTappedAround()
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
        [nextButton].forEach{
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
            $0.top.equalTo(nextButton.snp.top).offset(-16)
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
        
        // 다음 버튼
        nextButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            
            
        }
    }
    
    // 입력값 감시 및 다음버튼 활성화 제어
    private func setupTargets() {
        // 3개 텍스트필드의 입력 변화를 감지
        [modelNameTextField, serialNumberTextField, batteryTextField].forEach {
            $0.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        }
        
        // 초기에는 비활성화 상태
        nextButton.isEnabled = false
        nextButton.backgroundColor = ColorE5E7EB
    }
    
    @objc func textFieldsChanged() {
        let batteryText = batteryTextField.text ?? ""
        // 세 칸 모두 입력되어야 활성화
        let filled = !(modelNameTextField.text?.isEmpty ?? true) &&
        !(serialNumberTextField.text?.isEmpty ?? true) &&
        !(batteryText.isEmpty) &&
        //입력 숫자 체크(1~100)
        checkBatteryTextField()
        
        // 버튼 상태 업데이트
        nextButton.isEnabled = filled
        
        if filled {
            // 활성화 상태(정보를 다 입력했을 때)
            nextButton.backgroundColor = Color2563EB
            nextButton.setTitleColor(.white, for: .normal)
        } else {
            // 비활성화 상태(정보 하나라도 누락됐을 때)
            nextButton.backgroundColor = ColorE5E7EB
            nextButton.setTitleColor(.darkGray, for: .normal)
        }
        showBatteryError()
    }
    
    // 배터리 입력된 숫자 1~100체크
    // 추후 알림 메세지 Error파일 만들어서 리팩토링하기
    var onInvalidBatteryValueEntered: ((String) -> Void)?
    func checkBatteryTextField() -> Bool {
        
        guard let batteryText = batteryTextField.text,
              let batteryTextFieldValue = Int(batteryText) else {
            
            return false
        }
        
        if batteryTextFieldValue < 1 || batteryTextFieldValue > 100 {
            return false
        }
        
        return true
    }
    
    func showBatteryError(){
        // 비어있는 문자열 체크 및 Int로 변환
        guard let batteryText = batteryTextField.text, !batteryText.isEmpty,
              let batteryValue = Int(batteryText) else {
            return
        }
        // 1~100 범위를 벗어났을 경우
        if batteryValue < 1 || batteryValue > 100 {
            if batteryValue > 100 {
                batteryTextField.text = "100"
                onInvalidBatteryValueEntered?("배터리 잔량은 1~100 사이의 숫자여야 합니다.")
            } else if batteryValue < 1 {
                batteryTextField.text = "0"
                onInvalidBatteryValueEntered?("배터리 잔량은 0보다 커야 합니다.")
            }
        }
    }
}
