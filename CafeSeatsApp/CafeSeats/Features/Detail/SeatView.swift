import UIKit

class SeatView: UIView {
    private let containerStack = UIStackView()
    private let iconView = UIImageView()
    private let seatLabel = UILabel()
    private let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        layer.cornerRadius = 12
        clipsToBounds = true
        
        containerStack.axis = .vertical
        containerStack.spacing = 4
        containerStack.alignment = .center
        
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        
        seatLabel.font = .systemFont(ofSize: 12, weight: .bold)
        seatLabel.textColor = .white
        seatLabel.textAlignment = .center
        
        statusLabel.font = .systemFont(ofSize: 10)
        statusLabel.textColor = .white
        statusLabel.textAlignment = .center
        
        [iconView, seatLabel, statusLabel].forEach { containerStack.addArrangedSubview($0) }
        addSubview(containerStack)
        
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            iconView.heightAnchor.constraint(equalToConstant: 24),
            iconView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(id: String, isOccupied: Bool) {
        backgroundColor = isOccupied ? Theme.Colors.primary : Theme.Colors.tertiary
        iconView.image = UIImage(systemName: isOccupied ? "person.fill" : "chair")
        seatLabel.text = id.replacingOccurrences(of: "table_", with: "")
        statusLabel.text = isOccupied ? "사용중" : "빈자리"
        
        animateConfiguration()
    }
    
    private func animateConfiguration() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.transform = .identity
        }
    }
}
