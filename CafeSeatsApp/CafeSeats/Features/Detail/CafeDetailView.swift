import UIKit

class CafeDetailView: UIView {
    private let cafe: Cafe
    var onClose: (() -> Void)?
    var onDetail: ((Cafe) -> Void)?
    
    // UI Components
    private let containerStack = UIStackView()
    private let closeButton = UIButton(type: .system)
    private let headerStack = UIStackView()
    private let nameLabel = UILabel()
    private let statusBadge = PaddedLabel()
    private let addressLabel = UILabel()
    private let phoneLabel = UILabel()
    private let crowdednessView = CrowdednessView()
    private let seatLayoutView = SeatLayoutView()
    private let detailButton = UIButton(type: .system)
    
    init(cafe: Cafe) {
        self.cafe = cafe
        super.init(frame: .zero)
        setupViews()
        configure(with: cafe)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = Theme.Colors.background
        layer.cornerRadius = 16
        Theme.applyShadow(to: self, shadow: Theme.Shadows.large)
        
        setupContainerStack()
        setupCloseButton()
        setupHeaderContent()
        setupDetailButton()
        applyConstraints()
    }
    
    private func setupContainerStack() {
        containerStack.axis = .vertical
        containerStack.spacing = 16
        containerStack.layoutMargins = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        containerStack.isLayoutMarginsRelativeArrangement = true
        addSubview(containerStack)
    }
    
    private func setupCloseButton() {
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = Theme.Colors.Text.secondary
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        addSubview(closeButton)
    }
    
    private func setupHeaderContent() {
        headerStack.axis = .horizontal
        headerStack.spacing = 8
        headerStack.alignment = .center
        
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = Theme.Colors.Text.primary
        nameLabel.numberOfLines = 0
        
        statusBadge.font = .systemFont(ofSize: 12, weight: .medium)
        statusBadge.textColor = .white
        statusBadge.layer.cornerRadius = 8
        statusBadge.clipsToBounds = true
        
        addressLabel.font = .systemFont(ofSize: 14)
        addressLabel.textColor = Theme.Colors.Text.secondary
        addressLabel.numberOfLines = 0
        
        phoneLabel.font = .systemFont(ofSize: 14)
        phoneLabel.textColor = Theme.Colors.Text.secondary
    }
    
    private func setupDetailButton() {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .medium
        config.imagePadding = 8
        config.image = UIImage(systemName: "info.circle.fill")
        config.imagePlacement = .leading
        config.baseBackgroundColor = Theme.Colors.primary
        config.baseForegroundColor = .white
        config.title = "상세 정보 보기"
        
        detailButton.configuration = config
        detailButton.addTarget(self, action: #selector(detailTapped), for: .touchUpInside)
    }
    
    private func applyConstraints() {
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: topAnchor),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 28),
            closeButton.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        [nameLabel, statusBadge].forEach { headerStack.addArrangedSubview($0) }
        [headerStack, addressLabel, phoneLabel, crowdednessView, seatLayoutView, detailButton].forEach {
            containerStack.addArrangedSubview($0)
        }
    }
    
    func configure(with cafe: Cafe) {
        nameLabel.text = cafe.cafeName
        addressLabel.text = cafe.cafeAddress
        phoneLabel.text = cafe.phone ?? "전화번호 정보 없음"
        
        statusBadge.text = cafe.isTest == true ? "테스트" : "영업중"
        statusBadge.backgroundColor = cafe.isTest == true ? Theme.Colors.accent : Theme.Colors.tertiary
        
        if let tableStatus = cafe.tableStatus {
            crowdednessView.update(with: tableStatus)
            seatLayoutView.configure(with: tableStatus)
            crowdednessView.isHidden = false
            seatLayoutView.isHidden = false
        } else {
            crowdednessView.isHidden = true
            seatLayoutView.isHidden = true
        }
        
        animateAppearance()
    }
    
    private func animateAppearance() {
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            self.transform = .identity
            self.alpha = 1
        }
    }
    
    @objc private func closeTapped() {
        onClose?()
    }
    
    @objc private func detailTapped() {
        onDetail?(cafe)
    }
}

class PaddedLabel: UILabel {
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + 16, height: size.height + 8)
    }
}
