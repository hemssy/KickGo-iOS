import UIKit
import CoreLocation
import NMapsMap

// 현재 위치 가져오는 
class MapCurrentLocation: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var mapView = NMFMapView()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest  // 거리 정확도 설정
        locationManager.requestWhenInUseAuthorization()  // 위치 서비스 권한 허용하는지 Alert 띄우기

    }
    
    // 사용하가 위치 허용/거부를 선택 or 설정에서 권한 변경 -> iOS가 자동으로 실행해주는 콜백
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation()
        case .notDetermined:
            print("위치 서비스 Off 상태")
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    // 위치 정보 게속 업데이트 -> 위도, 경도 받아오기
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        guard let location = locations.last else { return }
        let lat = location.coordinate.latitude
        let lng = location.coordinate.longitude

        
        // 지도 이동
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1.0
        mapView.moveCamera(cameraUpdate)
        mapView.positionMode = .direction  // 현재 위치 나타내는 파란색 마커
        
    }
    
    
    
}
