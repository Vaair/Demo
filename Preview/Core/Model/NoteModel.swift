//
//  NoteModel.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 11.08.2021.
//

import UIKit

struct NoteModel {
    var noteID         : String = UUID().uuidString //локальный id
    var recordID       : String = ""                //облачный id
    var title          : String
    var noteDescription: NSAttributedString
    var dateCreate     : Date
    var dateUpdate     : Date
    
    var selectedColor: Int
    var moonDay      : Int?
    var sign         : String?
    var illumination : String?
    
    init(note: NoteInfo){
        recordID        = note.recordID ?? ""
        title           = note.title ?? "Название заметки"
        noteDescription = note.noteDescription ?? NSAttributedString(string: "Описание заметки")
        dateCreate      = note.dateCreate ?? Date()
        dateUpdate      = note.dateUpdate ?? Date()
        
        selectedColor = (note.selectedColor as? Int) ?? 0
        moonDay       = note.moonDay as? Int
        sign          = note.sign
        illumination  = note.illumination
    }
    
    init(noteID         : String,
         recordID       : String,
         title          : String,
         noteDescription: NSAttributedString,
         dateCreate     : Date,
         dateUpdate     : Date,
         selectedColor  : Int,
         moonDay        : Int?,
         sign           : String?,
         illumination   : String?){
        self.noteID          = noteID
        self.recordID        = recordID
        self.title           = title
        self.noteDescription = noteDescription
        self.dateCreate      = dateCreate
        self.dateUpdate      = dateUpdate
        
        self.selectedColor = selectedColor
        self.moonDay       = moonDay
        self.sign          = sign
        self.illumination  = illumination
    }
}

