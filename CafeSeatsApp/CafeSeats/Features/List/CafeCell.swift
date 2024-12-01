// CafeCell.swift

import UIKit

class CafeCell: UITableViewCell {
    private let containerView = UIView()
    private let nameLabel = UILabel()
    private let addressLabel = UILabel()
    private let crowdednessBar = UIProgressView()
    private let crowdednessLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear

        contentView.addSubview(containerView)
        containerView.backgroundColor = Theme.Colors.background
        containerView.layer.cornerRadius = 12
        Theme.applyShadow(to: containerView, shadow: Theme.Shadows.medium)

        // 레이블과 프로그래스 바를 컨테이너 뷰에 추가
        [nameLabel, addressLabel, crowdednessBar, crowdednessLabel].forEach {
            containerView.addSubview($0)
        }

        // 뷰 구성 설정
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.textColor = Theme.Colors.Text.primary
        nameLabel.numberOfLines = 0 // 여러 줄 허용
        nameLabel.lineBreakMode = .byWordWrapping

        addressLabel.font = .systemFont(ofSize: 14)
        addressLabel.textColor = Theme.Colors.Text.secondary
        addressLabel.numberOfLines = 0
        addressLabel.lineBreakMode = .byWordWrapping

        crowdednessBar.trackTintColor = Theme.Colors.border
        crowdednessBar.layer.cornerRadius = 4
        crowdednessBar.clipsToBounds = true

        crowdednessLabel.font = .systemFont(ofSize: 14, weight: .regular)
        crowdednessLabel.textColor = Theme.Colors.Text.secondary
        crowdednessLabel.numberOfLines = 1
        crowdednessLabel.textAlignment = .right

        // 오토레이아웃 설정
        setupConstraints()
    }

    private func setupConstraints() {
        [containerView, nameLabel, addressLabel, crowdednessBar, crowdednessLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            // 컨테이너 뷰 제약
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // nameLabel 제약
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            // addressLabel 제약
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            addressLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            addressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            // crowdednessBar 제약
            crowdednessBar.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 12),
            crowdednessBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            crowdednessBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            crowdednessBar.heightAnchor.constraint(equalToConstant: 8),

            // crowdednessLabel 제약
            crowdednessLabel.topAnchor.constraint(equalTo: crowdednessBar.bottomAnchor, constant: 8),
            crowdednessLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            crowdednessLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    func configure(with cafe: Cafe) {
        nameLabel.text = cafe.cafeName
        addressLabel.text = cafe.cafeAddress

        // 혼잡도 계산
        guard let tableStatus = cafe.tableStatus else { // 옵셔널 처리
            crowdednessLabel.text = "혼잡도 정보 없음"
            crowdednessBar.progress = 0
            crowdednessBar.progressTintColor = Theme.Colors.tertiary
            return
        }
        
        let occupiedTables = tableStatus.values.filter { $0 == 1 }.count
        let totalTables = tableStatus.count
        let crowdedness = totalTables > 0 ? Float(occupiedTables) / Float(totalTables) : 0

        crowdednessBar.progress = crowdedness
        crowdednessLabel.text = "혼잡도: \(Int(crowdedness * 100))%"

        // 혼잡도에 따라 프로그래스 바 색상 변경
        switch crowdedness {
        case 0.8...:
            crowdednessBar.progressTintColor = Theme.Colors.primary
        case 0.5...:
            crowdednessBar.progressTintColor = Theme.Colors.secondary
        default:
            crowdednessBar.progressTintColor = Theme.Colors.tertiary
        }
    }
}
