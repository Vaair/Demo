//
//  MainViewController.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 13.07.2021.
//

import UIKit
import CoreLocation

enum TypeRightBarButton {
    case none
    case reset
    case choose
    case done
}

class MainViewController: UITabBarController {
    
    private var newNoteVC: UIViewController = {
        let vc = UIViewController()
        return vc
    }()
    
    private var notesVC: NotesViewController = {
        let vc = NotesViewController()
        return vc
    }()
    
    var plusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.blue
        button.setImage(UIImage(named: "plus"), for: .normal)
        let color = Colors.blue.withAlphaComponent(0.5).cgColor
        button.layer.shadowColor = color
        button.layer.shadowOffset = CGSize(width: -1, height: 2)
        button.layer.shadowRadius = 15
        button.layer.shadowOpacity = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    static var shared: MainViewController?
    
    let locationManager = CLLocationManager()
    
    var rightBarButtonTag: TypeRightBarButton = .none {
        didSet{
            navigationItem.rightBarButtonItem = nil
            var rightBarButton: UIBarButtonItem?
            switch rightBarButtonTag {
            case .none:
                rightBarButton = nil
            case .reset:
                rightBarButton = UIBarButtonItem(title: "Сбросить",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(rightAction))
            case .choose:
                rightBarButton = notesVC.editButtonItem
                rightBarButton?.title = "Выбрать"
            case .done:
                print("done")
            }
            navigationItem.rightBarButtonItem = rightBarButton
        }
    }
    
    var selectedItem = 0
    
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        Self.shared = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UINavigationBar.appearance().tintColor = Colors.blue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocation()
        
        view.backgroundColor = Colors.background
        
        prepareTabBarItemsAndLinkWithVC()
        setupToolBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        prepareTabBar()
    }
    
    private func setupLocation(){
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
    }
    
    private func setupToolBar(){
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let deleteButton: UIBarButtonItem = UIBarButtonItem(title: "Удалить все",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didPressDelete(_:)))
        deleteButton.tintColor = Colors.blue
        navigationController?.toolbar.barStyle = .black
        toolbarItems = [flexible, deleteButton]
    }
    
    private func prepareTabBar(){
        let newTabBarHeight = defaultTabBarHeight + 16.0
        
        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight
        
        tabBar.frame = newFrame
        
        tabBar.backgroundColor = Colors.subView
        tabBar.layer.cornerRadius = tabBar.frame.height * 0.3
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        setupPlusButton()
    }
    
    private func setupPlusButton(){
        plusButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(plusAction)))
        
        plusButton.layer.cornerRadius = 28
        
        tabBar.addSubview(plusButton)
        plusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: tabBar.frame.height * 0.12).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 56).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    private func prepareTabBarItemsAndLinkWithVC(){
        let newNoteTabBarItem = UITabBarItem(title: nil, image: nil, tag: 0)
        
        newNoteVC.tabBarItem = newNoteTabBarItem
        newNoteVC.tabBarItem.isEnabled = false
        
        viewControllers = [notesVC, newNoteVC]
    }
    
    func deleteNote(indexPath: IndexPath){
        notesVC.tableView.tableView(notesVC.tableView, commit: .delete, forRowAt: indexPath)
        updateNotes()
    }
    
    func updateNotes(){
        notesVC.getData()
    }
    
    func applyFilter(selected: [Int?]){
        notesVC.applyFilter(selected: selected)
    }
    
    @objc func didPressDelete(_ sender: UIBarButtonItem){
        notesVC.didPressDelete(_: sender)
    }
    
    @objc func plusAction(){
        plusButton.animate()
        
        let vc = NewNoteViewController(isNew: true)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
    @objc func rightAction(){
        switch rightBarButtonTag {
        case .none:
            print("none")
        case .reset:
            notesVC.resetFilter()
        case .choose:
            notesVC.tableView.setEditing(!notesVC.tableView.isEditing, animated: true)
        case .done:
            print("done")
        }
    }
    
}

//MARK: - CLLocationManagerDelegate
extension MainViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {return}
        UDDatabase.latitute  = location.coordinate.latitude
        UDDatabase.longitude = location.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        UDDatabase.latitute  = 0.0
        UDDatabase.longitude = 50.28
    }
}
