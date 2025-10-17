import NMapsMap

class MapMarkerManager {
    
    func addMarker( to mapView: NMFMapView, scooter: ScooterEntity, lat: Double, lng: Double, color: UIColor, onTap: ((ScooterEntity) -> Void)? = nil)
    {
        let marker = NMFMarker()
        
        marker.position = NMGLatLng(lat: lat, lng: lng)
        marker.iconImage = NMFOverlayImage(image: makeMarkerImage(color: color))
        marker.mapView = mapView
        
        // 마커 눌렀을 때 동작
        marker.touchHandler = { _ in
            onTap?(scooter)  // 클릭 시 해당 킥보드 정보 전달
            print("\(scooter)")
            print("tap")
            return true
        }
    }
    
    // 마커 이미지 설정
    func makeMarkerImage(color: UIColor) -> UIImage {
        let size = CGSize(width: 40, height: 40)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { _ in
            let circlePath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: size))
            color.setFill()
            circlePath.fill()
            
            if let symbol = UIImage(systemName: "motorcycle.fill") {
                let symbol = symbol.withTintColor(.white, renderingMode: .alwaysOriginal)
                
                // 중앙 정렬
                let symbolX = (size.width - symbol.size.width) / 2
                let symbolY = (size.height - symbol.size.height) / 2
                symbol.draw(at: CGPoint(x: symbolX, y: symbolY))
            }
        }
    }
}
