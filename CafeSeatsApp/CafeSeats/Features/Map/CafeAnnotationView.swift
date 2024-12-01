// CafeAnnotationView.swift

import MapKit

class CafeAnnotationView: MKMarkerAnnotationView {
    static let identifier = "CafeAnnotationView"

    override var annotation: MKAnnotation? {
        willSet {
            guard let cafeAnnotation = newValue as? CafeAnnotation else { return }
            canShowCallout = true

            // 마커 설정
            glyphText = cafeAnnotation.cafe.isTest == true ? "테스트" : "\(cafeAnnotation.crowdedness)%"
            markerTintColor = getCrowdednessColor(crowdedness: cafeAnnotation.crowdedness, isTest: cafeAnnotation.cafe.isTest ?? false)

            // 상세 정보 버튼 추가
            let infoButton = UIButton(type: .detailDisclosure)
            rightCalloutAccessoryView = infoButton
        }
    }

    private func getCrowdednessColor(crowdedness: Int, isTest: Bool) -> UIColor {
        if isTest {
            return Theme.Colors.accent
        } else if crowdedness >= 80 {
            return Theme.Colors.primary
        } else if crowdedness >= 50 {
            return Theme.Colors.secondary
        } else {
            return Theme.Colors.tertiary
        }
    }
}
