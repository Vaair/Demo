//
//  ButtonExtension.swift
//  Preview
//
//  Created by Лера Тарасенко on 28.01.2022.
//

import UIKit

extension UIButton{
    func nextStyle(title: String){
        backgroundColor = Colors.blue
        layer.cornerRadius = (UIScreen.main.bounds.width * 0.16) * 0.25
        addShadow()
        setupStyle(title: title, font: .nextButton, color: Colors.main)
    }
    
    private func addShadow() {
        let color = Colors.blue.withAlphaComponent(0.4).cgColor
        layer.shadowColor = color
        layer.shadowOffset = CGSize(width: -1, height: 2)
        layer.shadowRadius = 15
        layer.shadowOpacity = 1
    }
    
    private func setupStyle(title: String,
                    font: UIFont,
                    color: UIColor){
        let attrs = [NSAttributedString.Key.font : font,
                     NSAttributedString.Key.foregroundColor : color] as [NSAttributedString.Key : Any]
        
        let attributedString = NSMutableAttributedString(string: "")
        
        let buttonTitleStr = NSMutableAttributedString(string: title, attributes: attrs)
        attributedString.append(buttonTitleStr)
        
        setAttributedTitle(attributedString, for: .normal)
    }
}
