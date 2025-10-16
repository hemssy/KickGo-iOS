import UIKit
import SnapKit

// 재사용하는 메뉴 행 뷰 클래스
class MenuRowView: UIControl {
    
    // 사용할 프로퍼티
    private let iconBg = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
    
    // 초기화 메서드
    init(iconSystemName: String, title: String) {
        super.init(frame: .zero)
        setupUI(iconSystemName: iconSystemName, title: title)
    }
    
    // fatalError 메시지
    required init?(coder: NSCoder) { fatalError() }
    
    // 메뉴카드의 UI 만들기
    private func setupUI(iconSystemName: String, title: String) {
        
        // 아이콘 배경
        iconBg.layer.cornerRadius = 10
        iconBg.backgroundColor = UIColor(red: 0.953, green: 0.957, blue: 0.965, alpha: 1)
        addSubview(iconBg)
        iconBg.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        
        // 아이콘
        iconView.image = UIImage(systemName: iconSystemName)
        iconBg.addSubview(iconView)
        iconView.snp.makeConstraints { $0.center.equalToSuperview() }
        
        // 타이틀
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconBg.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
        
        // 꺽쇠(>)
        addSubview(chevron)
        chevron.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        // 전체높이
        snp.makeConstraints { $0.height.equalTo(64) }
    }
}

// 마이탭 뷰컨트롤러
class MyViewController: UIViewController {

    // 스크롤
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // 프로필 헤더
    private let headerStack = UIStackView()
    private let avatar = UIImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()

    // 프로필헤더 밑에 회색 묶음 영역
    private let contentContainer = UIView()

    // 상태 카드(이용중/이용중아님)
    private let statusCard = UIView()
    private let scooterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()


    // 메뉴 카드(이용내역/내가등록한킥보드)
    private let menuCard = UIView()
    private let historyRow = MenuRowView(iconSystemName: "clock.arrow.circlepath", title: "이용 내역")
    private let myScooterRow = MenuRowView(iconSystemName: "bicycle", title: "내가 등록한 킥보드")
    private let divider = UIView()

    // 버튼(로그아웃, 회원탈퇴)
    private let logoutButton = UIButton(type: .system)
    private let deleteAccountButton = UIButton(type: .system)
    
    // 이용중/이용중아님 변수
    private var isRidingNow: Bool = true

    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "마이페이지"

        setupScrollView() // 스크롤뷰
        setupHeader() // 프로필헤더
        
        setupContentContainer() // 회색 영역(상태카드,메뉴카드,로그아웃/회원탈퇴 버튼)
        setupStatusCard() // 상태카드
        setupMenuCard() // 메뉴카드
        setupLogoutButton() // 로그아웃 버튼
        setupDeleteAccountButton() // 회원탈퇴 버튼
        
        updateStatusUI() // 상태카드 UI 업데이트

        historyRow.addTarget(self, action: #selector(openHistory), for: .touchUpInside)
        myScooterRow.addTarget(self, action: #selector(openMyScooters), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountTapped), for: .touchUpInside)
    }
    
    // 스크롤뷰
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
    }

    // 프로필 헤더
    private func setupHeader() {
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.spacing = 16

        avatar.image = UIImage(systemName: "person.crop.circle.fill")
        avatar.tintColor = .systemBlue
        avatar.layer.cornerRadius = 28
        avatar.clipsToBounds = true
        avatar.snp.makeConstraints { $0.size.equalTo(56) }

        nameLabel.font = .boldSystemFont(ofSize: 22)
        nameLabel.text = "김킥고님"
        emailLabel.font = .systemFont(ofSize: 14)
        emailLabel.textColor = .secondaryLabel
        emailLabel.text = "kickgo@example.com"

        let v = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        v.axis = .vertical
        v.spacing = 4

        headerStack.addArrangedSubview(avatar)
        headerStack.addArrangedSubview(v)

        contentView.addSubview(headerStack)
        headerStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    // 묶음영역
    private func setupContentContainer() {
        contentContainer.backgroundColor = UIColor(red: 0.953, green: 0.957, blue: 0.965, alpha: 1)
        contentContainer.layer.cornerRadius = 16

        contentView.addSubview(contentContainer)
        contentContainer.snp.makeConstraints { make in
            make.top.equalTo(headerStack.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }

        // 내부 구성요소들 추가
        contentContainer.addSubview(statusCard)
        contentContainer.addSubview(menuCard)
        contentContainer.addSubview(logoutButton)
        contentContainer.addSubview(deleteAccountButton)

    }

    // 상태카드
    private func setupStatusCard() {
        // 카드 스타일
        statusCard.backgroundColor = .white
        statusCard.layer.cornerRadius = 16
        statusCard.layer.shadowColor = UIColor.black.cgColor
        statusCard.layer.shadowOpacity = 0.1
        statusCard.layer.shadowOffset = CGSize(width: 0, height: 4)
        statusCard.layer.shadowRadius = 8

        // 이용 중일 때 쓸 컴포넌트들
        scooterImageView.contentMode = .scaleAspectFill
        scooterImageView.clipsToBounds = true
        scooterImageView.layer.cornerRadius = 12
        statusCard.addSubview(scooterImageView)
        scooterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(70)
        }

        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor(red: 0.12, green: 0.15, blue: 0.23, alpha: 1.0)

        subtitleLabel.font = .systemFont(ofSize: 15, weight: .medium)
        subtitleLabel.textColor = .systemGray

        let labelStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 6
        statusCard.addSubview(labelStack)
        labelStack.snp.makeConstraints { make in
            make.leading.equalTo(scooterImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }

        // 이용중 아닐 때 쓸 컴포넌트들
        let centerLabel = UILabel()
        centerLabel.text = "현재 이용 중인 킥보드가 없습니다."
        centerLabel.textAlignment = .center
        centerLabel.textColor = .darkGray
        centerLabel.font = .systemFont(ofSize: 16)
        centerLabel.numberOfLines = 0
        centerLabel.tag = 999 // 나중에 업데이트할 때 찾으려고 태그 만들어둠
        statusCard.addSubview(centerLabel)
        centerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }

        // 카드 위치
        contentContainer.addSubview(statusCard)
        statusCard.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(150)
        }

        updateStatusUI()
    }

    
    // 상태카드 업데이트 메서드
    private func updateStatusUI() {
        let centerLabel = statusCard.viewWithTag(999) as? UILabel

        if isRidingNow {
            // 이용 중
            scooterImageView.isHidden = false
            titleLabel.isHidden = false
            subtitleLabel.isHidden = false
            centerLabel?.isHidden = true

            scooterImageView.image = UIImage(named: "isRidingTrueIcon")
            titleLabel.text = "현재 킥보드 이용중입니다."
            subtitleLabel.text = "안전한 라이딩 부탁드립니다!"
            titleLabel.textColor = UIColor(red: 0.12, green: 0.15, blue: 0.23, alpha: 1.0)
            subtitleLabel.textColor = .systemGray
            statusCard.backgroundColor = .white

        } else {
            // 이용 중 아님
            scooterImageView.isHidden = true
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            centerLabel?.isHidden = false

            statusCard.backgroundColor = UIColor(white: 0.95, alpha: 1)
        }
    }



