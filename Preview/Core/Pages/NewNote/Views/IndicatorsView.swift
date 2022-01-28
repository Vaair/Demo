//
//  IndicatorsView.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 11.08.2021.
//

import UIKit

class IndicatorsView: UIView{
    private let moonDayLabel: UILabel = {
        let label = UILabel()
        label.font = .description
        label.textColor = Colors.blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let illuminationImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var viewModel: NoteViewModelProtocol? {
        didSet{
            guard let viewModel = viewModel else {return}
            moonDayLabel.text = viewModel.moonDay?.description
            signImageView.image = viewModel.signImage
            illuminationImageView.image = viewModel.illuminationImage()
            colorView.backgroundColor = viewModel.color
        }
    }
    
    init() {
        super.init(frame: CGRect())
        
        backgroundColor = Colors.grayDark
        
        colorView.clipsToBounds = true
        
        signImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        signImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        illuminationImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        illuminationImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        colorView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        colorView.layer.cornerRadius = 11
        
        addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
        
        stackView.addArrangedSubview(moonDayLabel)
        stackView.addArrangedSubview(signImageView)
        stackView.addArrangedSubview(illuminationImageView)
        stackView.addArrangedSubview(colorView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeColor(color: UIColor){
        colorView.backgroundColor = color
    }
}
