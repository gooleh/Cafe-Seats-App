// ServiceCard.swift
import UIKit

class ServiceCard: UIView {
    private let stackView = UIStackView()
    private let serviceIcon = UIImageView()
    private let serviceTitle = UILabel()
    private let serviceDescription = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 16
        clipsToBounds = false // 그림자 보이게 하기 위해
        
        // Shadow 설정 (외부에서 적용할 수도 있습니다)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
        
        // StackView 설정
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .fill // 변경: 수평 정렬을 채우기로 변경
        stackView.distribution = .fill
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        // 서비스 아이콘 설정
        serviceIcon.contentMode = .scaleAspectFit
        serviceIcon.tintColor = Theme.Colors.primary
        serviceIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            serviceIcon.heightAnchor.constraint(equalToConstant: 50),
            serviceIcon.widthAnchor.constraint(equalToConstant: 50)
        ])
        // 아이콘을 왼쪽 정렬하거나 중앙 정렬
        serviceIcon.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        serviceIcon.setContentCompressionResistancePriority(.required, for: .horizontal)
        stackView.addArrangedSubview(serviceIcon)
        serviceIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            serviceIcon.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
        ])
        
        // 서비스 제목 설정
        serviceTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        serviceTitle.textColor = Theme.Colors.primary
        serviceTitle.textAlignment = .center
        serviceTitle.numberOfLines = 0
        stackView.addArrangedSubview(serviceTitle)
        
        // 서비스 설명 설정
        serviceDescription.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        serviceDescription.textColor = Theme.Colors.Text.secondary
        serviceDescription.textAlignment = .center
        serviceDescription.numberOfLines = 0
        stackView.addArrangedSubview(serviceDescription)
    }
    
    func configure(iconName: String, title: String, description: String) {
        serviceIcon.image = UIImage(systemName: iconName)
        serviceTitle.text = title
        serviceDescription.text = description
    }
}
