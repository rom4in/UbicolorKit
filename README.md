# UbicolorKit


This is a SwiftUI components library. it includes useful Views and extensions.

# ColorPicker : View

ColorPicker(color : <Binding>UIColor)

# Color extensions

`Color.label`

`Color.secondaryBackground`


# UIColor extensions

`func image(size: CGSize = CGSize(width: 4, height: 4)) -> UIImage`

HEX color without  # example :  "3349EE"
`func getHex() -> String` 

`var rgba -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)`

`var cmyk -> CMYK(cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, black: CGFloat)`

`var hsba : (h: CGFloat, s: CGFloat,b: CGFloat,a: CGFloat)`


# Gradient extensions

Get a gradient of Hues from 0 to 360
`Gradient.spectrum : Gradient` 


# UIImage extensions

because sometimes it has a weird orientation...
`func fixOrientation() -> UIImage`


`func scaled(by scale: CGFloat) -> UIImage?` {`


`var averageColor: UIColor?`


includes Image Colors from  https://github.com/jathu/UIImageColors//
`UIImageColor(background: UIColor, primary: UIColor, secondary: UIColor, detail: UIColor)`

# UIView extensions

`func renderedImage() -> UIImage`

`func getColor(at point : CGPoint)  -> UIColor?`
