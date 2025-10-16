import UIKit
import SnapKit
import CoreData

class RegisterViewController: UIViewController,RegisterCheckDelegate {
    func registerCheckDidTapNext() -> [(title: String, value: String)] {
        return[
            ("모델명", registerView.modelNameTextField.text ?? ""),
            ("시리얼 번호", registerView.serialNumberTextField.text ?? ""),
            ("배터리", registerView.batteryTextField.text ?? ""),
            ("배치 위치", registerLocationSettingView.searchTextField.text ?? "")
        ]
    }
    
    
    let registerView = RegisterView()
    let registerLocationSettingView = RegisterLocateSettingView()
    let registerCheck = RegisterCheck()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCheck.delegate = self
        view.backgroundColor = ColorF3F4F6
        title = "등록"
        configureUI()
        setupView()
        settingView()
        buttonTapped()
        setupViewActions()
    }
    // 초기 뷰 셋팅
    func settingView() {
        registerView.isHidden = false
        registerLocationSettingView.isHidden = true
        registerCheck.isHidden = true
    }
    
    func configureUI() {
        view.addSubview(registerView)
        view.addSubview(registerLocationSettingView)
        view.addSubview(registerCheck)
    }
    func setupView() {
        registerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        registerLocationSettingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        registerCheck.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    func buttonTapped(){
        // registerView의 다음 버튼 (취소버튼 추가)
        registerView.nextButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        
        // registerLocatinSetting(위치설정)의 다음,이전 버튼
        registerLocationSettingView.nextButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        registerLocationSettingView.prevButton.addTarget(self, action: #selector(goPrev), for: .touchUpInside)
        
        // RegisterCheck의 이전 버튼 (완료버튼 추가)
        registerCheck.prevButton.addTarget(self, action: #selector(goPrev), for: .touchUpInside)
        
        registerCheck.finishButton.addTarget(self, action: #selector(saveScooterInfo), for: .touchUpInside)
    }
    
    
    @objc func goNext(){
        
        if registerView.isHidden == false{
            registerView.isHidden = true
            registerLocationSettingView.isHidden = false
            registerCheck.isHidden = true
            registerCheck.reloadData()
        } else if registerLocationSettingView.isHidden == false{
            registerView.isHidden = true
            registerLocationSettingView.isHidden = true
            registerCheck.isHidden = false
            registerCheck.reloadData()
        } else if registerCheck.isHidden == false{
            //완료 알럿 함수 나타내기
        }
    }
    @objc func goPrev(){
        if registerLocationSettingView.isHidden == false{
            registerView.isHidden = false
            registerLocationSettingView.isHidden = true
            registerCheck.isHidden = true
        } else if registerCheck.isHidden == false{
            registerView.isHidden = true
            registerLocationSettingView.isHidden = false
            registerCheck.isHidden = true
        }
        
    }
    
    // 킥보드 정보 저장 메서드
    @objc func saveScooterInfo() {
        let context = CoreDataStack.context
        guard let entity = NSEntityDescription.entity(forEntityName: "ScooterEntity", in: context) else { return }
        let scooter = NSManagedObject(entity: entity, insertInto: context)
        
        scooter.setValue(registerView.modelNameTextField.text ?? "", forKey: "modelName")
        scooter.setValue(registerView.serialNumberTextField.text ?? "", forKey: "serialNumber")
        
        // 현재 로그인된 계정 ID 저장
        if let userID = UserDefaults.standard.string(forKey: "loggedInUserID") {
            scooter.setValue(userID, forKey: "ownerID")
        }

        if let batteryText = registerView.batteryTextField.text,
           let batteryValue = Int(batteryText) {
            scooter.setValue(batteryValue, forKey: "battery")
        } else {
            scooter.setValue(0, forKey: "battery")
        }
        
        scooter.setValue(registerLocationSettingView.searchTextField.text ?? "", forKey: "position")

        do {
            try context.save()
            showAlert(title: "등록 완료", message: "킥보드 정보가 저장되었습니다.")
            resetRegistrationForm()
        } catch {
            print("저장 실패: \(error)")
        }
    }
    
    // ReigisterView, RegisterLocateSettingView 알람표시
    private func setupViewActions(){
        registerView.onInvalidBatteryValueEntered = { [weak self] message in
            self?.showAlert(title: "입력 오류", message: message)
        }
        registerLocationSettingView.geocodingError = { [weak self] message in
            self?.showAlert(title: "위치 검색 실패", message: message)
        }
        
    }



    // 등록완료 알럿
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let completAction = UIAlertAction(title: "확인", style: .default) { (_) in
            completion?()
        }
        alert.addAction(completAction)
        present(alert, animated: true)
    }
    //등록 화면 데이터 초기화
    private func resetRegistrationForm() {
        
        registerView.modelNameTextField.text = nil
        registerView.serialNumberTextField.text = nil
        registerView.batteryTextField.text = nil
        registerLocationSettingView.searchTextField.text = nil
        registerView.textFieldsChanged()
        settingView()
    }
    
}
