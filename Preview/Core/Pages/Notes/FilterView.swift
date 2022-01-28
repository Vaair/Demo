//
//  FilterView.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 28.08.2021.
//

import UIKit

struct FilterViewModel{
    var id: Int
    var title: String
    var action: (Int)->()
}

protocol FilterViewViewModelProtocol{
    var id: Int {get}
    var title: String {get}
    var action: (Int)->() {get}
}

class FilterViewViewModel: FilterViewViewModelProtocol{
    var model: FilterViewModel
    
    var id: Int {
        model.id
    }
    
    var title: String {
        model.title
    }
    
    var action: (Int) -> () {
        model.action
    }
    
    init(model: FilterViewModel){
        self.model = model
    }
}

class FilterView: UIView{
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.font = .description3
        label.textColor = Colors.slideIndicator
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close")?.withTintColor(.gray), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var viewModel: FilterViewViewModelProtocol {
        didSet{
            titleLabel.text = viewModel.title
            closeButton.tag = viewModel.id
        }
    }
    
    init(viewModel: FilterViewViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(frame: CGRect())
        
        setupSelf()
        
        closeButton.addTarget(self, action: #selector(closeButtonAction(_:)), for: .touchUpInside)
        
        arrangeTitleLabel()
        arrangeCloseButton()
    }
    
    private func setupSelf(){
        backgroundColor = Colors.subView
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    private func arrangeTitleLabel(){
        addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
    }
    
    private func arrangeCloseButton(){
        addSubview(closeButton)
        closeButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10).isActive = true
        
        trailingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 10).isActive = true
    }
    
    @objc func closeButtonAction(_ sender: UIButton){
        viewModel.action(sender.tag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
