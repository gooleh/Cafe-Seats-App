// Features/Main/MainView.swift
import UIKit

class MainView: UIView {
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    // Hero Section
    private let heroSection = UIView()
    private let heroImageView = UIImageView()
    private let overlayView = UIView()
    private let heroContent = UIView()
    private let mainTitleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let buttonGroup = UIStackView()
    let mapButton = UIButton()
    let listButton = UIButton()
    
    // Services Section
    private let servicesSection = UIView()
    private let servicesTitleLabel = UILabel()
    private let servicesWrapper = UIStackView()
    
    // Testimonials Section
    private let testimonialsSection = UIView()
    private let testimonialsTitleLabel = UILabel()
    private let testimonialsWrapper = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        backgroundColor = Theme.Colors.background
        
        // 스크롤 뷰 설정
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // 콘텐츠 뷰 설정
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
        
        // Hero Section 설정
        setupHeroSection()
        
        // Services Section 설정
        setupServicesSection()
        
        // Testimonials Section 설정
        setupTestimonialsSection()
    }
    
    private func setupHeroSection() {
        contentView.addSubview(heroSection)
        heroSection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heroSection.topAnchor.constraint(equalTo: contentView.topAnchor),
            heroSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            heroSection.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9) // 90% 높이
        ])
        
        // Hero Image
        heroSection.addSubview(heroImageView)
        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        heroImageView.image = UIImage(named: "heroBackground") // Assets에 heroBackground 이미지 추가 필요
        heroImageView.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: heroSection.topAnchor),
            heroImageView.bottomAnchor.constraint(equalTo: heroSection.bottomAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: heroSection.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: heroSection.trailingAnchor)
        ])
        
        // Overlay View (그라데이션 오버레이)
        heroSection.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = .clear
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            Theme.Colors.overlayGradientStart.cgColor,
            Theme.Colors.overlayGradientEnd.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        // gradientLayer.frame는 레이아웃 이후에 설정해야 정확한 크기를 가짐
        overlayView.layer.insertSublayer(gradientLayer, at: 0)
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: heroSection.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: heroSection.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: heroSection.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: heroSection.trailingAnchor)
        ])
        
        // 레이아웃이 완료된 후 그라데이션 레이어의 프레임 설정
        heroSection.layoutIfNeeded()
        gradientLayer.frame = heroSection.bounds
        
        // Hero Content
        heroSection.addSubview(heroContent)
        heroContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heroContent.centerXAnchor.constraint(equalTo: heroSection.centerXAnchor),
            heroContent.centerYAnchor.constraint(equalTo: heroSection.centerYAnchor),
            heroContent.leadingAnchor.constraint(greaterThanOrEqualTo: heroSection.leadingAnchor, constant: 20),
            heroContent.trailingAnchor.constraint(lessThanOrEqualTo: heroSection.trailingAnchor, constant: -20)
        ])
        
        // Main Title
        heroContent.addSubview(mainTitleLabel)
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTitleLabel.text = "카페 자리있어?"
        mainTitleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        mainTitleLabel.textColor = Theme.Colors.Text.light
        mainTitleLabel.textAlignment = .center
        mainTitleLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            mainTitleLabel.topAnchor.constraint(equalTo: heroContent.topAnchor),
            mainTitleLabel.leadingAnchor.constraint(equalTo: heroContent.leadingAnchor),
            mainTitleLabel.trailingAnchor.constraint(equalTo: heroContent.trailingAnchor)
        ])
        
        // Subtitle
        heroContent.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = "실시간으로 확인하는 스마트한 카페 좌석 현황"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textColor = Theme.Colors.Text.secondary
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: heroContent.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: heroContent.trailingAnchor)
        ])
        
        // Button Group
        heroContent.addSubview(buttonGroup)
        buttonGroup.translatesAutoresizingMaskIntoConstraints = false
        buttonGroup.axis = .vertical
        buttonGroup.spacing = 16
        buttonGroup.alignment = .center
        NSLayoutConstraint.activate([
            buttonGroup.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            buttonGroup.leadingAnchor.constraint(equalTo: heroContent.leadingAnchor),
            buttonGroup.trailingAnchor.constraint(equalTo: heroContent.trailingAnchor),
            buttonGroup.bottomAnchor.constraint(equalTo: heroContent.bottomAnchor)
        ])
        
        // Map Button
        buttonGroup.addArrangedSubview(mapButton)
        mapButton.translatesAutoresizingMaskIntoConstraints = false
        mapButton.setTitle("지도로 보기", for: .normal)
        mapButton.backgroundColor = Theme.Colors.primary
        mapButton.setTitleColor(Theme.Colors.Text.light, for: .normal)
        mapButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        mapButton.layer.cornerRadius = 12
        mapButton.setImage(UIImage(systemName: "map.fill"), for: .normal)
        mapButton.tintColor = Theme.Colors.Text.light
        mapButton.imageView?.contentMode = .scaleAspectFit
        mapButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        NSLayoutConstraint.activate([
            mapButton.heightAnchor.constraint(equalToConstant: 54),
            mapButton.widthAnchor.constraint(equalTo: buttonGroup.widthAnchor, multiplier: 0.8)
        ])
        
        // List Button
        buttonGroup.addArrangedSubview(listButton)
        listButton.translatesAutoresizingMaskIntoConstraints = false
        listButton.setTitle("목록으로 보기", for: .normal)
        listButton.backgroundColor = Theme.Colors.tertiary
        listButton.setTitleColor(Theme.Colors.primary, for: .normal)
        listButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        listButton.layer.cornerRadius = 12
        listButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        listButton.tintColor = Theme.Colors.primary
        listButton.imageView?.contentMode = .scaleAspectFit
        listButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        NSLayoutConstraint.activate([
            listButton.heightAnchor.constraint(equalToConstant: 54),
            listButton.widthAnchor.constraint(equalTo: buttonGroup.widthAnchor, multiplier: 0.8)
        ])
        
        // 애니메이션 적용
        heroContent.alpha = 0
        heroContent.transform = CGAffineTransform(translationX: 0, y: 20)
        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseOut], animations: {
            self.heroContent.alpha = 1
            self.heroContent.transform = .identity
        }, completion: nil)
    }
    
    private func setupServicesSection() {
        contentView.addSubview(servicesSection)
        servicesSection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            servicesSection.topAnchor.constraint(equalTo: heroSection.bottomAnchor, constant: 80),
            servicesSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            servicesSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            // servicesSection.heightAnchor.constraint(greaterThanOrEqualToConstant: 300) // 제거: 동적 높이 허용
        ])
        
        // Services Title
        servicesSection.addSubview(servicesTitleLabel)
        servicesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        servicesTitleLabel.text = "서비스 소개"
        servicesTitleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        servicesTitleLabel.textColor = Theme.Colors.primary
        servicesTitleLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            servicesTitleLabel.topAnchor.constraint(equalTo: servicesSection.topAnchor),
            servicesTitleLabel.leadingAnchor.constraint(equalTo: servicesSection.leadingAnchor, constant: 20),
            servicesTitleLabel.trailingAnchor.constraint(equalTo: servicesSection.trailingAnchor, constant: -20)
        ])
        
        // Services Wrapper
        servicesSection.addSubview(servicesWrapper)
        servicesWrapper.translatesAutoresizingMaskIntoConstraints = false
        servicesWrapper.axis = .vertical // 변경: 수직 배열
        servicesWrapper.spacing = 30
        servicesWrapper.alignment = .fill // 변경: 수평 정렬을 채우기로 변경
        servicesWrapper.distribution = .fill // 변경: 높이 균등 분배 제거
        NSLayoutConstraint.activate([
            servicesWrapper.topAnchor.constraint(equalTo: servicesTitleLabel.bottomAnchor, constant: 40),
            servicesWrapper.leadingAnchor.constraint(equalTo: servicesSection.leadingAnchor, constant: 20),
            servicesWrapper.trailingAnchor.constraint(equalTo: servicesSection.trailingAnchor, constant: -20),
            servicesWrapper.bottomAnchor.constraint(equalTo: servicesSection.bottomAnchor)
        ])
        
        // 서비스 데이터 정의
        let serviceData = [
            ("chair.fill", "실시간 좌석 현황", "원하는 카페의 실시간 좌석 상황을 확인하고 바로 예약하세요."),
            ("chart.bar.fill", "혼잡도 체크", "현재 카페의 혼잡도를 확인하여 여유로운 시간을 계획하세요."),
            ("magnifyingglass", "스마트 검색", "위치 기반 검색으로 근처의 다양한 카페를 빠르게 찾아보세요.")
        ]
        
        for data in serviceData {
            let serviceCard = ServiceCard()
            serviceCard.configure(iconName: data.0, title: data.1, description: data.2)
            Theme.applyShadow(to: serviceCard, shadow: Theme.Shadows.medium) // Corrected call
            servicesWrapper.addArrangedSubview(serviceCard)
            
            // ServiceCard의 너비를 servicesWrapper에 맞게 설정
            serviceCard.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                serviceCard.leadingAnchor.constraint(equalTo: servicesWrapper.leadingAnchor),
                serviceCard.trailingAnchor.constraint(equalTo: servicesWrapper.trailingAnchor)
            ])
        }
    }
    
    private func setupTestimonialsSection() {
        contentView.addSubview(testimonialsSection)
        testimonialsSection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testimonialsSection.topAnchor.constraint(equalTo: servicesSection.bottomAnchor, constant: 60),
            testimonialsSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            testimonialsSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            testimonialsSection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        // Testimonials Title
        testimonialsSection.addSubview(testimonialsTitleLabel)
        testimonialsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        testimonialsTitleLabel.text = "사용자 후기"
        testimonialsTitleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        testimonialsTitleLabel.textColor = Theme.Colors.primary
        testimonialsTitleLabel.textAlignment = .center
        NSLayoutConstraint.activate([
            testimonialsTitleLabel.topAnchor.constraint(equalTo: testimonialsSection.topAnchor),
            testimonialsTitleLabel.leadingAnchor.constraint(equalTo: testimonialsSection.leadingAnchor, constant: 20),
            testimonialsTitleLabel.trailingAnchor.constraint(equalTo: testimonialsSection.trailingAnchor, constant: -20)
        ])
        
        // Testimonials Wrapper
        testimonialsSection.addSubview(testimonialsWrapper)
        testimonialsWrapper.translatesAutoresizingMaskIntoConstraints = false
        testimonialsWrapper.axis = .vertical // 변경: 수직 배열
        testimonialsWrapper.spacing = 30
        testimonialsWrapper.alignment = .fill // 변경: 수평 정렬을 채우기로 변경
        testimonialsWrapper.distribution = .fill // 변경: 높이 균등 분배 제거
        NSLayoutConstraint.activate([
            testimonialsWrapper.topAnchor.constraint(equalTo: testimonialsTitleLabel.bottomAnchor, constant: 40),
            testimonialsWrapper.leadingAnchor.constraint(equalTo: testimonialsSection.leadingAnchor, constant: 20),
            testimonialsWrapper.trailingAnchor.constraint(equalTo: testimonialsSection.trailingAnchor, constant: -20),
            testimonialsWrapper.bottomAnchor.constraint(equalTo: testimonialsSection.bottomAnchor)
        ])
        
        // 사용자 후기 데이터 정의
        let testimonialData = [
            ("이태규", "카페 자리있어 덕분에 항상 편리하게 카페를 찾을 수 있어요! 실시간 좌석 현황이 정말 유용하고, 사용이 간편해서 자주 이용하고 있습니다."),
            ("나예원", "실시간 좌석 현황 덕분에 카페에서 기다리는 시간이 없어졌어요. 혼잡도 체크 기능도 덕분에 평소보다 더 여유롭게 시간을 보낼 수 있었습니다."),
            ("민찬기", "스마트 검색 기능이 정말 유용해요. 근처에 새로운 카페를 발견하고 바로 예약까지 할 수 있어서 좋아요."),
            ("박상천", "카페 자리있어를 사용한 후로, 카페 선택이 훨씬 쉬워졌어요. 특히, 실시간 업데이트 덕분에 항상 최신 정보를 얻을 수 있어 만족합니다.")
        ]
        
        for data in testimonialData {
            let testimonialCard = TestimonialCard()
            testimonialCard.configure(userName: data.0, review: data.1)
            Theme.applyShadow(to: testimonialCard, shadow: Theme.Shadows.medium) // Corrected call
            testimonialsWrapper.addArrangedSubview(testimonialCard)
            
            // TestimonialCard의 너비를 testimonialsWrapper에 맞게 설정
            testimonialCard.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                testimonialCard.leadingAnchor.constraint(equalTo: testimonialsWrapper.leadingAnchor),
                testimonialCard.trailingAnchor.constraint(equalTo: testimonialsWrapper.trailingAnchor)
            ])
        }
    }
}
