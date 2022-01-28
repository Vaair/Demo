//
//  NotesTableView.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 18.08.2021.
//

import UIKit

class NotesTableView: UITableView {
    
    var viewModel: NotesTableViewViewModelProtocol?
    {
        didSet{
            reloadData()
        }
    }
    
    weak var context: NotesViewController?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        delegate = self
        dataSource = self
        
        allowsMultipleSelectionDuringEditing = true
        
        register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.reuseId)
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableFooterView = UIView()
        isScrollEnabled = false
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UITableViewDataSource
extension NotesTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseId, for: indexPath) as? NoteTableViewCell
        
        cell?.leading?.constant = 20
        guard let tableViewCell = cell,
              let viewModel = viewModel else { return UITableViewCell() }
        
        tableViewCell.tintColor = Colors.blue
        
        let cellViewModel = viewModel.cellViewModel(forId: indexPath)
        
        tableViewCell.viewModel = cellViewModel
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let viewModel = self.viewModel else {return}
            CoreDataProvider.removeNote(viewModel: viewModel.getCellViewModel(forId: indexPath))
            viewModel.deleteCellViewModel(forId: indexPath)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {[weak self] (_, _, completionHandler) in
            guard let viewModel = self?.viewModel else {return}
            CoreDataProvider.removeNote(viewModel: viewModel.getCellViewModel(forId: indexPath))
            viewModel.deleteCellViewModel(forId: indexPath)
            tableView.deleteRows(at: [indexPath], with: .left)
            self?.context?.getData()
        }
        deleteAction.image = UIImage(named: "trash")?.withTintColor(.white)
        deleteAction.backgroundColor = Colors.notSelected
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        MainViewController.shared?.navigationItem.rightBarButtonItem?.title = editing ? "Готово" : "Выбрать"
        
        guard let viewModel = viewModel else {return}
        for id in 0..<viewModel.count{
            let cell = cellForRow(at: IndexPath(row: id, section: 0)) as? NoteTableViewCell
            UIView.animate(withDuration: 0.3) {[weak self] in
                guard let self = self else {return}
                if self.isEditing {
                    cell?.leading?.constant = 60
                } else {
                    cell?.leading?.constant = 20
                }
                cell?.layoutIfNeeded()
            }
            
        }
    }
}

// MARK: - UITableViewDelegate
extension NotesTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !isEditing{
            guard let viewModel = viewModel else {return}
            
            let vc = NewNoteViewController(isNew: false)
            vc.viewModel = viewModel.getCellViewModel(forId: indexPath)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            context?.present(navVC, animated: true, completion: nil)
            
            deselectRow(at: indexPath, animated: true)
        } else {
            MainViewController.shared?.toolbarItems?[1].title = "Удалить"
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPathsForSelectedRows == nil {
            MainViewController.shared?.toolbarItems?[1].title = "Удалить все"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    } 
}

