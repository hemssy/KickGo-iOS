import UIKit
import SnapKit
import NMapsMap

protocol MapViewDelegate: AnyObject {
    func mapViewDidTapReturnButton(_ mapView: MapView)
}

class MapView: UIView {
    
    let mapView = NMFNaverMapView()
    let mapSearchTextField = UITextField()
    let mapSearchImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    private let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
    weak var delegate: MapViewDelegate?
    
    // 반납 카드
    let returnContainerView = UIView()
    let returnButton = UIButton()
    let timeLabel = UILabel()
    let priceLabel = UILabel()
    
    // 전체 스택뷰
    private let mainStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        // 검색창
        mapSearchImageView.tintColor = .gray
        mapSearchImageView.contentMode = .scaleAspectFit
        iconContainer.addSubview(mapSearchImageView)
        mapSearchImageView.center = iconContainer.center
        
        mapSearchTextField.placeholder = "어디로 갈까요?"
        mapSearchTextField.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 251/255, alpha: 1)
        mapSearchTextField.layer.cornerRadius = 10
        mapSearchTextField.leftView = iconContainer
        mapSearchTextField.leftViewMode = .always
        
        // 지도
        mapView.showZoomControls = true
        mapView.showLocationButton = true
        
        // 반납 카드
        returnContainerView.backgroundColor = .systemBlue
        returnContainerView.layer.cornerRadius = 16
        returnContainerView.isHidden = true  // 기본적으로 숨겨져있는 상태!
        
        timeLabel.text = "0:02"
        timeLabel.font = .boldSystemFont(ofSize: 24)
        timeLabel.textColor = .white
        
        priceLabel.text = "현재 요금: 500원"
        priceLabel.font = .systemFont(ofSize: 14)
        priceLabel.textColor = .white
        
        returnButton.setTitle("반납하기", for: .normal)
        returnButton.backgroundColor = .white
        returnButton.layer.cornerRadius = 12
        returnButton.setTitleColor(.systemBlue, for: .normal)
        returnButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        returnButton.addTarget(self, action: #selector(didTapReturnButton), for: .touchUpInside)
        
        [timeLabel, priceLabel, returnButton].forEach {
            returnContainerView.addSubview($0)
        }
        
        // 스택뷰 설정
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        addSubview(mainStackView)
        
        [mapSearchTextField, returnContainerView, mapView].forEach {
            mainStackView.addArrangedSubview($0)
        }
    }
    
    private func setConstraints() {
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        mapSearchTextField.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        returnContainerView.snp.makeConstraints {
            $0.height.equalTo(113)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.equalToSuperview().inset(16)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(8)
            $0.leading.equalTo(timeLabel)
        }
        
        returnButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(45)
        }
    }
    
    // 이용중일 때 표시
    func showReturnCard() {
        returnContainerView.isHidden = false
    }
    
    // 반납하기 눌렀을 때
    @objc func didTapReturnButton() {
        print("반납하기")
    
        // 이용 상태 false 로 변경
        let defaults = UserDefaults.standard
        if let userID = defaults.string(forKey: "loggedInUserID") {
            defaults.set(false, forKey: "isRidingNow_\(userID)")
        }
     
        // 버튼을 누르면 반납 절차화면으로
      delegate?.mapViewDidTapReturnButton(self)

        // 다른 화면(MyViewController 등)에 알림 보내기
        NotificationCenter.default.post(name: .ridingStatusChanged, object: nil)
    }
}
