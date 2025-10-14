import UIKit
import SnapKit

// 행(아이콘 + 타이틀 + >)
class MenuRowView: UIControl {
    private let iconBg = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))

    init(iconSystemName: String, title: String) {
        super.init(frame: .zero)
        setupUI(iconSystemName: iconSystemName, title: title)
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setupUI(iconSystemName: String, title: String) {
        iconBg.layer.cornerRadius = 10
        iconBg.backgroundColor = UIColor(red: 0.953, green: 0.957, blue: 0.965, alpha: 1) // #F3F4F6
        
        addSubview(iconBg)
        iconBg.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }

        iconView.image = UIImage(systemName: iconSystemName)
        iconBg.addSubview(iconView)
        iconView.snp.makeConstraints { $0.center.equalToSuperview() }

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconBg.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }

        addSubview(chevron)
        chevron.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        snp.makeConstraints { $0.height.equalTo(64) }
    }
}

class MyViewController: UIViewController {

    private let headerStack = UIStackView()
    private let avatar = UIImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()

    // 프로필 헤더 밑에 영역(배경 #F3F4F6)
    private let contentContainer = UIView()

    private let statusCard = UIView()
    private let statusLabel = UILabel()

    private let menuCard = UIView()
    private let historyRow = MenuRowView(iconSystemName: "clock.arrow.circlepath", title: "이용 내역")
    private let myScooterRow = MenuRowView(iconSystemName: "bicycle", title: "내가 등록한 킥보드")
    private let divider = UIView()

    private let logoutButton = UIButton(type: .system)

    private var isRidingNow: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "마이페이지"

        setupHeader()
        setupContentContainer()
        updateStatus()

        historyRow.addTarget(self, action: #selector(openHistory), for: .touchUpInside)
        myScooterRow.addTarget(self, action: #selector(openMyScooters), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }

    // 프로필헤더
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

        view.addSubview(headerStack)
        headerStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    // 묶음영역
    private func setupContentContainer() {
        
        contentContainer.backgroundColor = UIColor(red: 0.953, green: 0.957, blue: 0.965, alpha: 1) // #F3F4F6
        contentContainer.layer.cornerRadius = 16

        view.addSubview(contentContainer)
        contentContainer.snp.makeConstraints { make in
            make.top.equalTo(headerStack.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(16)
        }

        // 내부 구성요소들 추가
        contentContainer.addSubview(statusCard)
        contentContainer.addSubview(menuCard)
        contentContainer.addSubview(logoutButton)

        setupStatusCard()
        setupMenuCard()
        setupLogout()
    }

    // 상태카드
    private func setupStatusCard() {
        statusCard.backgroundColor = .white
        statusCard.layer.cornerRadius = 12

        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        statusLabel.font = .systemFont(ofSize: 16)
        statusCard.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { $0.edges.equalToSuperview().inset(20) }

        statusCard.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(250)
        }
    }

    private func updateStatus() {
        statusLabel.text = isRidingNow
        ? "현재 이용 중인 킥보드가 있습니다."
        : "현재 이용 중인 킥보드가 없습니다."
    }

    // 메뉴카드 (내 이용내역 / 내가 등록한 킥보드)
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
    private func setupLogout() {
        logoutButton.backgroundColor = .white
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.setTitleColor(.systemRed, for: .normal)
        logoutButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        logoutButton.layer.cornerRadius = 12

        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(menuCard.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    // 버튼액션
    @objc private func openHistory() {
        let vc = UIViewController()
        vc.title = "이용 내역"
        vc.view.backgroundColor = .systemBackground
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func openMyScooters() {
        let vc = UIViewController()
        vc.title = "내가 등록한 킥보드"
        vc.view.backgroundColor = .systemBackground
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func logoutTapped() {
        print("로그아웃 탭")
    }
}

