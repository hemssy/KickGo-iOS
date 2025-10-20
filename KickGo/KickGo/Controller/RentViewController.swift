import UIKit
import CoreLocation
import NMapsMap
import SnapKit

class RentViewController: UIViewController, CLLocationManagerDelegate {
    var mapView: MapView?
    
    private let titleLabel = UILabel()
    private let backButton = UIButton()
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
        // 타이틀
        titleLabel.text = "킥보드 반납"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        
        // 뒤로가기 버튼 (필요시 아이콘 추가)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        // 섹션 타이틀
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
        
        [backButton, titleLabel, sectionTitleLabel, returnMap, currentLocationButton, returnCompletedButton].forEach {
            view.addSubview($0)
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

        sectionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(22)
            $0.leading.equalToSuperview().inset(16)
        }
        
        returnMap.snp.makeConstraints {
            $0.top.equalTo(sectionTitleLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(256)
        }

        currentLocationButton.snp.makeConstraints {
            $0.top.equalTo(returnMap.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(60)
        }

        returnCompletedButton.snp.makeConstraints {
            $0.top.equalTo(currentLocationButton.snp.bottom).offset(64)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(55)
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @objc func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc func didTapCurrentLocationButton() {
        currentLocationButton.layer.borderWidth = 2
        currentLocationButton.layer.borderColor = Color2563EB.cgColor
        currentLocationButton.backgroundColor = UIColor(red: 239/255, green: 246/255, blue: 255/255, alpha: 1)
        currentLocationButton.setTitleColor(Color2563EB, for: .normal)
        
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
        let marker = NMFMarker(position: NMGLatLng(lat: lat, lng: lng))
        if let sym = UIImage(systemName: "mappin.and.ellipse") {
            marker.iconImage = NMFOverlayImage(image: sym)
        }
        marker.mapView = returnMap.mapView
    }
    
    @objc func didTapComplete() {
        let defaults = UserDefaults.standard
        
        guard let userEmail = defaults.string(forKey: "loggedInUserID"),
              let startTime = defaults.object(forKey: "rentalStartTime") as? Date,
              let scooterModel = defaults.string(forKey: "rentedScooterModel") else {
            print("""
            필요한 데이터가 없습니다.
            loggedInUserID: \(defaults.string(forKey: "loggedInUserID") ?? "nil")
            rentalStartTime: \(String(describing: defaults.object(forKey: "rentalStartTime")))
            rentedScooterModel: \(defaults.string(forKey: "rentedScooterModel") ?? "nil")
            """)
            return
        }

        // 이용 종료 시각
        let endTime = Date()
        // 총 이용 시간(분 단위임)
        let duration = endTime.timeIntervalSince(startTime) / 60
        // 요금 계산 (기본요금 500 + 분당 100원)
        let payment = Int32(500 + Int(duration) * 100)
        
        // 코어데이터 저장
        let ctx = CoreDataStack.context
        let record = RentalScooterEntity(context: ctx)
        record.id = UUID()
        record.userEmail = userEmail
        record.scooterModel = scooterModel
        record.startTime = startTime
        record.endTime = endTime
        record.duration = duration
        record.payment = payment

        do {
            try ctx.save()
            print("반납 내역 코어데이터 저장 완료")
        } catch {
            print("코어데이터 저장 실패: \(error.localizedDescription)")
        }

        // 상태 초기화
        defaults.removeObject(forKey: "rentalStartTime")
        defaults.removeObject(forKey: "rentedScooterModel")
        defaults.set(false, forKey: "isRidingNow_\(userEmail)")
        NotificationCenter.default.post(name: .ridingStatusChanged, object: nil)

        // 완료 알럿
        let alert = UIAlertController(
            title: "반납 완료",
            message: "이용 내역이 저장되었습니다.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }

}

