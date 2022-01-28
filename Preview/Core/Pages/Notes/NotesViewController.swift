//
//  NotesViewController.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 17.07.2021.
//

import UIKit

class NotesViewController: UIViewController {
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var searchedNotes: [NoteViewModel]?
    
    private var scroll: UIScrollView = {
        let scr = UIScrollView(frame: UIScreen.main.bounds)
        scr.alwaysBounceVertical = true
        scr.showsVerticalScrollIndicator = true
        return scr
    }()
    
    private let newNoteImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "newNote")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let newNoteLabel: UILabel = {
        let label = UILabel()
        label.text = "У вас еще нет заметок! Нажмите “+” чтобы добавить новую лунную заметку"
        label.font = UIFont.description
        label.textColor = Colors.gray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fakeView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.background
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var viewModel: NotesViewModelProtocol = NotesViewModel()
    
    var tableView = NotesTableView()
    var tableViewViewModel: NotesTableViewViewModel?
    
    var tableHeight: NSLayoutConstraint?
    var tableTop: NSLayoutConstraint?
    var isThereTableView = false
    
    var filterViews = [FilterView]()
    var selected: [Int?] = [nil, nil, nil]
    let adScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
    
    var isLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoad = true
        view.addSubview(scroll)
        searchController.searchBar.delegate = self
        
        getData(){[weak self] in
            guard let self = self, let tableViewModel = self.tableView.viewModel else {return}
            if tableViewModel.height != 0 {
                self.setupSearchController()
            }
        }
        arrangeFakeView()
        scroll.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        MainViewController.shared?.title = "Заметки"
        guard let tableViewModel = tableView.viewModel else {return}
        if tableViewModel.height == 0 {
            MainViewController.shared?.rightBarButtonTag = .none
        } else {
            setupSearchController()
            
            if filterViews.count > 0 {
                MainViewController.shared?.rightBarButtonTag = .reset
            } else {
                MainViewController.shared?.rightBarButtonTag = .choose
            }
            if tableView.isEditing {
                MainViewController.shared?.navigationController?.setToolbarHidden(false, animated: false)
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if filterViews.count > 0{
            scroll.contentSize.height = tableView.frame.height + UIScreen.main.bounds.height * 0.05 + 50
            tableTop?.constant = 50
        } else {
            scroll.contentSize.height = tableView.frame.height + UIScreen.main.bounds.height * 0.05
            tableTop?.constant = 0
        }
        adScroll.contentSize.width = (filterViews.last?.frame.maxX ?? 0) + 16
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        MainViewController.shared?.navigationController?.setToolbarHidden(tableView.isEditing, animated: false)
        MainViewController.shared?.tabBar.isHidden = !tableView.isEditing
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    private func updateData(){
        guard tableView.viewModel != nil && tableView.viewModel?.count != 0 else {
            tableHeight?.constant = ((tableView.viewModel?.height) ?? 1.0) - 1
            MainViewController.shared?.navigationItem.searchController = nil
            MainViewController.shared?.rightBarButtonTag = .none
            arrangeNewNoteImageView()
            arrangeNewNoteLabel()
            return
        }
        newNoteLabel.removeFromSuperview()
        newNoteImageView.removeFromSuperview()
        tableView.context = self
        if !isThereTableView {
            setupTableView()
        } else {
            tableHeight?.constant = ((tableView.viewModel?.height) ?? 1.0) - 1
        }
        
    }
    
    func getData(_ completion: @escaping ()->() = {}){
        if !isLoad {return}
        viewModel.getViewModel {[weak self] notesViewModel in
            guard let self = self else {return}
            self.tableView.viewModel = notesViewModel
            self.tableViewViewModel = notesViewModel
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.updateData()
                self.tableView.reloadData()
            }
            completion()
        }
    }
    
    private func arrangeFakeView(){
        view.addSubview(fakeView)
        view.bringSubviewToFront(fakeView)
        fakeView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        fakeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        fakeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        fakeView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.11).isActive = true
    }
    
    private func arrangeNewNoteImageView(){
        view.addSubview(newNoteImageView)
        newNoteImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newNoteImageView.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func arrangeNewNoteLabel(){
        view.addSubview(newNoteLabel)
        newNoteLabel.topAnchor.constraint(equalTo: newNoteImageView.bottomAnchor, constant: 84).isActive = true
        newNoteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        newNoteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
    }
    
    private func setupSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false //доступ к отображаемому контену
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.searchTextField.backgroundColor = Colors.dark
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        MainViewController.shared?.navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(named: "filter"), for: .bookmark, state: .normal)
        
    }
    
    private func setupTableView(){
        isThereTableView = true
        tableView.backgroundColor = Colors.subView
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        scroll.addSubview(tableView)
        tableTop = tableView.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 10)
        tableTop?.isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        tableView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16).isActive = true
        tableHeight = tableView.heightAnchor.constraint(equalToConstant: ((tableView.viewModel?.height) ?? 1.0) - 1 )
        tableHeight?.isActive = true
        
        tableView.layoutIfNeeded()
        tableView.reloadData()
    }
    
    func applyFilter(selected: [Int?]){
        
        adScroll.showsHorizontalScrollIndicator = false
        scroll.addSubview(adScroll)
        
        tableTop?.constant = 50
        filterViews.forEach{$0.removeFromSuperview()}
        filterViews = []
        self.selected = []
        
        
        for (numb, select) in selected.enumerated(){
            var title: String
            if select != nil {
                if numb == 2{
                    title = signForFilter[select!]
                } else if numb == 1{
                    title = phasesForFilter[select!]
                } else {
                    title = select!.description + " Лунный День"
                }
                self.selected.append(select)
            } else {
                self.selected.append(nil)
                continue
            }
            
            let model = FilterViewModel(id: numb,
                                        title: title) {[weak self] id in
                guard let self = self else {return}
                self.selected[id] = nil
                self.applyFilter(selected: self.selected)
            }
            let filterView = FilterView(viewModel: FilterViewViewModel(model: model))
            
            filterView.translatesAutoresizingMaskIntoConstraints = false
            filterViews.append(filterView)
            adScroll.addSubview(filterView)
            filterView.centerYAnchor.constraint(equalTo: adScroll.centerYAnchor).isActive = true
            if filterViews.count > 1 {
                filterView.leadingAnchor.constraint(equalTo: filterViews[filterViews.count - 2].trailingAnchor, constant: 10).isActive = true
            } else {
                filterView.leadingAnchor.constraint(equalTo: adScroll.leadingAnchor, constant: 16).isActive = true
            }
            filterView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        }
        
        if filterViews.count > 0 {
            MainViewController.shared?.rightBarButtonTag = .reset
        } else {
            MainViewController.shared?.rightBarButtonTag = .choose
        }
        
        tableViewViewModel?.filter(filtered: self.selected, completion: {[weak self] result in
            guard let self = self,
                  let result = result else {return}
            self.tableView.viewModel = NotesTableViewViewModel(content: result)
            self.tableHeight?.constant = ((self.tableView.viewModel?.height) ?? 1.0) - 1
        })
        
    }
    
    func resetFilter(){
        selected = [nil, nil, nil]
        applyFilter(selected: selected)
    }
    
    @objc func didPressDelete(_ sender: UIBarButtonItem){
        if sender.title == "Удалить все" {
            
            for row in 0..<(tableView.viewModel?.count ?? 0) {
                tableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: .none)
            }
        }
        
        if let selectedRows = tableView.indexPathsForSelectedRows{
            for row in selectedRows.sorted(by: >) {
                tableView.tableView(tableView, commit: .delete, forRowAt: row)
            }
        }
        
        getData()
        setEditing(false, animated: true)
        MainViewController.shared?.toolbarItems?[1].title = "Удалить все"
    }
    
}

// MARK: - UISearchResultsUpdating
extension NotesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        searchController.searchBar.showsBookmarkButton = searchController.isActive ? false : true
        
        if !searchBarIsEmpty {
            guard let text = searchController.searchBar.text else {return}
            
            tableViewViewModel?.seacrh(text: text){[weak self] result in
                guard let self = self,
                      let result = result else {return}
                self.tableView.viewModel = NotesTableViewViewModel(content: result)
                self.tableHeight?.constant = ((self.tableView.viewModel?.height) ?? 1.0) - 1
            }
            
            
        } else {
            tableView.viewModel = tableViewViewModel
            tableHeight?.constant = ((tableViewViewModel?.height) ?? 1.0) - 1
        }
        
    }
    
}

//MARK: - UISearchBarDelegate
extension NotesViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        tableViewViewModel?.enabledFilters(completion: { result in
            let vc = FilterViewController(selected: selected, enablesFilters: result)
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true, completion: nil)
        })
        
        
    }
}

//MARK: - UIScrollViewDelegate
extension NotesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        MainViewController.shared?.navigationItem.hidesSearchBarWhenScrolling = true
    }
}
