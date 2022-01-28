//
//  NoteTableViewCell.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 15.08.2021.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    static let reuseId = "TableViewCell"
    
    let sign: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let phase: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let moonDayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .description3
        label.textColor = Colors.title1
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let colorView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 7.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .nextButton
        label.textColor = Colors.title1
        label.numberOfLines = 1
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .down
        label.numberOfLines = 1
        label.textColor = Colors.gray
        return label
    }()
    
    let startNoteLabel: UILabel = {
        let label = UILabel()
        label.font = .down
        label.numberOfLines = 1
        label.textColor = Colors.gray
        return label
    }()
    
    let rightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let stackViewVertical: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let stackDescriptionViewHorizontal: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .equalSpacing
        return stack
    }()
    
    let titleStackViewVertical: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var leading: NSLayoutConstraint?
    
    weak var viewModel: NoteViewModelProtocol? {
        didSet{
            guard let viewModel = viewModel else { return }
            let range = viewModel.descriptionText?.string.range(of: ".")
            var descrString = ""
            if viewModel.title == " " {
                if range != nil{
                    titleLabel.text = viewModel.descriptionText?.string[..<range!.lowerBound].description
                    let text = viewModel.descriptionText?.string[range!.lowerBound...].description ?? ""
                    
                    descrString = text.replacingCharacters(in: ...text.startIndex, with: "")
                } else {
                    titleLabel.text = viewModel.descriptionText?.string
                }
            } else {
                titleLabel.text = viewModel.title
                descrString = (viewModel.descriptionText?.string ?? "")
            }
            
            dateLabel.text = viewModel.dateCreate.toStringWithRelativeTime(strings: nil) + ", " + viewModel.dateCreate.toString(dateStyle: .none, timeStyle: .short) + "  " + descrString
            moonDayLabel.text = viewModel.moonDay?.description
            colorView.backgroundColor = viewModel.color
            sign.image = viewModel.signImage.withTintColor(.white)
            phase.image = viewModel.illuminationImage()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        
        setupRightPart()
        setupLeftPart()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLeftPart(){
        addSubview(titleStackViewVertical)
        leading = titleStackViewVertical.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        leading?.isActive = true
        titleStackViewVertical.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleStackViewVertical.trailingAnchor.constraint(equalTo: rightView.leadingAnchor, constant: -15).isActive = true
        
        titleStackViewVertical.addArrangedSubview(titleLabel)
        titleStackViewVertical.addArrangedSubview(dateLabel)
    }
    
    private func setupRightPart(){
        addSubview(rightView)
        rightView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rightView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        rightView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        rightView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        arrangeSign()
        arrangePhase()
        arrangeColorView()
        arrangeMoonDayLabel()
    }
    
    private func arrangeSign(){
        rightView.addSubview(sign)
        sign.trailingAnchor.constraint(equalTo: rightView.trailingAnchor).isActive = true
        sign.topAnchor.constraint(equalTo: rightView.topAnchor, constant: 2).isActive = true
        sign.widthAnchor.constraint(equalToConstant: 15).isActive = true
        sign.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    private func arrangePhase(){
        rightView.addSubview(phase)
        phase.leadingAnchor.constraint(equalTo: rightView.leadingAnchor).isActive = true
        phase.bottomAnchor.constraint(equalTo: rightView.bottomAnchor).isActive = true
        phase.widthAnchor.constraint(equalToConstant: 15).isActive = true
        phase.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    private func arrangeColorView(){
        rightView.addSubview(colorView)
        colorView.trailingAnchor.constraint(equalTo: rightView.trailingAnchor).isActive = true
        colorView.bottomAnchor.constraint(equalTo: rightView.bottomAnchor).isActive = true
        colorView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        colorView.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }

    private func arrangeMoonDayLabel(){
        rightView.addSubview(moonDayLabel)
        moonDayLabel.centerXAnchor.constraint(equalTo: phase.centerXAnchor).isActive = true
        moonDayLabel.topAnchor.constraint(equalTo: rightView.topAnchor).isActive = true
        moonDayLabel.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
}
