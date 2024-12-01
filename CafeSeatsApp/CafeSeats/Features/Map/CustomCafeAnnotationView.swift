// Features/Map/CustomCafeAnnotationView.swift

import MapKit

class CustomCafeAnnotationView: MKAnnotationView {
    static let identifier = "CustomCafeAnnotationView"

    private let imageView = UIImageView()
    private let label = UILabel()

    override var annotation: MKAnnotation? {
        willSet {
            // 기존 서브뷰 제거
            imageView.removeFromSuperview()
            label.removeFromSuperview()

            guard let cafeAnnotation = newValue as? CafeAnnotation else { return }
            canShowCallout = true

            // 이미지 설정 (SF Symbol 사용)
            let symbolName = "cup.and.saucer.fill" // 원하는 SF Symbol 이름
            if let image = UIImage(systemName: symbolName) {
                // 이미지 크기 설정
                let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold)
                let resizedImage = image.withConfiguration(config)
                imageView.image = resizedImage
                imageView.tintColor = Theme.Colors.tertiary // 테마 색상 적용
            }

            // 레이블 설정
            let crowdedness = calculateCrowdedness(for: cafeAnnotation.cafe)
            label.text = cafeAnnotation.cafe.isTest == true ? "테스트" : "\(crowdedness)%"
            label.font = UIFont.systemFont(ofSize: 7, weight: .bold)
            label.textColor = Theme.Colors.Text.light
            label.textAlignment = .center
            label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            label.layer.cornerRadius = 5
            label.clipsToBounds = true

            // 서브뷰 추가
            addSubview(imageView)
            addSubview(label)

            // 레이아웃 설정
            imageView.translatesAutoresizingMaskIntoConstraints = false
            label.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -10),
                label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2),
                label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                label.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
                label.heightAnchor.constraint(equalToConstant: 20)
            ])

            // 마커 위치 조정
            self.frame = CGRect(x: 0, y: 0, width: 50, height: 70)
            self.centerOffset = CGPoint(x: 0, y: -self.frame.size.height / 2)
        }
    }

    private func calculateCrowdedness(for cafe: Cafe) -> Int {
        guard let tableStatus = cafe.tableStatus else { return 0 }
        let totalTables = tableStatus.count
        let occupiedTables = tableStatus.values.filter { $0 == 1 }.count
        return totalTables == 0 ? 0 : Int(Double(occupiedTables) / Double(totalTables) * 100)
    }
}
