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
	
	func blended(with mask : CIImage) -> CIImage? {
		print("Blend image size: ", self.scale)

		
		guard let inputImage = CIImage(image: self) else {
			print("nil here")
			return nil}
		
        let blend = CIFilter.blendWithMask()
        blend.inputImage = inputImage
		blend.maskImage = mask
        return blend.outputImage
	}
	
	var poster : UIImage? {
		guard let inputImage = CIImage(image: self) else {
			print("nil here")
			return nil}
		let posterize = CIFilter.colorPosterize()
        posterize.inputImage = inputImage
		if let image =  posterize.outputImage {
			return UIImage(ciImage: image)
		} else {
			return nil
		}
	}
	
	var removeShadows : UIImage? {
		guard let inputImage = CIImage(image: self) else {
			print("nil here")
			return nil}
		let filter = CIFilter.highlightShadowAdjust()
        filter.inputImage = inputImage
		filter.highlightAmount = 0
		filter.shadowAmount = 0
		if let image =  filter.outputImage {
			return UIImage(ciImage: image)
		} else {
			return nil
		}
	}

	var blurred : UIImage? {
		guard let inputImage = CIImage(image: self) else {
			print("nil here")
			return nil}
		let posterize = CIFilter.gaussianBlur()
        posterize.inputImage = inputImage
		posterize.radius = 50
		if let image =  posterize.outputImage {
			return UIImage(ciImage: image)
		} else {
			return nil
		}
	}
	
	func addOverLay(image: UIImage) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
		draw(in: CGRect(origin: CGPoint.zero, size: size))
		image.draw(in: CGRect(origin: CGPoint(), size: image.size))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return newImage
	}
	

	
	func colorize(with color : UIColor ) -> UIImage? {
		
		guard let inputImage = CIImage(image: self) else {
			print("nil colorize")
			return nil}
		let filter = CIFilter.colorMonochrome()
        filter.inputImage = inputImage
		let ciColor = CIColor(color: color)
		filter.color = ciColor
		filter.intensity = 1
		if let image =  filter.outputImage {
			return UIImage(ciImage: image)
		} else {
			return nil
		}
	}
	
	func hueAdjusted(with number : Float ) -> UIImage? {
		
		guard let inputImage = CIImage(image: self) else {
			print("nil hue adjust")
			return nil}
		let filter = CIFilter.hueAdjust()
        filter.inputImage = inputImage
		filter.angle = number
		if let image =  filter.outputImage {
			return UIImage(ciImage: image)
		} else {
			return nil
		}
	}
	
	func colorBlend(with color : UIColor ) -> UIImage? {
		
		guard let inputImage = CIImage(image: self) else {
			print("nil hue adjust")
			return nil}
		let colorImage = color.image(size: self.size)
		let ciColorImage = CIImage(image: colorImage)
		let filter = CIFilter.colorBlendMode()
		filter.inputImage = inputImage
		filter.backgroundImage =  ciColorImage!
		if let image =  filter.outputImage {
			return UIImage(ciImage: image)
		} else {
			return nil
		}
	}
	func colorControl(contrast : Float , brightness: Float, saturation: Float) -> UIImage? {
		
		guard let inputImage = CIImage(image: self) else {
			print("nil hue adjust")
			return nil}
		let filter = CIFilter.colorControls()
		filter.inputImage = inputImage
		filter.brightness = brightness
		filter.contrast = contrast
		filter.saturation = saturation

		if let image =  filter.outputImage {
			return UIImage(ciImage: image)
		} else {
			return nil
		}
	}
	
	func blend(with blendMode: CGBlendMode, color: UIColor) -> UIImage {

		let imageColor = color.image(size: self.size)

	  let rectImage = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)

	  UIGraphicsBeginImageContextWithOptions(self.size, true, 0)
	  let context = UIGraphicsGetCurrentContext()

	  // fill the background with white so that translucent colors get lighter
	  context!.setFillColor(UIColor.clear.cgColor)
	  context!.fill(rectImage)

		self.draw(in: rectImage, blendMode: .normal, alpha: 1)
	  imageColor.draw(in: rectImage, blendMode: blendMode, alpha: 1)
	  let result = UIGraphicsGetImageFromCurrentImageContext()
	  UIGraphicsEndImageContext()
	  return result!

	}
	

	
}

