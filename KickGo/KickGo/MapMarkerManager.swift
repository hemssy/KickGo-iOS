import NMapsMap

class MapMarkerManager {
    
    func addMarker(to mapView: NMFMapView, lat: Double, lng: Double, color: UIColor) {
        let marker = NMFMarker()
        
        marker.position = NMGLatLng(lat: lat, lng: lng)
        marker.iconImage = NMFOverlayImage(image: makeMarkerImage(color: color))
        marker.mapView = mapView
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
                
                let symbolX = (size.width - symbol.size.width) / 2
                let symbolY = (size.height - symbol.size.height) / 2
                symbol.draw(at: CGPoint(x: symbolX, y: symbolY))
            }
        }
    }
}
