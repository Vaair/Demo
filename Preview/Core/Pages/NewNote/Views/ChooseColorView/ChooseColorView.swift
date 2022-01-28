//
//  ChooseColorView.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 12.08.2021.
//

import UIKit

class ChooseColorView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.font = .nextButton
        label.textColor = Colors.title1
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
    
    private let slideView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.slideIndicator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var pointOrigin: CGPoint?
    
    private var closer: (Int)->() = {_ in}
    
    private var colorButtons = [UIButton]()
    
    private var selectedColor = 0
    
    init(selectedColor: Int?, closer: @escaping (Int)->()) {
        self.selectedColor = selectedColor ?? 0
        self.closer = closer
        super.init(frame: CGRect())
        
        setupSelf()
        
        setupSlideView()
        setupCloseButton()
        setupTitleLabel()
        setupColorView()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSelf(){
        pointOrigin = frame.origin
        backgroundColor = Colors.main
        layer.cornerRadius = 30
        clipsToBounds = true
    }
    
    private func setupSlideView(){
        slideView.layer.cornerRadius = 2.5
        slideView.clipsToBounds = true
        addSubview(slideView)
        slideView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        slideView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        slideView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        slideView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
    }
    
    private func setupCloseButton(){
        addSubview(closeButton)
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 36).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23).isActive = true
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
    }
    
    @objc func close(){
        closer(selectedColor)
        UIView.animate(withDuration: 0.3) {
            self.transform.ty = .zero
        } completion: { bool in
            if bool {
                self.removeFromSuperview()
            }
        }

    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        frame.origin = CGPoint(x: 0, y: (UIScreen.main.bounds.height - 375) + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: self)
            if dragVelocity.y >= 500 {
                closer(selectedColor)
                self.removeFromSuperview()
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.frame.origin = CGPoint(x: 0, y: (UIScreen.main.bounds.height - 375))
                }
            }
        }
    }
    
    private func setupTitleLabel(){
        addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        //        titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.6).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor).isActive = true
    }
    
    private func setupColorView(){
        let space = (UIScreen.main.bounds.width - 292) / 3
        let stackUp = UIStackView()
        stackUp.axis = .horizontal
        stackUp.spacing = space
        stackUp.distribution = .fillEqually
        
        for (i, color) in moodColors.enumerated() {
            let button = UIButton()
            colorButtons.append(button)
            button.tag = i
            if button.tag == selectedColor {
                button.setImage(UIImage(named: "done"), for: .normal)
            }
            button.layer.cornerRadius = 30
            button.clipsToBounds = true
            button.backgroundColor = color
            button.addTarget(self, action: #selector(chooseColor(_: )), for: .touchUpInside)
            addSubview(button)
            stackUp.addArrangedSubview(button)
            if i == 3{
                break
            }
        }
        
        let stackDown = UIStackView()
        stackDown.axis = .horizontal
        stackDown.spacing = space
        stackDown.distribution = .fillEqually
        
        for colorId in 4..<moodColors.count {
            let button = UIButton()
            colorButtons.append(button)
            button.tag = colorId
            if button.tag == selectedColor {
                button.setImage(UIImage(named: "done"), for: .normal)
            }
            button.layer.cornerRadius = 30
            button.clipsToBounds = true
            button.backgroundColor = moodColors[colorId]
            button.addTarget(self, action: #selector(chooseColor(_: )), for: .touchUpInside)
            addSubview(button)
            stackDown.addArrangedSubview(button)
        }
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = space
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        stack.addArrangedSubview(stackUp)
        stack.addArrangedSubview(stackDown)
        stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26).isActive = true
        stack.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 60).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 120.0 + space).isActive = true
    }
    
    @objc func chooseColor(_ sender: UIButton){
        selectedColor = sender.tag
        for button in colorButtons{
            if button.tag == selectedColor {
                button.setImage(UIImage(named: "done"), for: .normal)
            } else {
                button.setImage(nil, for: .normal)
            }
        }
    }
}
