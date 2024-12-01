import UIKit

class SeatMapView: UIView {
    private var seatViews: [SeatView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 12
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutSeatViews()
    }

    func configure(with status: [String: Int]) {
        seatViews.forEach { $0.removeFromSuperview() }
        seatViews.removeAll()

        for (index, (seatId, isOccupied)) in status.enumerated() {
            let seatView = SeatView()
            seatView.configure(id: seatId, isOccupied: isOccupied == 1)
            addSubview(seatView)
            seatViews.append(seatView)
        }

        setNeedsLayout()
    }

    private func layoutSeatViews() {
        let spacing: CGFloat = 8
        let columns = 2
        let seatWidth = (bounds.width - CGFloat(columns + 1) * spacing) / CGFloat(columns)
        let seatHeight = seatWidth // Square seats

        for (index, seatView) in seatViews.enumerated() {
            let column = index % columns
            let row = index / columns

            let x = spacing + CGFloat(column) * (seatWidth + spacing)
            let y = spacing + CGFloat(row) * (seatHeight + spacing)

            seatView.frame = CGRect(x: x, y: y, width: seatWidth, height: seatHeight)
        }
    }
}
