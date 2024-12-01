// Models/Cafe.swift

import Foundation
import MapKit

struct Cafe: Codable, Equatable {
    let cafeId: Int
    let cafeName: String
    let cafeAddress: String
    let phone: String?
    let tableStatus: [String: Int]? // Optional
    let lat: Double
    let lng: Double
    let placeUrl: String?
    let isTest: Bool?
    
    enum CodingKeys: String, CodingKey {
        case cafeId = "cafe_id"
        case cafeName = "cafe_name"
        case cafeAddress = "cafe_address"
        case phone
        case tableStatus = "table_status"
        case lat
        case lng
        case placeUrl = "place_url"
        case isTest = "is_test"
    }
    
    // Initializer for MKMapItem
    init(mapItem: MKMapItem) {
        self.cafeId = mapItem.hashValue // Unique identifier
        self.cafeName = mapItem.name ?? "알 수 없는 카페"
        self.cafeAddress = mapItem.placemark.title ?? "주소 정보 없음"
        self.phone = mapItem.phoneNumber
        self.tableStatus = Cafe.generateDummySeats()
        self.lat = mapItem.placemark.coordinate.latitude
        self.lng = mapItem.placemark.coordinate.longitude
        self.placeUrl = mapItem.url?.absoluteString
        self.isTest = false
    }
    
    // Initializer for APIClient
    init(from apiResponse: APIResponseCafe) {
        self.cafeId = apiResponse.cafeId
        self.cafeName = apiResponse.cafeName
        self.cafeAddress = apiResponse.cafeAddress
        self.phone = apiResponse.phone
        self.tableStatus = apiResponse.tableStatus
        self.lat = apiResponse.lat
        self.lng = apiResponse.lng
        // placeUrl이 없을 경우 Google Maps URL을 생성
        if let placeUrl = apiResponse.placeUrl, let url = URL(string: placeUrl) {
            self.placeUrl = url.absoluteString
        } else {
            // 좌표를 기반으로 Google Maps URL 생성
            self.placeUrl = "https://www.google.com/maps/search/?api=1&query=\(apiResponse.lat),\(apiResponse.lng)"
        }
        self.isTest = apiResponse.isTest
    }
    
    // Function to generate dummy seat statuses
    static func generateDummySeats() -> [String: Int] {
        let numberOfTables = Int.random(in: 5...10) // 5 to 10 tables
        var tableStatus: [String: Int] = [:]
        for i in 1...numberOfTables {
            tableStatus["table_\(i)"] = Bool.random() ? 0 : 1 // 50% chance of being available
        }
        return tableStatus
    }
    
    // Equatable conformance based on cafeId
    static func == (lhs: Cafe, rhs: Cafe) -> Bool {
        return lhs.cafeId == rhs.cafeId
    }
}

// Assuming this is your API response model
struct APIResponseCafe: Codable {
    let cafeId: Int
    let cafeName: String
    let cafeAddress: String
    let phone: String?
    let tableStatus: [String: Int]?
    let lat: Double
    let lng: Double
    let placeUrl: String?
    let isTest: Bool?
}


struct CafeUtils {
    static func calculateCrowdedness(tableStatus: [String: Int]?) -> Int {
        guard let tableStatus = tableStatus else { return 0 }
        let totalTables = tableStatus.count
        let occupiedTables = tableStatus.values.filter { $0 == 1 }.count
        return totalTables == 0 ? 0 : Int(Double(occupiedTables) / Double(totalTables) * 100)
    }
}
