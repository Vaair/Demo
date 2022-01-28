//
//  FilterView.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 25.08.2021.
//

import UIKit

class FilterButton: UIButton {
    private var titleText = ""
    
    var isChoosed: Bool = false {
        didSet{
            isChoosed ? setEnable() : setUnable()
        }
    }
    
    func setUnable(){
        let attrs = [NSAttributedString.Key.font : UIFont.description3,
                     NSAttributedString.Key.foregroundColor : Colors.gray] as [NSAttributedString.Key : Any]
        
        let buttonTitleStr = NSMutableAttributedString(string: titleText, attributes: attrs)
        
        setAttributedTitle(buttonTitleStr, for: .normal)
    }
    
    func setEnable(){
        let attrs = [NSAttributedString.Key.font : UIFont.description3,
                     NSAttributedString.Key.foregroundColor : Colors.title1] as [NSAttributedString.Key : Any]
        
        let buttonTitleStr = NSMutableAttributedString(string: titleText, attributes: attrs)
        
        setAttributedTitle(buttonTitleStr, for: .normal)
    }
    
    init(title: String){
        self.titleText = title
        super.init(frame: CGRect())
        
        setupSelf()
        setEnable()
    }
    
    private func setupSelf(){
        backgroundColor = Colors.subView
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
