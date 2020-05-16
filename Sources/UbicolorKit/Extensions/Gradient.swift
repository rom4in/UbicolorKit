//
//  File.swift
//  
//
//  Created by BigMac on 16/05/2020.
//

import SwiftUI


public extension Gradient {
    
    static var spectrum : Gradient {
        
        var hues : [Color] = [Color]()
        
        for x in 0...360 {
            hues.append(Color(hue: Double(x) / 360 , saturation: 1, brightness: 1))
        }
        
        return Gradient(colors: hues)
    }
}

