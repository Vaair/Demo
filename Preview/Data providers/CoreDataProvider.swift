//
//  CoreDataProvider.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 22.08.2021.
//

import UIKit
import CoreData

final class CoreDataProvider {
    private static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private static let context = appDelegate.persistentContainer.viewContext
    
    private static let fetchRequest: NSFetchRequest<NoteInfo> = NoteInfo.fetchRequest()
    private static let editFetchRequest: NSFetchRequest<NoteInfo> = NoteInfo.fetchRequest()
    
    static func saveNote(note: NoteModel){
        DispatchQueue.main.async {
            guard let entity = NSEntityDescription.entity(forEntityName: "NoteInfo", in: context) else { return }
            
            let noteOdject = NoteInfo(entity: entity, insertInto: context)
            noteOdject.recordID = note.recordID
            noteOdject.noteID = note.noteID
            noteOdject.title = note.title
            noteOdject.noteDescription = note.noteDescription
            noteOdject.dateCreate = note.dateCreate
            noteOdject.dateUpdate = note.dateUpdate
            noteOdject.moonDay = NSDecimalNumber(value: note.moonDay ?? 1)
            noteOdject.illumination = note.illumination
            noteOdject.sign = note.sign
            noteOdject.selectedColor = NSDecimalNumber(value: note.selectedColor)
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
    }
    
    static func getNotes(completion: @escaping ([NoteInfo]) -> ()) {
        DispatchQueue.main.async {
            var notes: [NoteInfo]
            do {
                notes = try context.fetch(fetchRequest)
                completion(notes)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    static func updateNote(note: NoteModel, isNotUpdate: Bool) {
        DispatchQueue.main.async {
            editFetchRequest.predicate = NSPredicate(format: "dateCreate == %@",
                                                     note.dateCreate as NSDate )
            
            do {
                let results = try context.fetch(editFetchRequest).first
                results?.recordID = note.recordID
                results?.noteID = note.noteID
                results?.title = note.title
                results?.noteDescription = note.noteDescription
                results?.dateUpdate = isNotUpdate ? note.dateUpdate : Date()
                results?.selectedColor = NSDecimalNumber(value: note.selectedColor)
                results?.illumination = note.illumination ?? ""
                results?.sign = note.sign ?? ""
                results?.moonDay = NSDecimalNumber(value: note.moonDay ?? 1)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            if context.hasChanges{
                do {
                    try context.save()
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    static func removeAll() {
        let manager = FileManager.default
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        
        let localURL = documentsURL.appendingPathComponent("Moon Note")
        
        do {
            try manager.removeItem(at: localURL)
        } catch let error as NSError {
            print(error.description)
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
        } catch let error {
            print("Detele all data in NoteInfo error :", error)
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    static func removeNote(viewModel: NoteViewModelProtocol) {
        DispatchQueue.main.async {
            let manager = FileManager.default
            guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            
            let localURL = documentsURL.appendingPathComponent("Moon Note")
            
            do {
                try manager.removeItem(at: localURL)
            } catch let error as NSError {
                print(error.description)
            }
            
            do {
                let results = try context.fetch(fetchRequest)
                for object in results {
                    if object.dateCreate == viewModel.dateCreate {
                        context.delete(object)
                    }
                }
            } catch let error {
                print("Detele data in NoteInfo error :", error)
            }
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
}
