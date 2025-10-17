import UIKit
import CoreData
import NMapsMap
import CoreLocation

final class MapViewController: UIViewController, MapViewDelegate {
    // 반납하기 누르면 rentViewController로 넘어가게
    func mapViewDidTapReturnButton(_ mapView: MapView) {
        let rentVC = RentViewController()
        rentVC.modalPresentationStyle = .fullScreen
        self.present(rentVC, animated: true, completion: nil)
    }
    
    
    private let mapMainView = MapView()
    private let markerManager = MapMarkerManager()
    private let mapSearchManager = RegisterLocateSettingView() // 지오코딩 담당
    private let locationnManager = MapCurrentLocation()
    // 마커 색상
    private let markerGray = Color9CA3AF  // 배터리 부족
    private let markerGreen  = Color10B981  // 대여 가능
    
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
    }
    
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
                        markerColor = UIColor.systemRed  // hex 설정해놓은거로 사용하니까 red는 색상이 안떠서 systemRed를 사용
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
                            to: self.mapMainView.mapView.mapView ?? NMFMapView(),
                            lat: coordinate.latitude,
                            lng: coordinate.longitude,
                            color: markerColor) {
                                self.presentMarkerSheet()
                            }
                    }
                }
                
            }
        } catch {
            print("킥보드 정보 불러오기 실패")
        }
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
