//
//  ColorSwitch.swift
//  componentsUI
//
//  Created by Romain on 11/03/2020.
//  Copyright © 2020 Ubicolor. All rights reserved.
//
import SwiftUI




public struct ColorSwitch: View {
	
	@Binding var isOn : Bool
	@State var onColor : Color = .blue
	@State var offColor : Color = .gray
	@State private var width : CGFloat = 88
		
	public init(isOn: Binding<Bool>, onColor : Color, offColor: Color) {
		self._isOn = isOn
		self.onColor = onColor
		self.offColor = offColor
	}
	
	var innerEdgeGradient : LinearGradient {
		LinearGradient(gradient: Gradient(colors: [Color(.topInnerEdge)  , Color(.bottomInnerEdge)]) ,
						startPoint: .top,
						endPoint: .bottom)
		
	}
			
	
	
	public var body: some View {
		
		HStack {
			isOn ? onColor : offColor
		}
		.frame(width: 88, height: 44)
			.overlay(
				ZStack {
					RoundedRectangle(cornerRadius: 16, style: .continuous)
						.stroke(
							innerEdgeGradient,
							lineWidth: 8)
						.shadow(radius: 4, x: 0, y: 4)
					
					RoundedRectangle(cornerRadius: 15, style: .continuous)
						.fill(Color.main)
						.frame(width: 42, height: 42).shadow(color: .shadow, radius: 8, x: 0, y: 0)
						.offset(x: isOn ? -22 : 22)
				}
			)
			.mask(Color.orange.smoothCorners(16))
			.animation(.default)
			.onTapGesture {
			self.isOn.toggle()
			}
			.gesture(DragGesture(minimumDistance: 1).onChanged({ value in

				let distance = value.location.x - value.startLocation.x
			
				if !self.isOn && distance < -5 {
					self.isOn = true
			}
			if self.isOn && distance > 5 {
				self.isOn = false
			}
			
		}))
	}
	
}
