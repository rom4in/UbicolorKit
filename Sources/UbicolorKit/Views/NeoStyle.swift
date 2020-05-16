//
//  File.swift
//  
//
//  Created by Romain on 08/03/2020.
//

import SwiftUI


public struct NeoShadow: ViewModifier {
	
	@Binding var pressed : Bool
	
	public func body(content : Content) -> some View {
		content
			.shadow(color: Color.shadow, radius: 10, x: pressed ? -10 : 10 , y: pressed ? -10 : 10)
	}
}

public struct NeoHighlight: ViewModifier {
	
	@Binding var pressed : Bool
	
	public func body(content : Content) -> some View {
		content
			.shadow(color: Color.highlight, radius: 10, x: pressed ? 10 : -10 , y: pressed ? 10 : -10)
	}
}

public struct NeoModifier : ViewModifier {
		
	@State var style : ButtonEdgesStyle
	@State var pressed : Bool
	
	public func body(content : Content) -> some View {
		
		content
			.background(Color.main
				.smoothCorners(30)
				.neoHighlight(pressed: $pressed)
				.neoShadow(pressed: $pressed)
				.blur(radius: style == .soft ? 2 : 0)
			)
	}
}


public enum ButtonEdgesStyle { case sharp, soft }

public struct NeoStyle: ButtonStyle {
	
	@Binding var isSelected : Bool
	@Binding var color : UIColor
	@Binding var style : ButtonEdgesStyle
	

	public init(selected: Binding<Bool> = .constant(false), color: Binding<UIColor> = .constant(.systemBlue) , style: Binding<ButtonEdgesStyle> = .constant(.soft)) {
		self._isSelected = selected
		self._color = color
		self._style = style
	}
		
	public func makeBody(configuration: Configuration) -> some View {

		
		configuration
			.label
			//.foregroundColor(isSelected ? .white : .label) //configuration.isPressed ? Color.black.opacity(0.2) : isSelected ? .white : color)
            .blendMode(.difference)
			.padding(.horizontal , 32)
			.padding(.vertical , 16)
			.background(Group { Color(isSelected ? color : .main) }
				.smoothCorners(30)
				.shadow(color:  .highlight, radius: 10, x: configuration.isPressed ? 5 : -5, y:configuration.isPressed ? 5 : -5)
				.shadow(color: .shadow , radius: 10, x: configuration.isPressed ? -5 : 5, y:configuration.isPressed ? -5 : 5)
				.blur(radius: style == .soft ? 2 : 0)
			)
			.padding()
			.animation(.easeInOut)
	}
}

