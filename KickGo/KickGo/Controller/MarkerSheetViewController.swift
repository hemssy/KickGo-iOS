import UIKit
import SnapKit

class MarkerSheetViewController: UIViewController {
    
    private let iconView = UIImageView(image: UIImage(systemName: "bicycle"))
    private let titleLabel = UILabel()
    private let statusLabel = UILabel()
    private let infoStack = UIStackView()
    
    private let notiContainer = UIView()
    private let notiTitleLabel = UILabel()
    private let notiLabel = UILabel()
    private let rentButton = UIButton()
    
    private let closeButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        // 아이콘
        iconView.backgroundColor = UIColor(red: 209/255, green: 250/255, blue: 229/255, alpha: 1)
        iconView.tintColor = UIColor(red: 5/255, green: 150/255, blue: 105/255, alpha: 1)
        iconView.layer.cornerRadius = 16
        iconView.clipsToBounds = true
        iconView.contentMode = .scaleAspectFit
        
        
        // 킥보드 이름
        titleLabel.text = "KickGo Pro"
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        // 상태
        statusLabel.text = "대여 가능"
        statusLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        statusLabel.textColor = UIColor(red: 5/255, green: 150/255, blue: 105/255, alpha: 1)
        
        // 정보 3개 (배터리, 거리, 요금)
        let battery = makeItem(iconName: "battery.100", iconColor: .systemGreen, valueText: "85%", titleText: "배터리")
        let distance = makeItem(iconName: "mappin.and.ellipse", iconColor: .systemBlue, valueText: "50m", titleText: "거리")
        let price = makeItem(iconName: "dollarsign.circle", iconColor: .systemOrange, valueText: "100원", titleText: "분당 요금")
        
        infoStack.axis = .horizontal
        infoStack.alignment = .center
        infoStack.distribution = .equalSpacing
        infoStack.spacing = 24
        [battery, distance, price].forEach { infoStack.addArrangedSubview($0) }
        
        // 이용 안내 영역
        notiContainer.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 251/255, alpha: 1)
        notiContainer.layer.cornerRadius = 12
        
        notiTitleLabel.text = "이용 안내"
        notiTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        notiLabel.numberOfLines = 0
        notiLabel.font = .systemFont(ofSize: 14)
        notiLabel.textColor = .darkGray
        notiLabel.text = """
        • 최소 이용 요금: 500원 (5분)
        
        • 헬멧 착용을 권장합니다
        
        • 지정된 주차 구역에 반납해주세요
        """
        
        // 버튼
        rentButton.setTitle("대여하기", for: .normal)
        rentButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        rentButton.setTitleColor(.white, for: .normal)
        rentButton.backgroundColor = UIColor(red: 37/255, green: 99/255, blue: 235/255, alpha: 1)
        rentButton.layer.cornerRadius = 14
        
        // 닫기 버튼
        let config = UIImage.SymbolConfiguration(pointSize: 11, weight: .medium)
        closeButton.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        closeButton.tintColor = .gray
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
    }
    
    func setConstraints() {
        [iconView, titleLabel, statusLabel, infoStack, notiContainer, rentButton, closeButton].forEach { view.addSubview($0) }
        [notiTitleLabel, notiLabel].forEach { notiContainer.addSubview($0) }
        
        iconView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(24)
            $0.width.height.equalTo(64)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconView.snp.top).offset(12)
            $0.leading.equalTo(iconView.snp.trailing).offset(14)
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel)
        }
        
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        infoStack.snp.makeConstraints {
            $0.top.equalTo(iconView.snp.bottom).offset(26)
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        notiContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(rentButton.snp.top).offset(-30)
        }
        
        notiTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(18)
        }
        
        notiLabel.snp.makeConstraints {
            $0.top.equalTo(notiTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        rentButton.snp.makeConstraints {
            $0.top.equalTo(notiContainer.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(60)
            $0.width.equalTo(327)
            $0.bottom.equalToSuperview().offset(-55)
        }
    }
    
    @objc func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    // 아이콘 + 값 + 제목
    func makeItem(iconName: String, iconColor: UIColor, valueText: String, titleText: String) -> UIView {
        let iconView = UIImageView(image: UIImage(systemName: iconName))
        iconView.tintColor = iconColor
        iconView.snp.makeConstraints { $0.size.equalTo(14) }
        
        let valueLabel = UILabel()
        valueLabel.text = valueText
        valueLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .gray
        
        let topStack = UIStackView(arrangedSubviews: [iconView, valueLabel])
        topStack.axis = .horizontal
        topStack.spacing = 4
        
        let fullStack = UIStackView(arrangedSubviews: [topStack, titleLabel])
        fullStack.axis = .vertical
        fullStack.alignment = .center
        fullStack.spacing = 4
        
        return fullStack
    }
}
