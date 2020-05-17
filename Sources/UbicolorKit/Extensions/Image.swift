//
//  File.swift
//  
//
//  Created by Romain on 13/03/2020.
//

import UIKit
import CoreImage.CIFilterBuiltins



public extension UIImage {
	
	func fixOrientation() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
		self.draw(in: rect)
		let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return normalizedImage
	}


	func scaled(by scale: CGFloat) -> UIImage? {
		// size has to be integer, otherwise it could get white lines
		let size = CGSize(width: floor(self.size.width * scale), height: floor(self.size.height * scale))
		UIGraphicsBeginImageContext(size)
		draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
	
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                    y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width,
                                    w: inputImage.extent.size.height)
        
        guard
            
            let filter = CIFilter(name: "CIAreaAverage",
                                  parameters: [
                                        kCIInputImageKey: inputImage,
                                        kCIInputExtentKey: extentVector]),
        
            let outputImage = filter.outputImage
            
            else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull ?? CGColorSpaceCreateDeviceRGB() ])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
	
}

