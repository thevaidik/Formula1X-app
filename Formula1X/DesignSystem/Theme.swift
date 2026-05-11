import SwiftUI

struct Theme {
    static let background = Color(hex: "121212")
    static let salmonPink = Color(hex: "E3908C")
    static let mustardYellow = Color(hex: "DDA23B")
    static let oliveGreen = Color(hex: "A0A87A")
    static let deepRed = Color(hex: "C34242")
    static let lightGrey = Color(hex: "CDCACA")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct RetroFontModifier: ViewModifier {
    var size: CGFloat
    var isTitle: Bool = false
    
    func body(content: Content) -> some View {
        content
            // Using a serif font as an approximation for the vintage poster font
            .font(.system(size: size, weight: isTitle ? .black : .regular, design: .serif))
            // Only available in iOS 16+, provides the condensed look
            .fontWidth(isTitle ? .condensed : .standard)
    }
}

extension View {
    func retroFont(size: CGFloat, isTitle: Bool = false) -> some View {
        self.modifier(RetroFontModifier(size: size, isTitle: isTitle))
    }
    
    func retroBorder(color: Color = .black, width: CGFloat = 1) -> some View {
        self.overlay(
            Rectangle().stroke(color, lineWidth: width)
        )
    }
    
    func topBorder(color: Color = .black, width: CGFloat = 1) -> some View {
        self.overlay(
            Rectangle().frame(height: width).foregroundColor(color),
            alignment: .top
        )
    }
    
    func bottomBorder(color: Color = .black, width: CGFloat = 1) -> some View {
        self.overlay(
            Rectangle().frame(height: width).foregroundColor(color),
            alignment: .bottom
        )
    }
}
