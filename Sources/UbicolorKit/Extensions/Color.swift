//
//  Color Extensions.swift
//  componentsUI
//
//  Created by Romain on 12/03/2020.
//  Copyright © 2020 Ubicolor. All rights reserved.
//

import SwiftUI

public extension Color {
    
    ///Black in light mode, White in dark mode
    static var label : Color { return Color(.label)}
    
    ///White in light mode, Black in dark mode
    static var background : Color { return Color(.systemBackground)}
    
    static var secondaryBackground : Color { return Color(.secondarySystemBackground)}
    
    static var teritiaryBackground : Color { return Color(.tertiarySystemBackground)}
    
    ///Off-white in light mode, off-black in dark mode
    static var main : Color { Color(.main) }
    
    ///Used for NeuMorphic button Style, this is the color at the top-left of the button
    static var highlight : Color { Color(.highlight) }
    
    ///Used for NeuMorphic button Style, this is the color at the bottom-right of the button
    static var shadow : Color { Color(.shadow) }
    
    ///Used for NeuMorphic button Style, this is the color at the top-left inner edge of the button
    static var topInnerEdge : Color { Color(.topInnerEdge) }
    
    ///Used for NeuMorphic button Style, this is the color at the bottom-right inner edge of the button
    static var bottomInnerEdge : Color { Color(.bottomInnerEdge) }
    
    
}

public extension UIColor {
    
    static var main : UIColor  {
        
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            
            if UITraitCollection.userInterfaceStyle == .light {
                
                return #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
                
            } else {
                
                return #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 1)
            }
        }
    }
    
    static var highlight : UIColor  {
        
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            
            if UITraitCollection.userInterfaceStyle == .light {
                
                return #colorLiteral(red: 0.9965298772, green: 0.9911895394, blue: 1, alpha: 1)
                
                
            } else {
                
                
                return #colorLiteral(red: 0.9965298772, green: 0.9911895394, blue: 1, alpha: 0.1434821429)
            }
        }
    }
    
    static var shadow : UIColor  {
        
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            
            if UITraitCollection.userInterfaceStyle == .light {
                
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2035714286)
                
            } else {
                
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            }
        }
    }
    
    static var topInnerEdge : UIColor {
        
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            
            if UITraitCollection.userInterfaceStyle == .light {
                
                return #colorLiteral(red: 0.8745098039, green: 0.8745098039, blue: 0.8745098039, alpha: 1)
                
            } else {
                
                return #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
            }
        }
    }
    
    static var bottomInnerEdge : UIColor {
        
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            
            if UITraitCollection.userInterfaceStyle == .light {
                
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
            } else {
                
                return #colorLiteral(red: 0.3058823529, green: 0.3058823529, blue: 0.3058823529, alpha: 1)
            }
        }
    }
    
    
    
    /// The CMYK (cyan, magenta, yellow, black) components of a color, in the range [0, 100%].
    struct CMYK: Hashable {
        
        /// The cyan component of the color, in the range [0, 100%].
        var cyan: CGFloat
        /// The magenta component of the color, in the range [0, 100%].
        var magenta: CGFloat
        /// The yellow component of the color, in the range [0, 100%].
        var yellow: CGFloat
        /// The black component of the color, in the range [0, 100%].
        var black: CGFloat
        
    }
    
    /// The CMYK (cyan, magenta, yellow, black) components of the color, in the range [0, 100%].
    var cmyk: CMYK {
        var (r, g, b) = (CGFloat(), CGFloat(), CGFloat())
        getRed(&r, green: &g, blue: &b, alpha: nil)
        
        let k = 1.0 - max(r, g, b)
        var c = (1.0 - r - k) / (1.0 - k)
        var m = (1.0 - g - k) / (1.0 - k)
        var y = (1.0 - b - k) / (1.0 - k)
        
        if c.isNaN { c = 0.0 }
        if m.isNaN { m = 0.0 }
        if y.isNaN { y = 0.0 }
        
        return CMYK(cyan: c * 100.0,
                    magenta: m * 100.0,
                    yellow: y * 100.0,
                    black: k * 100.0)
    }
    
    
    
    func getHex() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        let hex = String(format:"%06x", rgb)
        return hex.uppercased()
    }
    
    var hsba : (h: CGFloat, s: CGFloat,b: CGFloat,a: CGFloat) {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (h: h, s: s, b: b, a: a)
    }
    
    func image(size: CGSize = CGSize(width: 4, height: 4)) -> UIImage {
        
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
    
    
    static func fromHex (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
    
}
