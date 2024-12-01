import UIKit

class CrowdednessView: UIView {
    private let containerStack = UIStackView()
    private let progressRing = CircularProgressView()
    private let labelStack = UIStackView()
    private let percentageLabel = UILabel()
    private let statusLabel = UILabel()
    private let availableSeatsLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = Theme.Colors.background
        layer.cornerRadius = 16
        Theme.applyShadow(to: self, shadow: Theme.Shadows.small)
        
        setupProgressRing()
        setupLabels()
        setupLayout()
    }
    
    private func setupProgressRing() {
        progressRing.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressRing.widthAnchor.constraint(equalToConstant: 80),
            progressRing.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupLabels() {
        labelStack.axis = .vertical
        labelStack.spacing = 4
        labelStack.alignment = .leading
        
        percentageLabel.font = .systemFont(ofSize: 20, weight: .bold)
        percentageLabel.textColor = Theme.Colors.Text.primary
        
        statusLabel.font = .systemFont(ofSize: 16, weight: .medium)
        statusLabel.textColor = Theme.Colors.Text.primary
        
        availableSeatsLabel.font = .systemFont(ofSize: 14)
        availableSeatsLabel.textColor = Theme.Colors.Text.secondary
        
        [percentageLabel, statusLabel, availableSeatsLabel].forEach {
            labelStack.addArrangedSubview($0)
        }
    }
    
    private func setupLayout() {
        containerStack.axis = .horizontal
        containerStack.spacing = 16
        containerStack.alignment = .center
        containerStack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        containerStack.isLayoutMarginsRelativeArrangement = true
        
        [progressRing, labelStack].forEach { containerStack.addArrangedSubview($0) }
        addSubview(containerStack)
        
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func update(with status: [String: Int]) {
        let totalSeats = status.count
        let occupiedSeats = status.values.filter { $0 == 1 }.count
        let crowdedness = Float(occupiedSeats) / Float(totalSeats)
        
        progressRing.progress = crowdedness
        progressRing.color = getCrowdednessColor(crowdedness)
        
        percentageLabel.text = "\(Int(crowdedness * 100))%"
        statusLabel.text = getCrowdednessStatus(crowdedness)
        availableSeatsLabel.text = "이용 가능 좌석: \(totalSeats - occupiedSeats)석"
        
        animateUpdate()
    }
    
    private func getCrowdednessStatus(_ value: Float) -> String {
        switch value {
        case 0...0.3: return "여유로움"
        case 0.31...0.7: return "보통"
        default: return "혼잡"
        }
    }
    
    private func getCrowdednessColor(_ value: Float) -> UIColor {
        switch value {
        case 0...0.3: return Theme.Colors.tertiary
        case 0.31...0.7: return Theme.Colors.secondary
        default: return Theme.Colors.primary
        }
    }
    
    private func animateUpdate() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.transform = .identity
        }
    }
}

class CircularProgressView: UIView {
    private let progressLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    
    var progress: Float = 0 {
        didSet { updateProgress() }
    }
    
    var color: UIColor = Theme.Colors.primary {
        didSet { progressLayer.strokeColor = color.cgColor }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayers() {
        backgroundLayer.lineWidth = 10
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = Theme.Colors.border.cgColor
        layer.addSublayer(backgroundLayer)
        
        progressLayer.lineWidth = 10
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = color.cgColor
        progressLayer.lineCap = .round
        layer.addSublayer(progressLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - progressLayer.lineWidth / 2
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi
        
        let circularPath = UIBezierPath(arcCenter: center,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)
        
        backgroundLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath
        
        updateProgress()
    }
    
    private func updateProgress() {
        progressLayer.strokeEnd = CGFloat(progress)
    }
}
