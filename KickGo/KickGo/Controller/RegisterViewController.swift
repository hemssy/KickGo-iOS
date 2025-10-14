import UIKit
import SnapKit


class RegisterViewController: UIViewController {
    let registerView = RegisterView()
    let registerLocationSettingView = RegisterLocateSettingView()
    let registerCheck = RegisterCheck()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = bgColor
        title = "등록"
        configureUI()
        setupView()
        settingView()
        buttonTappeds()
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
    
    func buttonTappeds(){
        // registerView의 다음 버튼 (*취소버튼 추가)
        registerView.nextButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        
        // registerLocatinSetting(위치설정)의 다음,이전 버튼
        registerLocationSettingView.nextButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        registerLocationSettingView.prevButton.addTarget(self, action: #selector(goPrev), for: .touchUpInside)
        
        // RegisterCheck의 이전 버튼 (*완료버튼 추가)
        registerCheck.prevButton.addTarget(self, action: #selector(goPrev), for: .touchUpInside)
    }
    
    
    @objc func goNext(){
        if registerView.isHidden == false{
            registerView.isHidden = true
            registerLocationSettingView.isHidden = false
            registerCheck.isHidden = true
        } else if registerLocationSettingView.isHidden == false{
            registerView.isHidden = true
            registerLocationSettingView.isHidden = true
            registerCheck.isHidden = false
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
    
    // 완료 알럿 함수 만들기

}

#Preview {
    RegisterViewController()
}
