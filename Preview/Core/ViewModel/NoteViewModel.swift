//
//  NoteViewModel.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 11.08.2021.
//

import UIKit

protocol NoteViewModelProtocol: AnyObject {
    var recordID: String{get}
    var model: NoteModel{get}
    var title: String {get}
    var descriptionText: NSAttributedString? {get}
    var moonDay: Int? {get}
    var signImage: UIImage {get}
    func illuminationImage() -> UIImage?
    var color: UIColor{get}
    var colorInt: Int{set get}
    var dateCreate: Date{get}
    var dateUpdate: Date{get}
    var indexPath: IndexPath?{get}
}

class NoteViewModel: NoteViewModelProtocol {
    
    var model: NoteModel
    
    var indexPath: IndexPath?
    
    var recordID: String {
        return model.recordID
    }
    
    var title: String {
        return model.title
    }
    
    var descriptionText: NSAttributedString? {
        return model.noteDescription
    }
    
    var moonDay: Int? {
        return model.moonDay
    }
    
    var dateCreate: Date{
        return model.dateCreate
    }
    
    var dateUpdate: Date{
        return model.dateUpdate
    }
    
    var signImage: UIImage {
        guard let sign = model.sign,
              let signType = MoonZodiacSign(rawValue: sign) else {return UIImage()}
        
        return ZodiacImages.getImage(zodiac: signType).withTintColor(Colors.blue)
    }
    
    
    func illuminationImage() -> UIImage? {
        guard let illumination = model.illumination else {return UIImage()}
        return UIImage(named: illumination)
    }
    
    var colorInt: Int{
        set {
            model.selectedColor = newValue
        }
        get{
            return model.selectedColor
        }
        
    }
    
    var color: UIColor{
        return moodColors[model.selectedColor]
    }
    
    init(model: NoteModel, indexPath: IndexPath?) {
        self.model = model
        self.indexPath = indexPath
    }
    
    
}
