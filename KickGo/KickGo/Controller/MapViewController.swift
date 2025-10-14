import UIKit
import SnapKit
import NMapsMap

class MapViewController: UIViewController {
    
    let mapView = NMFMapView()
    let searchTextField = UITextField()
    let searchImageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    // 여백을 위한 UIView
    let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "지도"
        
        configureUI()
        setConstraints()
    }
    
    func configureUI() {
        // 돋보기 이미지
        searchImageView.tintColor = .gray
        searchImageView.contentMode = .scaleAspectFit
        
        // 여백을 위한
        searchImageView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        iconContainer.addSubview(searchImageView)
        searchImageView.center.y = iconContainer.center.y
        
        // 검색창 UI
        searchTextField.placeholder = "어디로 갈까요?"
        searchTextField.tintColor = .gray
        searchTextField.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 251/255, alpha: 1)
        searchTextField.layer.cornerRadius = 10
        searchTextField.leftView = iconContainer
        searchTextField.leftViewMode = .always
    }
    
    func setConstraints() {
        [searchTextField, mapView].forEach {
            view.addSubview($0)
        }

        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(56)
            $0.width.equalTo(343)
        }
        
        mapView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }

    }
}
