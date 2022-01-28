//
//  ZodiacImages.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 26.07.2021.
//

import UIKit

class ZodiacImages{
    static func getImage(zodiac: MoonZodiacSign) -> UIImage{
        var imageName = ""
        switch zodiac {
        case .aries:
            imageName = "aries"
        case .cancer:
            imageName = "cancer"
        case .taurus:
            imageName = "taurus"
        case .leo:
            imageName = "leo"
        case .gemini:
            imageName = "gemini"
        case .virgo:
            imageName = "virgo"
        case .libra:
            imageName = "libra"
        case .capricorn:
            imageName = "capricorn"
        case .scorpio:
            imageName = "scorpio"
        case .aquarius:
            imageName = "aquarius"
        case .sagittarius:
            imageName = "sagittarius"
        case .pisces:
            imageName = "pisces"
        }
        return UIImage(named: imageName) ?? UIImage()
    }
}
