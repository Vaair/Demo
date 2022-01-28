//
//  ActivityView.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 12.08.2021.
//

import UIKit

class ActivityView: UIView {
    private var isDelete = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .description3
        label.textColor = Colors.title1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "trash")?.withTintColor(.white), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(title: String, color: UIColor?, isDelete: Bool) {
        self.isDelete = isDelete
        super.init(frame: CGRect())
        titleLabel.text = title
        colorView.backgroundColor = color
        
        backgroundColor = Colors.dark
        layer.cornerRadius = 10
        if isDelete{
            layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }else {
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        clipsToBounds = true
        
        setupRight()
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if !isDelete{
            let aPath = UIBezierPath()
            
            aPath.move(to: CGPoint(x: 0, y: 44))
            aPath.addLine(to: CGPoint(x: frame.maxX, y: 44))
            aPath.close()
            
            Colors.grayDark.set()
            aPath.stroke()
            aPath.fill()
        }
    }
    private func setupRight(){
        if isDelete{
            addSubview(deleteButton)
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23).isActive = true
            deleteButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        } else {
            addSubview(colorView)
            colorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            colorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23).isActive = true
            colorView.widthAnchor.constraint(equalToConstant: 22).isActive = true
            colorView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        }
        
    }
    
    private func setupTitleLabel(){
        addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23).isActive = true
        if isDelete{
            titleLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -15).isActive = true
        } else {
            titleLabel.trailingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: -15).isActive = true
        }
        
    }
    
    func changeColor(color: UIColor){
        colorView.backgroundColor = color
    }
}
