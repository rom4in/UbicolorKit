//
//  ColorPicker.swift
//
//  Created by Romain on 08/03/2020.
//

import SwiftUI

public struct ColorPicker: View {
		
	@Binding var color : UIColor
	@Binding var showInfo : Bool

	@State private var hue : Float = 0.2
	@State private var colorPosition : CGSize = .zero
	@State private var isTouching = false
	
	
	public init(color: Binding<UIColor>, showInfo : Binding<Bool> = .constant(false)) {
		self._color = color
		self._showInfo = showInfo
	}
	public var body: some View {
		
		 VStack {
			showInfo ? ColorInfo(hue: $hue, color : self.$color) : nil
			
			GeometryReader { geometry in
				
				ColorView(hue: self.$hue)
					.smoothCorners(self.isTouching ? 0 : 20)
					.onAppear {
						let hsba = self.color.hsba
						self.hue = Float(hsba.h)
						let saturation = Double(hsba.s)
						let brightness = Double(hsba.b)
						self.colorPosition.width = geometry.size.width * CGFloat(saturation)
						self.colorPosition.height = geometry.size.height - (geometry.size.height * CGFloat(brightness))
						
					}
					.gesture(
						
						DragGesture(minimumDistance: 0).onChanged { value in
						self.isTouching = true
						let width = min(max(value.location.x, 0), geometry.size.width)
						let height = min(max(value.location.y, 0), geometry.size.height)
						self.colorPosition = CGSize(width: width, height: height)

						let saturation = self.colorPosition.width / geometry.size.width
						let brightness = 1 - (self.colorPosition.height / geometry.size.height)
						self.color = UIColor(hue: CGFloat(self.hue),
										 saturation: saturation,
										 brightness: brightness,
										 alpha: 1)
					
						//print(self.colorPosition.height, brightness)
					
					}.onEnded { _ in
					self.isTouching = false
					}
				
				)
				
				ColorPickerKnob(expanded: self.$isTouching, uiColor: self.$color)
					.offset(x :self.isTouching ? self.colorPosition.width - 45 :  self.colorPosition.width - 10,
							y: self.isTouching ? self.colorPosition.height - 45 : self.colorPosition.height - 10)
				
			}
					
			HueSlider(color: self.$color, hue: $hue)
			
		}
		.frame(minWidth: 200, idealWidth: 400, maxWidth: .infinity, minHeight: 300, idealHeight: 360, maxHeight: .infinity, alignment: .center)
		.animation(.default)
		.padding()
	}
	
	private struct ColorPickerKnob : View {
		
		@Binding var expanded : Bool
		@Binding var uiColor : UIColor

		
		public var body : some View {
			
			Circle()
				.fill(Color.clear)
				.overlay(
					Circle()
						.strokeBorder(style: StrokeStyle(lineWidth: 2,
														 lineCap: .round,
														 lineJoin: .bevel,
														 miterLimit: .greatestFiniteMagnitude,
														 dash: self.expanded ? [4] :  [1],
														 dashPhase: self.expanded ? 10 : 0))
				)
				.foregroundColor(Color(.systemBackground))
				.background(Color(uiColor).clipShape(Circle()))
				
				
				
				.animation(.linear)
				.shadow(color: Color.black.opacity(0.8), radius : 5)
				.frame(width : self.expanded ? 90 : 20, height: self.expanded ? 90 : 20)
			
		}
	}

	private struct ColorInfo : View {
		@Binding var hue : Float
		@Binding var color : UIColor
		
		func getHsba() -> (h: CGFloat, s: CGFloat, b: CGFloat, a: CGFloat) {
			return color.hsba
		}
		 var body : some View {
			
			 HStack {
				
				Text("H " + Int(hue * 360).description ).font(.headline).bold().padding(.leading, 8)
				Text("S " + Int((1 - getHsba().s) * 100).description ).font(.headline).bold()
				Text("B " + Int(getHsba().b * 100).description ).font(.headline).bold()

				Spacer()
				Text(self.color.getHex())
					.font(.title)
					.bold()
					
				Color(color)
					.frame(width: 50, height: 50).smoothCorners(12).padding(8)
			}
			.animation(.none)
		}
	}

	private struct ColorView  : View {
		
		//@Binding var color : UIColor
//		private var hue : Double { return Double(color.hsba.h)}
		@Binding var hue : Float

		
		 var body : some View {
			ZStack {
				LinearGradient(gradient: Gradient(colors: [.white, Color(hue: Double(self.hue),
																		 saturation: 1,
																		 brightness: 1)]),
							   startPoint: .leading, endPoint: .trailing)
				
				LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
			}.shadow()
		}
	}
	
	private struct HueSlider: View {
		
		@Binding var color : UIColor
		@State private var width : CGFloat = 300
		@Binding var hue : Float
				
		var body: some View {
			ZStack {
			
				GeometryReader { geometry in
				
				ZStack {
					LinearGradient(gradient: .spectrum, startPoint: .leading, endPoint: .trailing)
						.frame(height: 20).smoothCorners()
					Knob(hue: self.$hue)
						.offset(x: (CGFloat(self.hue) * self.width) - (self.width / 2))
				}
				.onAppear {
					self.hue = Float(self.color.hsba.h)
					self.width = geometry.size.width
				}
				.gesture(DragGesture(minimumDistance: 0).onChanged({ value in
					self.hue = Float(min(max(0, value.location.x / geometry.size.width), 1))
					let colorComponents = self.color.hsba
					self.color = UIColor(hue: CGFloat(self.hue), saturation: colorComponents.s, brightness: colorComponents.b, alpha: colorComponents.a)
				}))
			}
			}.frame(height: 80)
		}
		
		
		private struct Knob : View {
			@Binding var hue : Float
			var body : some View {
				Circle()
					.fill(Color(hue: Double(hue), saturation: 1, brightness: 1))
					.frame(width : 40, height: 40)
					.overlay(Circle().stroke(Color.white, lineWidth: 6))
					.shadow(radius: 10, x: 10, y: 10)
			}
			
		}
		
		
//		private let gradient = Gradient(colors: [
//			Color(hue: 0.0, saturation: 1, brightness: 1),
//			Color(hue: 0.1, saturation: 1, brightness: 1),
//			Color(hue: 0.2, saturation: 1, brightness: 1),
//			Color(hue: 0.3, saturation: 1, brightness: 1),
//			Color(hue: 0.4, saturation: 1, brightness: 1),
//			Color(hue: 0.5, saturation: 1, brightness: 1),
//			Color(hue: 0.6, saturation: 1, brightness: 1),
//			Color(hue: 0.7, saturation: 1, brightness: 1),
//			Color(hue: 0.8, saturation: 1, brightness: 1),
//			Color(hue: 0.9, saturation: 1, brightness: 1),
//			Color(hue: 1.0, saturation: 1, brightness: 1)
//		])
		
		
	}

}


struct ColorPicker_Previews: PreviewProvider {
    static var previews: some View {
		ColorPicker(color: .constant(.blue))
    }
}
