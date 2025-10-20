import UIKit
import SnapKit
import CoreData

class RegisterViewController: UIViewController,RegisterCheckDelegate,CreateAlert{
    func registerCheckDidTapNext() -> [(title: String, value: String)] {
        return[
            ("모델명", registerView.modelNameTextField.text ?? ""),
            ("시리얼 번호", registerView.serialNumberTextField.text ?? ""),
            ("배터리", registerView.batteryTextField.text.map { "\($0) %" } ?? ""),
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
    
    //
    private func showVies(view: UIView){
        registerView.isHidden = true
        registerLocationSettingView.isHidden = true
        registerCheck.isHidden = true
        
        view.isHidden = false
    }
    
    
    @objc func goNext(){
        if !registerView.isHidden {
            showVies(view: registerLocationSettingView)
        } else if !registerLocationSettingView.isHidden{
            registerCheck.reloadData()
            showVies(view: registerCheck)
        }
        
    }
    @objc func goPrev(){
        if !registerLocationSettingView.isHidden {
            showVies(view: registerView)
        } else if !registerCheck.isHidden {
            showVies(view: registerLocationSettingView)
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
            alertShow(title: "등록 완료", message: "킥보드 정보가 저장되었습니다.")
            NotificationCenter.default.post(name: NSNotification.Name("NewScooter"), object: nil, userInfo: ["scooter": scooter])
            resetRegistrationForm()
        } catch {
            print("저장 실패: \(error)")
        }
    }
    
    // ReigisterView, RegisterLocateSettingView 알람표시
    private func setupViewActions(){
        /// 비동기 작업 알림 처리
        /// Controller가 geocodingError의 완료 결과을 받아 직접 알림을 표시하는 구조입니다.
        registerLocationSettingView.geocodingError = { [weak self] in
            self?.alertShow(title: "위치 검색 실패", message: RegisterError.searchResultError.message)
        }
        registerView.batteryTextField.addTarget(self, action: #selector(battaryChanged), for: .editingChanged)
        
    }
    @objc private func battaryChanged(){
        guard let batteryText = registerView.batteryTextField.text, !batteryText.isEmpty,
              let batteryValue = Int(batteryText) else {
            return
        }
        // 100을 초과했을 경우
        if batteryValue > 100 {
            registerView.batteryTextField.text = "100"
            alertShow(title: "입력 오류", message: RegisterError.maxBattaryError.message)
        }
        
        // 1 미만일 경우
        if batteryValue < 1 {
            // 값을 0으로 강제 변경하고, 에러 메시지를 enum에서 가져와 알림창을 띄웁니다.
            registerView.batteryTextField.text = nil
            alertShow(title: "입력 오류", message: RegisterError.minBattaryError.message)
        }
    }

    //등록 화면 데이터 초기화
    func resetRegistrationForm() {
        
        registerView.modelNameTextField.text = nil
        registerView.serialNumberTextField.text = nil
        registerView.batteryTextField.text = nil
        registerLocationSettingView.searchTextField.text = nil
        registerView.textFieldsChanged()
        settingView()
    }
    
}
