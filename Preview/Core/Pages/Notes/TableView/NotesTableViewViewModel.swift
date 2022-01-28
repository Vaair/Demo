//
//  NotesTableViewViewModel.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 15.08.2021.
//

import UIKit

protocol NotesTableViewViewModelProtocol: AnyObject {
    var count: Int {get}
    var height: CGFloat {get}
    
    func cellViewModel(forId id: IndexPath) -> NoteViewModelProtocol
    
    func getCellViewModel(forId id: IndexPath) -> NoteViewModelProtocol
    func deleteCellViewModel(forId id: IndexPath)
    func seacrh(text: String, completion: ([NoteModel]?)->())
}

class NotesTableViewViewModel: NotesTableViewViewModelProtocol {
    var content: [NoteModel]
    var filteredNote: [NoteModel]?
    private var contentViewModels: [NoteViewModel] = []
    
    var count: Int {
        if filteredNote != nil{
            return filteredNote!.count
        } else {
            return content.count
        }
    }
    
    var height: CGFloat {
        return CGFloat(count * 60)
    }
    
    func cellViewModel(forId id: IndexPath) -> NoteViewModelProtocol {
        var note: NoteModel
        if filteredNote != nil{
            note = filteredNote![id.row]
        } else {
            note = content[id.row]
        }
        
        let noteViewModel = NoteViewModel(model: note, indexPath: id)
        contentViewModels.append(noteViewModel)
        return noteViewModel
    }

    func getCellViewModel(forId id: IndexPath) -> NoteViewModelProtocol {
        let contentViewModel = contentViewModels[id.row]
        return contentViewModel
    }
    
    func deleteCellViewModel(forId id: IndexPath) {
        contentViewModels.remove(at: id.row)
        content.remove(at: id.row)
    }
    
    func seacrh(text: String, completion: ([NoteModel]?)->()) {
        var searchedNotes: [NoteModel]? = []
        var searchArray = [NoteModel]()
        if filteredNote != nil{
            searchArray = filteredNote!
        } else {
            searchArray = content
        }
        for note in searchArray{
            if note.title.contains(text) || note.noteDescription.string.contains(text){
                searchedNotes?.append(note)
            }
        }
        completion(searchedNotes)
    }
    
    func filter(filtered: [Int?], completion: ([NoteModel]?)->()) {
        var filteredNotes: [NoteModel]? = []
        for note in content{
            var countSelected = 0
            var matched = 0
            if filtered[0] != nil {
                countSelected += 1
                if note.moonDay == filtered[0] {
                    matched += 1
                }
            }
            if filtered[1] != nil{
                countSelected += 1
                if note.illumination == getPhase(numb: filtered[1]) {
                    matched += 1
                }
            }
            if filtered[2] != nil{
                countSelected += 1
                if note.sign == getSign(numb: filtered[2]) {
                    matched += 1
                }
            }
            if countSelected == matched {
                filteredNotes?.append(note)
            }
        }
        self.filteredNote = filteredNotes
        completion(filteredNotes)
    }
    
    private func getPhase(numb: Int?) -> String{
        guard let numb = numb else {return ""}
        var result = ""
        switch phasesForFilter[numb] {
        case "Новолуние":
            result = "newMoon"
        case "1-я Фаза":
            result = "firstPhase"
        case "1-я Четв.":
            result = "firstQ"
        case "2-я Фаза":
            result = "secondPhase"
        case "Полнолун.":
            result = "fullMoon"
        case "3-я Фаза":
            result = "thirdPhase"
        case "Посл. Четв.":
            result = "lastQ"
        case "4-я Фаза":
            result = "fourPhase"
        default:
            result = ""
        }
        
        return result
    }
    
    private func getSign(numb: Int?) -> String{
        guard let numb = numb else {return ""}
        return signForFilter[numb]
    }
    
    func enabledFilters(completion: ([Set<Int>?])->()){
        var enabledFilters: [Set<Int>?] = [ [], [], []]
        for note in content{
            enabledFilters[0]?.insert(note.moonDay!)
            if note.illumination != nil{
                enabledFilters[1]?.insert(getPhase(text: note.illumination!))
            }
            enabledFilters[2]?.insert(signForFilter.firstIndex(of: note.sign ?? "") ?? 0)
        }
        completion(enabledFilters)
    }
    
    private func getPhase(text: String) -> Int{
        var result = 0
        switch text {
        case "newMoon":
            result = 0
        case "firstPhase":
            result = 1
        case "firstQ":
            result = 2
        case "secondPhase":
            result = 3
        case "fullMoon":
            result = 4
        case "thirdPhase":
            result = 5
        case "lastQ":
            result = 6
        case "fourPhase":
            result = 7
        default:
            result = 0
        }
        
        return result
    }
    
    init(content: [NoteModel]) {
        self.content = content
    }
}

