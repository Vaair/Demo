//
//  NotesViewModel.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 18.08.2021.
//

import UIKit

protocol NotesViewModelProtocol: AnyObject {
    var height: CGFloat {set get}
    var count: Int {get}
    func getViewModel(completion: @escaping (NotesTableViewViewModel)->())
}

class NotesViewModel: NotesViewModelProtocol {
    var height: CGFloat = 0
    var count = -1
    
    func getViewModel(completion: @escaping (NotesTableViewViewModel)->()) {
        CoreDataProvider.getNotes {[weak self] notes in
            guard let self = self else {return}
            var notesArray: [NoteModel] = []
            for note in notes {
                let noteModel = NoteModel(note: note)
                notesArray.append(noteModel)
            }
            notesArray.sort{$0.dateUpdate > $1.dateUpdate}
            let viewModel = NotesTableViewViewModel(content: notesArray)
            self.height = viewModel.height
            self.count = viewModel.count
            completion(viewModel)
        }
    }
    
    
}
