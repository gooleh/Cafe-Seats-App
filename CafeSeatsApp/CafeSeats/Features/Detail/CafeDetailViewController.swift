import UIKit

class CafeDetailViewController: UIViewController {
    private let cafe: Cafe
    private let detailView: CafeDetailView
    
    // UI Components
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let detailsStack = UIStackView()
    private let titleContainer = InfoContainer(title: "카페 정보")
    private let addressContainer = InfoContainer(title: "주소")
    private let phoneContainer = InfoContainer(title: "전화번호")
    private let crowdednessContainer = InfoContainer(title: "혼잡도")
    private let seatLayoutContainer = InfoContainer(title: "좌석 배치도")
    
    init(cafe: Cafe) {
        self.cafe = cafe
        self.detailView = CafeDetailView(cafe: cafe)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        populateData()
    }
    
    private func setupViews() {
        view.backgroundColor = Theme.Colors.background
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentStack.axis = .vertical
        contentStack.spacing = 16
        
        // Details Stack Setup
        detailsStack.axis = .vertical
        detailsStack.spacing = 16
        detailsStack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        detailsStack.isLayoutMarginsRelativeArrangement = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        contentStack.addArrangedSubview(detailsStack)
        [titleContainer, addressContainer, phoneContainer, crowdednessContainer, seatLayoutContainer].forEach { detailsStack.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // 좌석 배치도 높이 증가
            seatLayoutContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        ])
    }
    
    private func setupNavigationBar() {
        title = cafe.cafeName
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark.circle.fill"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(closeTapped))
        closeButton.tintColor = Theme.Colors.Text.primary
        navigationItem.rightBarButtonItem = closeButton
    }
    
    private func populateData() {
        titleContainer.setText("\(cafe.cafeName) \(cafe.isTest == true ? "(테스트)" : "")")
        addressContainer.setText(cafe.cafeAddress)
        phoneContainer.setText(cafe.phone ?? "전화번호 정보 없음")
        
        if let tableStatus = cafe.tableStatus {
            let crowdedness = CafeUtils.calculateCrowdedness(tableStatus: tableStatus)
            let crowdednessColor = getCrowdednessColor(crowdedness: crowdedness)
            crowdednessContainer.setText("\(crowdedness)%")
            crowdednessContainer.setTextColor(crowdednessColor)
            
            let seatLayout = SeatLayoutView()
            seatLayout.configure(with: tableStatus)
            seatLayoutContainer.setContent(seatLayout)
        } else {
            crowdednessContainer.setText("정보 없음")
            seatLayoutContainer.isHidden = true
        }
    }
    
    private func getCrowdednessColor(crowdedness: Int) -> UIColor {
        if cafe.isTest == true {
            return UIColor.systemYellow
        } else if crowdedness >= 80 {
            return UIColor.red
        } else if crowdedness >= 50 {
            return UIColor.orange
        } else {
            return UIColor.green
        }
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}

class InfoContainer: UIView {
    private let titleLabel = UILabel()
    private let contentStack = UIStackView()
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 12
        Theme.applyShadow(to: self, shadow: Theme.Shadows.small)
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = Theme.Colors.Text.secondary
        
        contentStack.axis = .vertical
        contentStack.spacing = 8
        
        [titleLabel, contentStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            contentStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func setText(_ text: String) {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16)
        label.textColor = Theme.Colors.Text.primary
        label.numberOfLines = 0
        contentStack.addArrangedSubview(label)
    }
    
    func setTextColor(_ color: UIColor) {
        if let label = contentStack.arrangedSubviews.first as? UILabel {
            label.textColor = color
        }
    }
    
    func setContent(_ content: UIView) {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        contentStack.addArrangedSubview(content)
    }
}
