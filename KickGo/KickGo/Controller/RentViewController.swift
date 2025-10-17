import UIKit
import CoreLocation
import NMapsMap
import SnapKit

class RentViewController: UIViewController {
    private let titleLabel = UILabel()
    private let backButton = UIButton()
    
    private let returnInfo = UIView()
    private let scooterLabel = UILabel()
    private let timeLabel = UILabel()
    private let priceLabel = UILabel()
    
    private let sectionTitleLabel = UILabel()
    private let returnMap = UIImageView()
    
    private let currentLocationButton = UIButton()
    private let addressButton = UIButton()
    
    private let returnCompletedButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureUI()
        setConstraints()
        
    }
    
    func configureUI() {
        // 상단
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        titleLabel.text = "킥보드 반납"
        timeLabel.font = .boldSystemFont(ofSize: 18)

        // 정보 카드 뷰
        returnInfo.backgroundColor = UIColor(red: 239/255, green: 246/255, blue: 255/255, alpha: 1)
        returnInfo.layer.cornerRadius = 16
        
        scooterLabel.text = "KickGo Pro(LG001)"
        scooterLabel.font = .boldSystemFont(ofSize: 16)
        scooterLabel.textColor = Color2563EB
    
        timeLabel.text = "이용 시간: 30분 47초"
        timeLabel.font = .boldSystemFont(ofSize: 16)
        timeLabel.textColor = Color2563EB
        
        priceLabel.text = "요금: 1,500원"
        priceLabel.font = .boldSystemFont(ofSize: 16)
        priceLabel.textColor = Color2563EB
        
        sectionTitleLabel.text = "반납 위치 선택"
        sectionTitleLabel.font = .boldSystemFont(ofSize: 16)
        
        // 지도
        returnMap.backgroundColor = .gray
        returnMap.layer.cornerRadius = 8
        
        // 위치 선택 버튼
        currentLocationButton.setTitle("현재 위치로 반납", for: .normal)
        currentLocationButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        currentLocationButton.setTitleColor(.gray, for: .normal)
        currentLocationButton.layer.cornerRadius = 12
        currentLocationButton.layer.borderWidth = 1
        currentLocationButton.layer.borderColor = UIColor.lightGray.cgColor
        
        // 반납 완료 버튼
        returnCompletedButton.setTitle("반납 완료", for: .normal)
        returnCompletedButton.setTitleColor(.white, for: .normal)
        returnCompletedButton.backgroundColor = Color2563EB
        returnCompletedButton.layer.cornerRadius = 12
        returnCompletedButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        returnCompletedButton.addTarget(self, action: #selector(didTapComplete), for: .touchUpInside)
        
        [backButton, titleLabel, returnInfo, sectionTitleLabel, returnMap, currentLocationButton, addressButton, returnCompletedButton].forEach {
            view.addSubview($0)
        }
        [scooterLabel, timeLabel, priceLabel].forEach {
            returnInfo.addSubview($0)
        }
        
    }
    
    func setConstraints() {
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalToSuperview().inset(16)
            $0.size.equalTo(30)
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
             $0.leading.equalTo(backButton.snp.trailing).offset(10)
        }

        returnInfo.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }

        scooterLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(12)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(scooterLabel.snp.bottom).offset(8)
            $0.leading.equalTo(scooterLabel)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(8)
            $0.leading.equalTo(scooterLabel)
        }
        
        sectionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(returnInfo.snp.bottom).offset(22) // returnInfo 카드 아래에 위치
            $0.leading.equalTo(returnInfo) // returnInfo와 같은 선상에 위치
        }
        
        // 6. returnMap (지도 - sectionTitleLabel 기준)
        returnMap.snp.makeConstraints {
            $0.top.equalTo(sectionTitleLabel.snp.bottom).offset(14) // 타이틀 아래에 위치
            $0.leading.trailing.equalTo(returnInfo) // returnInfo와 동일한 좌우 여백 사용
            $0.height.equalTo(256)
        }

        currentLocationButton.snp.makeConstraints {
            $0.top.equalTo(returnMap.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(returnInfo)
            $0.height.equalTo(60)
        }

        addressButton.snp.makeConstraints {
            $0.top.equalTo(currentLocationButton.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(returnInfo)
            $0.height.equalTo(50)
        }

        returnCompletedButton.snp.makeConstraints {
            $0.top.equalTo(addressButton.snp.bottom).offset(32)
            $0.leading.trailing.equalTo(returnInfo)
            $0.height.equalTo(55)
        }
    }
    
    @objc func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc func didTapComplete() {
        let alert = UIAlertController(title: nil, message: "킥보드가 성공적으로 반납되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true)
    }
}
