import UIKit

class SeatLayoutView: UICollectionView {
    private var tableStatus: [String: Int] = [:]
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .clear
        delegate = self
        dataSource = self
        register(EnhancedSeatCell.self, forCellWithReuseIdentifier: EnhancedSeatCell.identifier)
        
        layer.cornerRadius = 16
        clipsToBounds = true
        heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tableStatus: [String: Int]) {
        self.tableStatus = tableStatus
        reloadData()
    }
}

extension SeatLayoutView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableStatus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EnhancedSeatCell.identifier, for: indexPath) as! EnhancedSeatCell
        let sortedKeys = Array(tableStatus.keys).sorted()
        let tableId = sortedKeys[indexPath.item]
        let status = tableStatus[tableId] ?? 0
        cell.configure(tableId: tableId, status: status)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 40) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}

class EnhancedSeatCell: UICollectionViewCell {
    static let identifier = "EnhancedSeatCell"
    
    private let containerView = UIView()
    private let stackView = UIStackView()
    private let iconView = UIImageView()
    private let tableLabel = UILabel()
    private let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .clear
        
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        
        tableLabel.font = .systemFont(ofSize: 12, weight: .bold)
        tableLabel.textColor = .white
        
        statusLabel.font = .systemFont(ofSize: 10)
        statusLabel.textColor = .white
        
        [iconView, tableLabel, statusLabel].forEach { stackView.addArrangedSubview($0) }
        
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            
            iconView.heightAnchor.constraint(equalToConstant: 24),
            iconView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(tableId: String, status: Int) {
        tableLabel.text = tableId.replacingOccurrences(of: "table_", with: "")
        statusLabel.text = status == 1 ? "사용중" : "빈자리"
        
        let isOccupied = status == 1
        containerView.backgroundColor = isOccupied ? Theme.Colors.primary : Theme.Colors.tertiary
        iconView.image = UIImage(systemName: isOccupied ? "person.fill" : "chair")
        
        animateStatus()
    }
    
    private func animateStatus() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.transform = .identity
        }
    }
}
