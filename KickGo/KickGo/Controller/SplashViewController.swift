import UIKit
import SnapKit

class SplashViewController: UIViewController {

    private let logoBgView = UIView()
    private let logoImageView = UIImageView(image: UIImage(systemName: "bicycle"))
    private let appNameImageView = UIImageView(image: UIImage(named: "kickgo_logo_text"))
    private let subtitleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        // 배경색 #EFF6FF
        view.backgroundColor = UIColor(red: 239/255, green: 246/255, blue: 255/255, alpha: 1.0)

        // 앱 이름 이미지 (중앙 기준이 됨)
        appNameImageView.contentMode = .scaleAspectFit
        view.addSubview(appNameImageView)
        appNameImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 1.5초 뒤 메인화면 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            //테스트
            let mainVC = LoginViewController()
            let nav = UINavigationController(rootViewController: mainVC)
            
            nav.modalTransitionStyle = .crossDissolve
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
}

