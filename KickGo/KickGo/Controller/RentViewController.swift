import UIKit
import CoreLocation
import NMapsMap
import SnapKit

class RentViewController: UIViewController, CLLocationManagerDelegate {
    var mapView: MapView?
    
    private let titleLabel = UILabel()
    private let backButton = UIButton()
    
    private let returnInfo = UIView()
    private let scooterLabel = UILabel()
    private let timeLabel = UILabel()
    private let priceLabel = UILabel()
    
    private let sectionTitleLabel = UILabel()
    private let returnMap = NMFNaverMapView()
    
    private let currentLocationButton = UIButton()
    private let returnCompletedButton = UIButton()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureUI()
        setConstraints()
        setupLocationManager()
    }
    
    func configureUI() {
        
        titleLabel.text = "킥보드 반납"
        timeLabel.font = .boldSystemFont(ofSize: 18)

        // 정보 카드
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
        returnMap.mapView.positionMode = .disabled
        
        // 현재 위치 버튼
        currentLocationButton.setTitle("현재 위치로 반납", for: .normal)
        currentLocationButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        currentLocationButton.setTitleColor(.gray, for: .normal)
        currentLocationButton.layer.cornerRadius = 12
        currentLocationButton.layer.borderWidth = 1
        currentLocationButton.layer.borderColor = UIColor.lightGray.cgColor
        currentLocationButton.addTarget(self, action: #selector(didTapCurrentLocationButton), for: .touchUpInside)
        
        // 반납 완료 버튼
        returnCompletedButton.setTitle("반납 완료", for: .normal)
        returnCompletedButton.setTitleColor(.white, for: .normal)
        returnCompletedButton.backgroundColor = Color2563EB
        returnCompletedButton.layer.cornerRadius = 12
        returnCompletedButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        returnCompletedButton.addTarget(self, action: #selector(didTapComplete), for: .touchUpInside)
        
        [backButton, titleLabel, returnInfo, sectionTitleLabel, returnMap, currentLocationButton, returnCompletedButton].forEach {
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
            $0.top.equalTo(returnInfo.snp.bottom).offset(22)
            $0.leading.equalTo(returnInfo)
        }
        
        returnMap.snp.makeConstraints {
            $0.top.equalTo(sectionTitleLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalTo(returnInfo)
            $0.height.equalTo(256)
        }

        currentLocationButton.snp.makeConstraints {
            $0.top.equalTo(returnMap.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(returnInfo)
            $0.height.equalTo(60)
        }

        returnCompletedButton.snp.makeConstraints {
            $0.top.equalTo(currentLocationButton.snp.bottom).offset(64)
            $0.leading.trailing.equalTo(returnInfo)
            $0.height.equalTo(55)
        }
    }
    
    // 위치 설정
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    // 현재 위치 버튼 동작
    @objc func didTapCurrentLocationButton() {
        currentLocationButton.layer.borderWidth = 2
        currentLocationButton.layer.borderColor = Color2563EB.cgColor
        currentLocationButton.backgroundColor = UIColor(red: 239/255, green: 246/255, blue: 255/255, alpha: 1)
        currentLocationButton.setTitleColor(Color2563EB, for: .normal)
        
        // 현재 위치 가져오기
        guard let location = locationManager.location else {
            print("현재 위치 정보를 가져올 수 없습니다.")
            return
        }
        let lat = location.coordinate.latitude
        let lng = location.coordinate.longitude
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1.0
        returnMap.mapView.moveCamera(cameraUpdate)
        
        // 마커 표시
        func returnMarker(lat: Double, lng: Double) {
            // 마커 표시
            let marker = NMFMarker(position:NMGLatLng(lat: lat, lng: lng))
            marker.iconImage = NMF_MARKER_IMAGE_RED
            if let sym = UIImage(systemName: "mappin.and.ellipse") {
                marker.iconImage = NMFOverlayImage(image: sym)
            } else {
                marker.iconImage = NMF_MARKER_IMAGE_BLACK
            }
            marker.mapView = returnMap.mapView
        }
        returnMarker(lat: lat, lng: lng)
    }
    
    // 반납 완료 버튼 누르면
    @objc func didTapComplete() {
        let alert = UIAlertController(title: nil, message: "킥보드가 성공적으로 반납되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self else { return }
            print("반납 완료")
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
}
