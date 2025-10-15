import UIKit
import NMapsMap

final class MapViewController: UIViewController {

    private let mapMainView = MapView()
    private let markerManager = MapMarkerManager()
    private let mapSearchManager = RegisterLocateSettingView() // 지오코딩 담당

    override func loadView() {
        view = mapMainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "지도"
        
        setupSearchAction()
        setupMarkers()
    }

    private func setupSearchAction() {
        mapMainView.mapSearchTextField.addTarget(self, action: #selector(mapLocationSearch), for: .editingDidEndOnExit)
    }

    private func setupMarkers() {
        // 빨간색 마커
        markerManager.addMarker(to: mapMainView.mapView, lat: 37.3497, lng: 127.1171,
                                color: UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1)) { [weak self] in
            self?.presentMarkerSheet()
        }

        // 초록색 마커
        markerManager.addMarker(to: mapMainView.mapView, lat: 37.3595704, lng: 127.105399,
                                color: UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1)) { [weak self] in
            self?.presentMarkerSheet()
        }

        // 회색 마커
        markerManager.addMarker(to: mapMainView.mapView, lat: 37.3500, lng: 127.10899,
                                color: UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1)) { [weak self] in
            self?.presentMarkerSheet()
        }
    }

    // 장소 검색 -> 위치 -> 위도, 경도로 변환
    @objc private func mapLocationSearch() {
        guard let query = mapMainView.mapSearchTextField.text, !query.isEmpty else { return }
        print("mapLocationSearch query:", query)
        mapSearchManager.geocode(query: query)
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
