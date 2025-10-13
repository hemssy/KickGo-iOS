import UIKit
import SnapKit
import NMapsMap

class MapViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "지도"
        
        let mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
    }
}

