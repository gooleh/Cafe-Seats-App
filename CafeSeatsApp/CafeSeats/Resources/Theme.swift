// Theme.swift
import UIKit

enum Theme {
    enum Colors {
        static let primary = UIColor(hex: "#6B4423") // 진한 브라운 (메인 강조색)
        static let secondary = UIColor(hex: "#967259") // 중간 브라운 (보조 강조색)
        static let tertiary = UIColor(hex: "#DBC1AC") // 연한 브라운 (포인트 색상)
        static let background = UIColor(hex: "#FDF6EC") // 아이보리 (배경색)

        enum Text {
            static let primary = UIColor(hex: "#2C1810") // 진한 브라운 (주요 텍스트)
            static let secondary = UIColor(hex: "#785942") // 중간 브라운 (보조 텍스트)
            static let light = UIColor(hex: "#FDF6EC") // 밝은 색 (밝은 배경의 텍스트)
        }

        // 추가 색상
        static let accent = UIColor(hex: "#C77D4F") // 따뜻한 브라운 (강조색)
        static let hover = UIColor(hex: "#8B573C") // 호버 상태 색상
        static let footerBackground = UIColor(hex: "#6B4423") // 진한 브라운 (푸터 배경색)
        static let overlayGradientStart = UIColor(red: 107/255, green: 68/255, blue: 35/255, alpha: 0.8)
        static let overlayGradientEnd = UIColor(red: 150/255, green: 114/255, blue: 89/255, alpha: 0.8)
        static let border = UIColor(hex: "#e0e0e0") // 경계선 색상
    }

    enum Shadows {
        struct Shadow {
            let offset: CGSize
            let radius: CGFloat
            let opacity: Float
        }

        static let small = Shadow(offset: CGSize(width: 0, height: 2), radius: 4, opacity: 0.1)
        static let medium = Shadow(offset: CGSize(width: 0, height: 4), radius: 6, opacity: 0.15)
        static let large = Shadow(offset: CGSize(width: 0, height: 6), radius: 12, opacity: 0.2)
    }

    enum Fonts {
        static let primary = UIFont(name: "NotoSansKR-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        // 필요에 따라 다른 폰트 스타일 추가
    }

    // Theme에 applyShadow 메서드 직접 추가
    static func applyShadow(to view: UIView, shadow: Shadows.Shadow) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = shadow.offset
        view.layer.shadowRadius = shadow.radius
        view.layer.shadowOpacity = shadow.opacity
        view.layer.masksToBounds = false
    }
}

// UIColor extension to initialize with hex string
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized

        var rgb: UInt64 = 0
        let scanner = Scanner(string: hexSanitized)
        let success = scanner.scanHexInt64(&rgb)

        if !success || hexSanitized.count != 6 {
            // 스캔 실패 시 기본 색상(예: 흰색)으로 설정
            self.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            return
        }

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
