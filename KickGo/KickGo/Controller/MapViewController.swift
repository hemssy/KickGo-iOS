import UIKit
import CoreData
import NMapsMap
import CoreLocation

class MapViewController: UIViewController, MapViewDelegate, MarkerSheetDelegate {
    // delegate 채택
    func didRentScooter(_ scooter: ScooterEntity) {
        markerManager.removeMarker(for: scooter)
        print("마커 제거 완료")
    }
    
    // 반납하기 누르면 rentViewController로 넘어가게
    func mapViewDidTapReturnButton(_ mapView: MapView) {
        let rentVC = RentViewController()
        rentVC.modalPresentationStyle = .fullScreen
        self.present(rentVC, animated: true, completion: nil)
    }
    
    private let mapMainView = MapView()
    private let markerManager = MapMarkerManager()
    private let mapSearchManager = RegisterLocateSettingView()
    private let locationnManager = MapCurrentLocation()
    
    // 마커 색상
    private let markerGray = Color9CA3AF  // 배터리 부족
    private let markerGreen  = Color10B981  // 대여 가능
    
    
    private var timer: Timer? // 타이머
    private var totalSeconds = 0 //토탈 초

    override func loadView() {
        view = mapMainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "지도"
        
      mapMainView.delegate = self
      
        setupSearchAction()
        onCoordinateFound()
        setupLocationManager()
        loadRegisterScooters()
        
        // 알림수신 블럭!! 이거 있어야 대여하기 누를 때 바로 반영됨
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ridingStatusChanged),
            name: .ridingStatusChanged,
            object: nil
        )
        
        //
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNewScooter),
            name: NSNotification.Name("NewScooter"),
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateReturnCardVisibility()
    }
    
    // 로그인 후 홈 화면으로 갔을 때 '위치 서비스 권한 허용 Alert' 띄우기
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationnManager.requestAuthorization()
    }
    
    @objc private func ridingStatusChanged() {
        updateReturnCardVisibility()
        
        let defaults = UserDefaults.standard
        if let userID = defaults.string(forKey: "loggedInUserID") {
            let isRidingNow = defaults.bool(forKey: "isRidingNow_\(userID)")
            
            if isRidingNow {
                startRideTimer()
            } else {
                stopRideTimer()
            }
        }
    }
    
    @objc private func handleNewScooter(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let scooter = userInfo["scooter"] as? ScooterEntity else { return }
        
        guard let position = scooter.position else { return }
        let batteryLevel = Int(scooter.battery)
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(position) { [weak self] locationMarks, error in
            guard let self = self else { return }
            
            let markerColor: UIColor
            if batteryLevel < 20 {
                markerColor = UIColor.systemRed
            } else if batteryLevel < 70 {
                markerColor = self.markerGray
            } else {
                markerColor = self.markerGreen
            }
            
            if let error = error {
                print("새 킥보드 지오코딩 실패 \(position)")
                return
            }
            guard let coordinate = locationMarks?.first?.location?.coordinate else {
                print("새 킥보드 좌표 변환 실패 \(position)")
                return
            }
            print("새 킥보드 지오코딩 성공! \(position) 위도: \(coordinate.latitude), 경도: \(coordinate.longitude)")
            
            // 마커 추가 작업은 메인 스레드에서
            DispatchQueue.main.async {
                self.markerManager.addMarker(
                    to: self.mapMainView.mapView.mapView,
                    scooter: scooter,
                    lat: coordinate.latitude,
                    lng: coordinate.longitude,
                    color: markerColor) { ScooterEntity in
                        // 정보 받은 토대로 시트 띄우기
                        let sheet = MarkerSheetViewController()
                        sheet.modalPresentationStyle = .pageSheet
                        sheet.scooter = ScooterEntity
                        sheet.delegate = self
                        
                        if let sheetController = sheet.sheetPresentationController {
                            sheetController.detents = [.medium()]  // 시트는 중간 높이까지만
                        }
                        self.present(sheet, animated: true)
                    }
            }
        }
    }

    // 반납버튼(파란색스택) 표시여부 업데이트하는 함수
    // 대여중이면 표시하고, 대여중아니면 숨긴다.
    private func updateReturnCardVisibility() {
        let defaults = UserDefaults.standard
        if let userID = defaults.string(forKey: "loggedInUserID") {
            let isRidingNow = defaults.bool(forKey: "isRidingNow_\(userID)")
            mapMainView.returnContainerView.isHidden = !isRidingNow
        }
    }
 
    
    // 현재 이용 상태를 읽어서 반납카드 표시여부 업데이트함
    private func setupSearchAction() {
        mapMainView.mapSearchTextField.addTarget(self, action: #selector(mapLocationSearch), for: .editingDidEndOnExit)
    }
    
    // 장소 검색 -> 위치 -> 위도, 경도로 변환
    @objc private func mapLocationSearch() {
        guard let query = mapMainView.mapSearchTextField.text, !query.isEmpty else { return }
        print("mapLocationSearch query:", query)
        mapSearchManager.geocode(query: query)
    }
    
    private func moveCamera(lat: Double, lng: Double) {
        let latLng = NMGLatLng(lat: lat, lng: lng)
        let cameraUpdate = NMFCameraUpdate(scrollTo: latLng)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1.0
        mapMainView.mapView.mapView.moveCamera(cameraUpdate)
        
        // 마커 표시
        let marker = NMFMarker(position: latLng)
        marker.iconImage = NMF_MARKER_IMAGE_RED
        if let sym = UIImage(systemName: "mappin.and.ellipse") {
            marker.iconImage = NMFOverlayImage(image: sym)
        } else {
            marker.iconImage = NMF_MARKER_IMAGE_BLACK
        }
        marker.mapView = mapMainView.mapView.mapView
    }
    
    func onCoordinateFound() {
        // RegisterLocateSettingView가 좌표를 찾으면 moveCamera 실행
        mapSearchManager.onCoordinateFound = { [weak self] lat, lng in
            self?.moveCamera(lat: lat, lng: lng)
        }
    }
    
    func setupLocationManager() {
        // locationManager의 mapView를 현재 지도와 연결
        locationnManager.mapView = mapMainView.mapView.mapView
    }
    
    // 킥보드 데이터를 가져와서 위도, 경도로 변환 -> 지도에 마커 표시
    func loadRegisterScooters() {
        let context = CoreDataStack.context
        let request: NSFetchRequest<ScooterEntity> = ScooterEntity.fetchRequest()
        
        do {
            let scooters = try context.fetch(request)
            print("저장된 킥보드 개수: \(scooters.count)")
            
            // 킥보드 데이터를 반복해서 주소 -> 좌표로 변환
            for (index, s) in scooters.enumerated() {
                
                let geocoder = CLGeocoder()  // 각 요청마다 새로운 CLGeocoder 생성
                let batteryLevel = Int(s.battery)
                
                guard let position = s.position else { continue }
                print("\(index)번째 지오코딩 요청 주소: \(position)")
                
                geocoder.geocodeAddressString(position) { [weak self] locationMarks, error in
                    guard let self = self else { return }
                    print("\(index)의 배터리: \(batteryLevel)")
                    let markerColor: UIColor
                    
                    if batteryLevel < 20 {
                        markerColor = UIColor.systemRed 
                    } else if batteryLevel < 70 {
                        markerColor = self.markerGray
                    } else {
                        markerColor = self.markerGreen
                    }
                    
                    if let error = error {
                        print("\(index) 지오코딩 실패 \(position)")
                        return
                    }
                    guard let coordinate = locationMarks?.first?.location?.coordinate else {
                        print("\(index) 좌표 변환 실패 \(position)")
                        return
                    }
                    print("\(index) 지오코딩 성공! \(position) 위도: \(coordinate.latitude), 경도: \(coordinate.longitude)")
                    
                    // 마커 추가 작업은 메인 스레드에서
                    DispatchQueue.main.async {
                        self.markerManager.addMarker(
                            to: self.mapMainView.mapView.mapView,
                            scooter: s,
                            lat: coordinate.latitude,
                            lng: coordinate.longitude,
                            color: markerColor) { ScooterEntity in
                                // 정보 받은 토대로 시트 띄우기
                                let sheet = MarkerSheetViewController()
                                sheet.modalPresentationStyle = .pageSheet
                                sheet.scooter = ScooterEntity
                                sheet.delegate = self
                                
                                if let sheetController = sheet.sheetPresentationController {
                                    sheetController.detents = [.medium()]
                                }
                                self.present(sheet, animated: true)
                            }
                    }
                }
                
            }
        } catch {
            print("킥보드 정보 불러오기 실패")
        }
    }
    
    // 타이머 로직
    private func startRideTimer() {
        totalSeconds = 0
        timer?.invalidate()
        updateTimerUI()

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.totalSeconds += 1
            self.updateTimerUI()
        }
    }

    private func stopRideTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTimerUI() {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        let fee = 500 + (minutes * 100)
        
        DispatchQueue.main.async {
            self.mapMainView.timeLabel.text = String(format: "%d:%02d", minutes, seconds)
            self.mapMainView.priceLabel.text = "현재 요금: \(fee)원"
        }
    }
    
    // 대여 시작 로직 (유저디폴트 임시 저장)
    func startRide(for scooterModel: String) {
        let defaults = UserDefaults.standard
        defaults.set(Date(), forKey: "rentalStartTime")              // 대여 시작 시간
        defaults.set(scooterModel, forKey: "rentedScooterModel")     // 킥보드 모델명
        defaults.synchronize()
        
        // 대여 상태 true
        if let userID = defaults.string(forKey: "loggedInUserID") {
            defaults.set(true, forKey: "isRidingNow_\(userID)")
        }

        NotificationCenter.default.post(name: .ridingStatusChanged, object: nil)
        print("대여 시작 정보 저장 완료 (\(scooterModel))")
    }
}

extension MapViewController {
    
    // 마커 누르면 시트 띄우기
    func presentMarkerSheet() {
        let sheetVC = MarkerSheetViewController()
        sheetVC.modalPresentationStyle = .pageSheet
        
        if let sheet = sheetVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.preferredCornerRadius = 20
        }
        present(sheetVC, animated: true)
    }
}