    // 메뉴카드 (이용내역, 내가 등록한 킥보드)
    private func setupMenuCard() {
        menuCard.backgroundColor = .white
        menuCard.layer.cornerRadius = 12
        menuCard.snp.makeConstraints { make in
            make.top.equalTo(statusCard.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        menuCard.addSubview(historyRow)
        menuCard.addSubview(divider)
        menuCard.addSubview(myScooterRow)

        historyRow.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        divider.backgroundColor = UIColor(white: 0.85, alpha: 1)
        divider.snp.makeConstraints { make in
            make.top.equalTo(historyRow.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(0.5)
        }

        myScooterRow.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    // 로그아웃 버튼
    private func setupLogoutButton() {
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        logoutButton.backgroundColor = .white
        logoutButton.layer.cornerRadius = 12
        contentContainer.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(menuCard.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(52)
        }
    }
    
    // 회원탈퇴 버튼
    private func setupDeleteAccountButton() {
        deleteAccountButton.backgroundColor = .white
        deleteAccountButton.setTitle("회원탈퇴", for: .normal)
        deleteAccountButton.setTitleColor(.systemGray, for: .normal)
        deleteAccountButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        deleteAccountButton.layer.cornerRadius = 12

        deleteAccountButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    // 이용내역 버튼 액션
    @objc private func openHistory() {
        let vc = UIViewController()
        vc.title = "이용 내역"
        vc.view.backgroundColor = .systemBackground
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 내가등록한킥보드 버튼 액션
    @objc private func openMyScooters() {
        let vc = MyRegisterListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 로그아웃 버튼 액션
    @objc private func logoutTapped() {
        let alert = UIAlertController(
            title: "로그아웃 하시겠습니까?",
            message: nil,
            preferredStyle: .alert
        )

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let logout = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            // 1)로그인 상태 초기화
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "isLoggedIn")
            defaults.removeObject(forKey: "loggedInUserID")
            
            // 2)로그인 화면으로 이동
            let loginVC = LoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            nav.modalPresentationStyle = .fullScreen
            
            // 3)현재 윈도우의 루트뷰컨트롤러 교체
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = nav
                window.makeKeyAndVisible()
            }

        }

        alert.addAction(cancel)
        alert.addAction(logout)

        present(alert, animated: true)
    }
    
    // 회원탈퇴 버튼 액션
    @objc private func deleteAccountTapped() {
        let alert = UIAlertController(
            title: "회원 탈퇴 하시겠습니까?",
            message: "탈퇴 후에는 모든 데이터가 삭제됩니다.",
            preferredStyle: .alert
        )

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "탈퇴하기", style: .destructive) { _ in
            let defaults = UserDefaults.standard
            
            // 현재 로그인된 유저 ID 가져오기
            if let userID = defaults.string(forKey: "loggedInUserID") {
                // 해당 유저 정보 삭제
                defaults.removeObject(forKey: userID)
            }
            
            // 로그인 상태 초기화(로그아웃 로직이랑 같음)
            defaults.removeObject(forKey: "isLoggedIn")
            defaults.removeObject(forKey: "loggedInUserID")
            
            // 로그인 화면으로 이동(로그아웃 로직이랑 같음)
            let loginVC = LoginViewController()
            let nav = UINavigationController(rootViewController: loginVC)
            nav.modalPresentationStyle = .fullScreen
            
            // 현재 윈도우의 루트뷰컨트롤러 교체(로그아웃 로직이랑 같음)
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                window.rootViewController = nav
                window.makeKeyAndVisible()
            }
            
        }

        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true)
    }
}

