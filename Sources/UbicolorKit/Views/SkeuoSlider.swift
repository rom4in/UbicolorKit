//
//  SkeuoSlider.swift
//  pbrmaterials
//
//  Created by Romain on 08/03/2020.
//  Copyright © 2020 Ubicolor. All rights reserved.


import SwiftUI

public struct SkeuoSlider : View {
	
	@Binding var progress: Float
	@State var foregroundColor : UIColor = UIColor.blue
	@State var backgroundColor : UIColor = UIColor.main

	@State private var width : CGFloat = 100
	
	public init(progress: Binding<Float>, foregroundColor : UIColor, backgroundColor: UIColor) {
		self._progress = progress
		self.foregroundColor = foregroundColor
		self.backgroundColor = backgroundColor
	}
	
	public var body: some View {
		
		ZStack {
			
			ZStack(alignment: .leading) {
				
				Color(self.backgroundColor)
				Color(self.foregroundColor)
					.frame(width: width * CGFloat(self.progress))
					.smoothCorners()
				
				GeometryReader { geometry in
					
					LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.2), .clear]), startPoint: .top, endPoint: .bottom)
						
						.onAppear {
							self.width = geometry.size.width
					}
				}
			}
			.overlay(
				ZStack {
					RoundedRectangle(cornerRadius: 20, style: .continuous)
						.stroke(
							LinearGradient(gradient: Gradient(colors: [Color(.topInnerEdge)  , Color(.bottomInnerEdge)]) ,
							startPoint: .top,
							endPoint: .bottom),
							lineWidth: 8)
						.shadow(radius: 4, x: 0, y: 4)
				}				
			)
				.mask(Color.orange.smoothCorners())
		}
		.gesture(DragGesture(minimumDistance: 0)
		.onChanged({ value in
			self.progress = min(max(0, Float(value.location.x / self.width)), 1)
		}))
			.animation(.default)
	}
}
