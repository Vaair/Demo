//
//  Fonts.swift
//  Preview
//
//  Created by Лера Тарасенко on 28.01.2022.
//

import UIKit

enum FontType: String{
    case extraBold = "Montserrat-ExtraBold"
    case bold      = "Montserrat-Bold"
    case semibold  = "Montserrat-SemiBold"
    case regular   = "Montserrat-Regular"
    case light     = "Montserrat-Light"
}

extension UIFont {
    class var title1:       UIFont {.getFont(fontType: .bold,     smartSize: 25)}
    class var title2:       UIFont {.getFont(fontType: .semibold, smartSize: 24)}
    class var day:          UIFont {.getFont(fontType: .semibold, smartSize: 22)}
    class var moonDay:      UIFont {.getFont(fontType: .semibold, smartSize: 20)}
    class var nextButton:   UIFont {.getFont(fontType: .semibold, smartSize: 17)}
    class var description:  UIFont {.getFont(fontType: .regular,  smartSize: 17)}
    class var description2: UIFont {.getFont(fontType: .regular,  smartSize: 16)}
    class var description3: UIFont {.getFont(fontType: .regular,  smartSize: 15)}
    class var description4: UIFont {.getFont(fontType: .semibold, smartSize: 15)}
    class var procent:      UIFont {.getFont(fontType: .semibold, smartSize: 13)}
    class var down:         UIFont {.getFont(fontType: .regular,  smartSize: 13)}
    class var phase:        UIFont {.getFont(fontType: .regular,  smartSize: 11)}
    
    static func getFont(fontType: FontType, smartSize: CGFloat) -> UIFont {
        return UIFont(descriptor: UIFontDescriptor(name: fontType.rawValue, size: 0), size: smartSize)
    }
}
