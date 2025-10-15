import UIKit
import SnapKit
import NMapsMap

class MapView: UIView {
    
    let mapView = NMFMapView()
    let mapSearchTextField = UITextField()
    let mapSearchImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    // 여백을 위한 UIView
    let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        mapSearchTextField.leftViewMode = .always    }
    
    func setConstraints() {
        [mapSearchTextField, mapView].forEach {
            addSubview($0)
        }
        
        mapSearchTextField.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
            $0.width.equalTo(343)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(mapSearchTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
    }
}
