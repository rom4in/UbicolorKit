//
//  File.swift
//  
//  Created by Romain on 08/03/2020.
//

import SwiftUI

public extension View {
	
    func shadow() -> some View {
        
        return self.shadow(color: Color.black.opacity(0.2), radius : 20)
    }
	
    func doubleShadow(color: Color = Color.black, pressed: Bool = false) -> some View {
        
        self.modifier(DoubleShadow(color: color, pressed: pressed))
    }
	
	func smoothCorners(_ radius: CGFloat = 20) -> some View {
        
		self.modifier(CornerModifier(radius: radius))
	}
		
	func card() -> some View {
        
		return self.modifier(CardModifier())
	}
	
	func lookNice(opacity: Double = 1, cornerRadius: CGFloat = 20, doubleShadow : Bool = false) -> some View {
		
		return self
				.padding()
                .background(Color(.secondarySystemBackground).opacity(opacity))
				.smoothCorners(cornerRadius)
				.if(doubleShadow) { view in
					view.doubleShadow()
				}
				.if(!doubleShadow) { view in
					view.shadow()
				}
		}

	func neoShadow(pressed: Binding<Bool>) -> some View {
        
		   self.modifier(NeoShadow(pressed: pressed))
	   }
	
	func neoHighlight(pressed: Binding<Bool>) -> some View {
        
		self.modifier(NeoHighlight(pressed: pressed))
	}
	
	func neo(style: ButtonEdgesStyle = .soft, pressed: Bool = false) -> some View {
        
		self.modifier(NeoModifier(style: style, pressed: pressed ))
	}
	
    func `if`<T: View>(_ conditional: Bool, transform: (Self) -> T) -> some View {
        
        Group {
            
            if conditional {
                
                transform(self)
                
            } else {
                
                self
            }
        }
    }
    
    func maskContent<T: View>(using: T) -> some View {
        using.mask(self)
    }
	
}

public struct DoubleShadow: ViewModifier {
	
	@Environment(\.colorScheme) var colorScheme: ColorScheme

	var color : Color
    
	var pressed : Bool = false
    
	public func body(content : Content) -> some View {
		content
			.shadow(color: color.opacity( 0.2), radius: pressed ? 6 : 20, x: 0, y: pressed ? 6 : 20)
			.shadow(color: color.opacity(0.1), radius: 1, x: 0, y: 1)
	}
}

public struct CornerModifier: ViewModifier {
    var radius: CGFloat = 20
    public func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}

public struct CardModifier: ViewModifier {
    var radius: CGFloat = 20
    public func body(content: Content) -> some View {
        content
			.background(Color.main)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
			.shadow()
    }
}

