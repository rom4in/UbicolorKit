//
//  TimeStepper.swift
//  render
//
//  Created by Romain on 26/02/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import SwiftUI

public struct TimeStepper: View {
	
	@Binding var time : Double
	
	public init(time : Binding<Double>) {
		self._time = time
	}
	
    public var body: some View {
		
		HStack(spacing: 12) {
			Image(systemName : "minus.circle")
				.resizable()
				.frame(width: 40, height: 40)
				.foregroundColor(.blue).opacity(time == 1 ? 0.2 : 1)
				.onTapGesture {
					if self.time > 1 {
						self.time -= 0.5
					}
				}
			Text(time.description + "s").bold().animation(.none)
			
			Image(systemName : "plus.circle.fill")
				.resizable()
				.frame(width: 44, height: 44)
				.foregroundColor(.blue)
				.onTapGesture {
					self.time += 0.5
				}
		}
    }
}
