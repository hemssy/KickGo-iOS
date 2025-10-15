import UIKit
import SnapKit
import NMapsMap

class MapViewController: UIViewController {
    
    let mapView = NMFMapView()
    let mapSearchTextField = UITextField()
    let mapSearchImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    // 여백을 위한 UIView
    let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
    let markerManager = MapMarkerManager()
    let mapSearchManager = RegisterLocateSettingView()  // geocode 함수가 들어있는 클래스
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "지도"
        
        configureUI()
        setConstraints()
    }
    
    func configureUI() {
        // 돋보기 이미지
        mapSearchImageView.tintColor = .gray
        mapSearchImageView.contentMode = .scaleAspectFit
        
        // 여백을 위한
        mapSearchImageView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        iconContainer.addSubview(mapSearchImageView)
        mapSearchImageView.center.y = iconContainer.center.y
        
        // 검색창 UI
        mapSearchTextField.placeholder = "어디로 갈까요?"
        mapSearchTextField.tintColor = .gray
        mapSearchTextField.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 251/255, alpha: 1)
        mapSearchTextField.layer.cornerRadius = 10
        mapSearchTextField.leftView = iconContainer
        mapSearchTextField.leftViewMode = .always
        mapSearchTextField.addTarget(self, action: #selector(mapLocationSearch), for: .editingDidEndOnExit)
        
        // 지도에 빨간색 마커 추가
        markerManager.addMarker(to: mapView, lat: 37.3497, lng: 127.1171, color: UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1))
        { [weak self] in
            self?.presentMarkerSheet()
        }
        
        
        // 지도에 초록색 마커 추가
        markerManager.addMarker(to: mapView, lat: 37.3595704, lng: 127.105399, color: UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 1))
        { [weak self] in
            self?.presentMarkerSheet()
        }
        
        // 지도에 회색 마커 추가
        markerManager.addMarker(to: mapView, lat: 37.3500, lng: 127.10899, color: UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1))
        { [weak self] in
            self?.presentMarkerSheet()
        }
    }
    
    func setConstraints() {
        [mapSearchTextField, mapView].forEach {
            view.addSubview($0)
        }
        
        mapSearchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
            $0.width.equalTo(343)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(mapSearchTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
    }
    
    // 지도탭에서 장소 검색
    @objc func mapLocationSearch() {
        guard let query = mapSearchTextField.text, !query.isEmpty else { return }
        print("mapLocationSearch query:", query)
        mapSearchManager.geocode(query: query)
    }

}

// 시트 띄우기
extension MapViewController {
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
