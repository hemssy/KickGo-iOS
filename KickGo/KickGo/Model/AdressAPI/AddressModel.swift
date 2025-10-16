

    //GeocodingResponse
    struct GeocodingResponse: Codable {
        let status: String
        let meta: Meta
        let addresses: [Address]
        let errorMessage: String
    }
    
    struct Meta: Codable {
        let totalCount: Int
        let page: Int
        let count: Int
    }
    
    //주소와 좌표 정보
    struct Address: Codable {
        let roadAddress: String
        let jibunAddress: String
        let englishAddress: String
        let addressElements: [AddressElement]
        let x: String // 경도 (Longitude)
        let y: String // 위도 (Latitude)
        let distance: Double
    }
    struct AddressElement: Codable {
        let types: [String]
        let longName: String
        let shortName: String
        let code: String
    }

