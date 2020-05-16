//
//  FlatSlider.swift
//
//  Created by Romain on 09/03/2020.
//

import SwiftUI

public struct FlatSlider: View {
	
	@Binding var progress : Float
	@Binding var color : UIColor
	@State private var width : CGFloat = 300
	
	public init(progress: Binding<Float>, color : Binding<UIColor>) {
		self._progress = progress
		self._color = color
	}
	
	public var body: some View {
		
		ZStack(alignment: .leading) {
			
			GeometryReader { geometry in
				
				ZStack(alignment: .leading) {
					Color(.tertiarySystemBackground)

					Color(self.color)
						.frame(width: geometry.size.width * CGFloat(self.progress))
						.cornerRadius(0)
					
					Color.black.opacity(0.08)
				}
				
				.onAppear {
					self.width = geometry.size.width
				}
				.gesture(DragGesture(minimumDistance: 0).onChanged({ value in
					self.progress = min(max(0, Float(value.location.x / geometry.size.width)), 1)
				}))
			}
			}
			.animation(.default)
	}
}

