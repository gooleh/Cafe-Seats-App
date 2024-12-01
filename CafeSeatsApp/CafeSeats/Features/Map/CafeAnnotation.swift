// Views/CafeAnnotation.swift

import MapKit

class CafeAnnotation: NSObject, MKAnnotation {
    let cafe: Cafe
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var crowdedness: Int

    init(cafe: Cafe) {
        self.cafe = cafe
        self.coordinate = CLLocationCoordinate2D(latitude: cafe.lat, longitude: cafe.lng)
        self.title = cafe.cafeName
        self.subtitle = cafe.cafeAddress
        // tableStatus가 옵셔널이므로 안전하게 언래핑
        if let tableStatus = cafe.tableStatus {
            self.crowdedness = CafeAnnotation.calculateCrowdedness(tableStatus: tableStatus)
        } else {
            self.crowdedness = 0 // 기본값 설정
        }
        super.init()
    }

    static func calculateCrowdedness(tableStatus: [String: Int]) -> Int {
        let totalTables = tableStatus.count
        let occupiedTables = tableStatus.values.filter { $0 == 1 }.count
        return totalTables == 0 ? 0 : Int(Double(occupiedTables) / Double(totalTables) * 100)
    }
}
