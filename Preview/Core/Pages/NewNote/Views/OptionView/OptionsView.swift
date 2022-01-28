//
//  OptionsView.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 12.08.2021.
//

import UIKit

class OptionsView: UIView {
    
    private var colorActivity: ActivityView!
    
    private let miniNote: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = Colors.grayDark
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let noteNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = .nextButton
        label.textColor = Colors.title1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noteDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = .down
        label.textColor = Colors.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.backgroundColor = Colors.dark
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var closer: ()->() = {}
    private var chooseCloser: ()->() = {}
    private var closeNewNoteViewController: ()->()
    private var color = UIColor()
    private var indexPath: IndexPath?
    
    init(name: String, date: Date, color: UIColor, screenshot: UIImage?, indexPath: IndexPath?, closer: @escaping ()->(), chooseCloser: @escaping ()->(), closeNewNoteViewController: @escaping ()->()) {
        self.indexPath = indexPath
        self.closer = closer
        self.chooseCloser = chooseCloser
        self.color = color
        self.closeNewNoteViewController = closeNewNoteViewController
        super.init(frame: CGRect())
        
        backgroundColor = Colors.main
        
        noteNameLabel.text = name
        noteDateLabel.text = date.toString(style: .ordinalDay) + " " + date.toString(style: .month) + ", " + date.toString(dateStyle: .none, timeStyle: .short)
        miniNote.image = screenshot
        setupColorView()
        setupStackView()
        setupCloseButton()
        createActivity()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupColorView(){
        addSubview(miniNote)
        miniNote.widthAnchor.constraint(equalToConstant: 35).isActive = true
        miniNote.heightAnchor.constraint(equalToConstant: 35).isActive = true
        miniNote.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        miniNote.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        miniNote.layer.cornerRadius = 4
    }
    
    private func setupStackView(){
        addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: miniNote.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: miniNote.trailingAnchor, constant: 15).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
        
        stackView.addArrangedSubview(noteNameLabel)
        stackView.addArrangedSubview(noteDateLabel)
    }
    
    private func setupCloseButton(){
        addSubview(closeButton)
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: miniNote.centerYAnchor).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23).isActive = true
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
    }
    
    @objc func close(){
        closer()
    }
    
    private func createActivity(){
        colorActivity = ActivityView(title: "Цвет",
                                         color: color,
                                         isDelete: false)
        colorActivity.translatesAutoresizingMaskIntoConstraints = false
        addSubview(colorActivity)
        colorActivity.heightAnchor.constraint(equalToConstant: 44).isActive = true
        colorActivity.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 34).isActive = true
        colorActivity.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        colorActivity.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25).isActive = true
        colorActivity.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseColor)))
        
        let deleteActivity = ActivityView(title: "Удалить заметку",
                                         color: nil,
                                         isDelete: true)
        deleteActivity.translatesAutoresizingMaskIntoConstraints = false
        addSubview(deleteActivity)
        deleteActivity.heightAnchor.constraint(equalToConstant: 44).isActive = true
        deleteActivity.topAnchor.constraint(equalTo: colorActivity.bottomAnchor).isActive = true
        deleteActivity.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        deleteActivity.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25).isActive = true
        deleteActivity.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteAction)))
    }
    
    func changeColor(color: UIColor){
        colorActivity.changeColor(color: color)  
    }
    
    @objc func chooseColor(){
        chooseCloser()
    }
    
    @objc func deleteAction(){
        if indexPath == nil {
            closeNewNoteViewController()
        } else {
            MainViewController.shared?.deleteNote(indexPath: indexPath!)
            closeNewNoteViewController()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x: 0, y: 65))
        aPath.addLine(to: CGPoint(x:UIScreen.main.bounds.maxX, y:65))
        aPath.close()
        
        Colors.grayDark.set()
        aPath.stroke()
        aPath.fill()
        
        layer.cornerRadius = 35
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        clipsToBounds = true
    }
}
