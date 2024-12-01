// TestimonialCard.swift
import UIKit

class TestimonialCard: UIView {
    private let stackView = UIStackView()
    private let userIcon = UIImageView()
    private let userName = UILabel()
    private let userReview = UILabel()
    
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
        
        // 사용자 아이콘 설정
        userIcon.contentMode = .scaleAspectFit
        userIcon.image = UIImage(systemName: "person.fill")
        userIcon.tintColor = .white
        userIcon.backgroundColor = Theme.Colors.primary
        userIcon.layer.cornerRadius = 24
        userIcon.clipsToBounds = true
        userIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userIcon.heightAnchor.constraint(equalToConstant: 48),
            userIcon.widthAnchor.constraint(equalToConstant: 48)
        ])
        // 아이콘을 중앙 정렬
        stackView.addArrangedSubview(userIcon)
        NSLayoutConstraint.activate([
            userIcon.centerXAnchor.constraint(equalTo: stackView.centerXAnchor)
        ])
        
        // 사용자 이름 설정
        userName.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        userName.textColor = Theme.Colors.Text.primary
        userName.textAlignment = .center
        userName.numberOfLines = 0
        stackView.addArrangedSubview(userName)
        
        // 사용자 후기 설정
        userReview.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        userReview.textColor = Theme.Colors.Text.secondary
        userReview.textAlignment = .center
        userReview.numberOfLines = 0
        stackView.addArrangedSubview(userReview)
    }
    
    func configure(userName: String, review: String) {
        self.userName.text = userName
        self.userReview.text = "\"\(review)\""
    }
}
