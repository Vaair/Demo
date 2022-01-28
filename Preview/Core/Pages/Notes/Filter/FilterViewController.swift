//
//  FilterViewController.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 25.08.2021.
//

import UIKit

let phasesForFilter = ["Новолуние", "1-я Фаза", "1-я Четв.", "2-я Фаза", "Полнолун.", "3-я Фаза", "Посл. Четв.", "4-я Фаза"]
let signForFilter = ["Овен", "Телец", "Близнецы", "Рак", "Лев", "Дева", "Весы", "Скорпион", "Стрелец", "Козерог", "Водолей", "Рыбы"]

class FilterViewController: UIViewController {
    
    private let foundationView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.background
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let slideView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.slideIndicator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.backgroundColor = Colors.dark
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Фильтры"
        label.font = .nextButton
        label.textColor = Colors.title1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сбросить", for: .normal)
        button.setTitleColor(Colors.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.nextStyle(title: "Применить Фильтр")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let moonDayLabel: UILabel = {
        let label = UILabel()
        label.text = "Лунный день"
        label.font = .description4
        label.textColor = Colors.title1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moonPhaseLabel: UILabel = {
        let label = UILabel()
        label.text = "Фаза Луны"
        label.font = .description4
        label.textColor = Colors.title1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moonSignLabel: UILabel = {
        let label = UILabel()
        label.text = "Луна в знаке"
        label.font = .description4
        label.textColor = Colors.title1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moonDayView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.subView
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        view.layer.borderColor = Colors.placeholder.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let changedMoonDayLabel: UILabel = {
        let label = UILabel()
        label.text = "1 Лунный день"
        label.font = .description
        label.textColor = Colors.title1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowDownImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "chevronDown")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pickerView = UIPickerView()
    private let upView = UIView()
    
    private let darkView = UIView(frame: UIScreen.main.bounds)
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var phaseViews = [FilterButton]()
    
    var signViews = [FilterButton]()
    
    var selectedPhase: Int?
    var selectedSign: Int?
    var didSelectedElement: Int? = nil {
        didSet{
            changedMoonDayLabel.text = (didSelectedElement?.description ?? "1") + " Лунный День"
        }
    }
    var selectedElement: Int?
    
    var minY: CGFloat = 10
    
    var height: NSLayoutConstraint?
    var selected: [Int?]
    var enablesFilters: [Set<Int>?]
    var arrayMoonday = [Int]()
    
    init(selected: [Int?], enablesFilters: [Set<Int>?]) {
        self.selected = selected
        self.enablesFilters = enablesFilters
        self.arrayMoonday =  [Int](enablesFilters[0]!)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        foundationView.addGestureRecognizer(panGesture)
        
        darkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closePicker)))
        
        if selected[0] != nil{
            didSelectedElement = selected[0]!
        } else {
            var array = [Int](enablesFilters[0]!)
            array.sort()
            didSelectedElement = array.first
            pickerView.selectRow(array.first ?? 1, inComponent: 0, animated: true)
        }
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        setupVisualBlurEffectView()
        
        arrangeFoundationView()
        setupSlideView()
        setupCloseButton()
        setupTitleLabel()
        setupResetButton()
        setupNextButton()
        
        arrangeMoonDayLabel()
        arrangeMoonDayView()
        arrangeArrow()
        arrangeChangedMoonDayLabel()
        
        arrangeMoonPhaseLabel()
        setupPhaseViews()
        
        arrangeMoonSignLabel()
        setupSignViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.visualEffectView.alpha = 0
        UIView.animate(withDuration: 0.7) {
            self.visualEffectView.alpha = 0.96
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        height?.constant = (signViews.last?.frame.maxY ?? 0) + 20 + nextButton.frame.height + (view.frame.height * 0.07)
        
    }
    
    private func setupVisualBlurEffectView() {
        visualEffectView.frame = UIScreen.main.bounds
        
        view.addSubview(visualEffectView)
        
    }
    
    private func arrangeFoundationView(){
        view.addSubview(foundationView)
        foundationView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        foundationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        foundationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        height = foundationView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)
        height?.isActive = true
    }
    
    private func setupSlideView(){
        slideView.layer.cornerRadius = 2.5
        slideView.clipsToBounds = true
        foundationView.addSubview(slideView)
        slideView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        slideView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        slideView.centerXAnchor.constraint(equalTo: foundationView.centerXAnchor).isActive = true
        slideView.topAnchor.constraint(equalTo: foundationView.topAnchor, constant: 15).isActive = true
    }
    
    private func setupCloseButton(){
        foundationView.addSubview(closeButton)
        closeButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        closeButton.topAnchor.constraint(equalTo: foundationView.topAnchor, constant: 36).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: foundationView.leadingAnchor, constant: 25).isActive = true
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
    }
    
    private func setupTitleLabel(){
        foundationView.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: foundationView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor).isActive = true
    }
    
    private func setupResetButton(){
        resetButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reset)))
        foundationView.addSubview(resetButton)
        resetButton.trailingAnchor.constraint(equalTo: foundationView.trailingAnchor, constant: -25).isActive = true
        resetButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor).isActive = true
    }
    
    private func setupNextButton(){
        nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(apply)))
        foundationView.addSubview(nextButton)
        let downSpace = NSLayoutConstraint(item: nextButton,
                                       attribute: .bottom,
                                       relatedBy: .equal,
                                       toItem: view.safeAreaLayoutGuide,
                                       attribute: .bottom,
                                       multiplier: 1,
                                       constant: -(view.frame.width * 0.05))
        downSpace.isActive = true
        
        let left = NSLayoutConstraint(item: nextButton,
                                       attribute: .leading,
                                       relatedBy: .equal,
                                       toItem: view.safeAreaLayoutGuide,
                                       attribute: .leading,
                                       multiplier: 1,
                                       constant: view.frame.width * 0.05)
        left.isActive = true
        
        let right = NSLayoutConstraint(item: nextButton,
                                       attribute: .trailing,
                                       relatedBy: .equal,
                                       toItem: view.safeAreaLayoutGuide,
                                       attribute: .trailing,
                                       multiplier: 1,
                                       constant: -(view.frame.width * 0.05))
        
        right.isActive = true
        
        let height = NSLayoutConstraint(item: nextButton,
                                       attribute: .height,
                                       relatedBy: .equal,
                                       toItem: nil,
                                       attribute: .height,
                                       multiplier: 1,
                                       constant: 60)
        height.isActive = true
    }
    
    private func arrangeMoonDayLabel(){
        
        foundationView.addSubview(moonDayLabel)
        moonDayLabel.leadingAnchor.constraint(equalTo: foundationView.leadingAnchor, constant: 25).isActive = true
        moonDayLabel.trailingAnchor.constraint(equalTo: foundationView.trailingAnchor, constant: -25).isActive = true
        moonDayLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20).isActive = true
    }
    
    private func arrangeMoonDayView(){
        moonDayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseMoonDay)))
        foundationView.addSubview(moonDayView)
        moonDayView.leadingAnchor.constraint(equalTo: foundationView.leadingAnchor, constant: 25).isActive = true
        moonDayView.trailingAnchor.constraint(equalTo: foundationView.trailingAnchor, constant: -25).isActive = true
        moonDayView.topAnchor.constraint(equalTo: moonDayLabel.bottomAnchor, constant: 10).isActive = true
        moonDayView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.06).isActive = true
    }
    
    private func arrangeArrow(){
        moonDayView.addSubview(arrowDownImageView)
        arrowDownImageView.trailingAnchor.constraint(equalTo: moonDayView.trailingAnchor, constant: -10).isActive = true
        arrowDownImageView.centerYAnchor.constraint(equalTo: moonDayView.centerYAnchor).isActive = true
        arrowDownImageView.heightAnchor.constraint(equalToConstant: 27).isActive = true
        arrowDownImageView.widthAnchor.constraint(equalToConstant: 27).isActive = true
    }
    
    private func arrangeChangedMoonDayLabel(){
        moonDayView.addSubview(changedMoonDayLabel)
        changedMoonDayLabel.leadingAnchor.constraint(equalTo: moonDayView.leadingAnchor, constant: 20).isActive = true
        changedMoonDayLabel.trailingAnchor.constraint(equalTo: arrowDownImageView.leadingAnchor, constant: -10).isActive = true
        changedMoonDayLabel.centerYAnchor.constraint(equalTo: moonDayView.centerYAnchor).isActive = true
    }
    
    private func arrangeMoonPhaseLabel(){
        foundationView.addSubview(moonPhaseLabel)
        moonPhaseLabel.leadingAnchor.constraint(equalTo: foundationView.leadingAnchor, constant: 25).isActive = true
        moonPhaseLabel.trailingAnchor.constraint(equalTo: foundationView.trailingAnchor, constant: -25).isActive = true
        moonPhaseLabel.topAnchor.constraint(equalTo: moonDayView.bottomAnchor, constant: 20).isActive = true
    }
    
    private func setupPhaseViews(){
        var minX: CGFloat = 25
        
        var array = [Int](enablesFilters[1]!)
        array.sort()
        
        for (numb, phase) in phasesForFilter.enumerated(){
            let phaseButton = FilterButton(title: phase)
            phaseButton.translatesAutoresizingMaskIntoConstraints = false
            phaseViews.append(phaseButton)
            phaseButton.tag = numb
            phaseButton.addTarget(self, action: #selector(choosePhase), for: .touchUpInside)
            foundationView.addSubview(phaseButton)
            if selected[1] != nil, selected[1] == numb{
                phaseButton.isChoosed = true
                selectedPhase = numb
            }
            if !array.contains(numb) {
                phaseButton.isEnabled = false
                phaseButton.setUnable()
            }
            phaseButton.leadingAnchor.constraint(equalTo: foundationView.leadingAnchor, constant: minX).isActive = true
            phaseButton.topAnchor.constraint(equalTo: moonPhaseLabel.bottomAnchor, constant: minY).isActive = true
            phaseButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.05).isActive = true
            phaseButton.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 60) / 3).isActive = true
            
            if (numb + 1) % 3 == 0{
                minX = 25
                minY += UIScreen.main.bounds.height * 0.05 + 5
            } else {
                minX += (UIScreen.main.bounds.width - 60) / 3 + 5
            }
        }
        minY += UIScreen.main.bounds.height * 0.04 + 20
    }
    
    private func arrangeMoonSignLabel(){
        foundationView.addSubview(moonSignLabel)
        moonSignLabel.leadingAnchor.constraint(equalTo: foundationView.leadingAnchor, constant: 25).isActive = true
        moonSignLabel.trailingAnchor.constraint(equalTo: foundationView.trailingAnchor, constant: -25).isActive = true
        moonSignLabel.topAnchor.constraint(equalTo: moonPhaseLabel.bottomAnchor, constant: minY).isActive = true
    }
    
    private func setupSignViews(){
        var minX: CGFloat = 25
        minY = 10
        
        var array = [Int](enablesFilters[2]!)
        array.sort()
        
        for (numb, sign) in signForFilter.enumerated(){
            let signButton = FilterButton(title: sign)
            signButton.translatesAutoresizingMaskIntoConstraints = false
            signViews.append(signButton)
            signButton.tag = numb
            signButton.addTarget(self, action: #selector(chooseSign), for: .touchUpInside)
            foundationView.addSubview(signButton)
            if selected[2] != nil, selected[2] == numb {
                signButton.isChoosed = true
                selectedSign = numb
            }
            if !array.contains(numb) {
                signButton.isEnabled = false
                signButton.setUnable()
            }
            signButton.leadingAnchor.constraint(equalTo: foundationView.leadingAnchor, constant: minX).isActive = true
            signButton.topAnchor.constraint(equalTo: moonSignLabel.bottomAnchor, constant: minY).isActive = true
            signButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.05).isActive = true
            signButton.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 60) / 3).isActive = true
            
            if (numb + 1) % 3 == 0{
                minX = 25
                minY += UIScreen.main.bounds.height * 0.05 + 5
            } else {
                minX += (UIScreen.main.bounds.width - 60) / 3 + 5
            }
        }
    }
    
    @objc func choosePhase(_ sender: UIButton){
        if selectedPhase != nil,
           selectedPhase != sender.tag{
            phaseViews[selectedPhase!].isChoosed = false
        }
        
        phaseViews[sender.tag].isChoosed.toggle()
        
        selectedPhase = phaseViews[sender.tag].isChoosed ? sender.tag : nil
    }
    
    @objc func chooseSign(_ sender: UIButton){
        if selectedSign != nil,
           selectedSign != sender.tag{
            signViews[selectedSign!].isChoosed = false
        }
        
        signViews[sender.tag].isChoosed.toggle()
        
        selectedSign = signViews[sender.tag].isChoosed ? sender.tag : nil
    }
    
    @objc func chooseMoonDay(){
        if selected[0] != nil {
            pickerView.selectRow(selected[0]! - 1, inComponent: 0, animated: true)
        } else {
            pickerView.selectRow((didSelectedElement ?? 1) - 1, inComponent: 0, animated: true)
        }
        
        
        darkView.backgroundColor = .black
        darkView.alpha = 0
        view.addSubview(darkView)
        
        pickerView.backgroundColor = Colors.subView
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerView)
        pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 300).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        
        upView.backgroundColor = Colors.subView
        view.addSubview(upView)
        upView.translatesAutoresizingMaskIntoConstraints = false
        upView.bottomAnchor.constraint(equalTo: pickerView.topAnchor, constant: 50).isActive = true
        upView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        upView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        upView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let cancelButton = UIButton()
        cancelButton.setTitle("Отмена", for: .normal)
        cancelButton.setTitleColor(Colors.blue, for: .normal)
        cancelButton.addTarget(self, action: #selector(closePicker), for: .touchUpInside)
        upView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: upView.topAnchor, constant: 10).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: upView.leadingAnchor, constant: 25).isActive = true
        
        let doneButton = UIButton()
        doneButton.setTitle("Готово", for: .normal)
        doneButton.setTitleColor(Colors.blue, for: .normal)
        doneButton.addTarget(self, action: #selector(donePicker), for: .touchUpInside)
        upView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.topAnchor.constraint(equalTo: upView.topAnchor, constant: 10).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: upView.trailingAnchor, constant: -25).isActive = true
        
        UIView.animate(withDuration: 0.5) {
            self.pickerView.transform.ty -= 300
            self.upView.transform.ty -= 350
            self.darkView.alpha = 0.7
        }
    }
    
    @objc func closePicker(){
        UIView.animate(withDuration: 0.5) {
            self.pickerView.transform.ty += 300
            self.upView.transform.ty += 350
            self.darkView.alpha = 0
        } completion: { bool in
            if bool{
                self.selectedElement = nil
                self.darkView.removeFromSuperview()
                self.pickerView.removeFromSuperview()
                self.upView.removeFromSuperview()
            }
        }
    }
    
    @objc func donePicker(){
        didSelectedElement = selectedElement
        UIView.animate(withDuration: 0.5) {
            self.pickerView.transform.ty += 300
            self.upView.transform.ty += 350
            self.darkView.alpha = 0
        } completion: { bool in
            if bool{
                self.darkView.removeFromSuperview()
                self.pickerView.removeFromSuperview()
                self.upView.removeFromSuperview()
            }
        }
    }
    
    @objc func apply(){
        if selected[0] != nil && selectedElement == nil{
            selectedElement = selected[0]
        }
        MainViewController.shared?.applyFilter(selected: [selectedElement, selectedPhase, selectedSign])
        close()
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: foundationView)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        foundationView.frame.origin = CGPoint(x: 0, y: (UIScreen.main.bounds.height - (height?.constant ?? 0)) + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: foundationView)
            if dragVelocity.y >= 500 {
                self.close()
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.foundationView.frame.origin = CGPoint(x: 0, y: (UIScreen.main.bounds.height - (self.height?.constant ?? 0)))
                }
            }
        }
    }
    
    @objc func close(){
        self.foundationView.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.alpha = 0
        } completion: { bool in
            if bool{
                self.dismiss(animated: false)
            }
        }
        
    }
    
    @objc func reset(){
        if selectedPhase != nil {
            phaseViews[selectedPhase!].isChoosed = false
            selectedPhase = nil
        }
        if selectedSign != nil {
            signViews[selectedSign!].isChoosed = false
            selectedSign = nil
        }
        
        if didSelectedElement != nil {
            selectedElement = nil
            didSelectedElement = nil
            selected[0] = nil
        }
    }
    
}

extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { //количество барабанов
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { //количество элементов, доступное в picker view
        return enablesFilters[0]?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { //отображает на строке выбранные значения
        
        arrayMoonday.sort()
        return (arrayMoonday[row]).description + " Лунный День"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { //что делать с выбранным элементом
        selectedElement = arrayMoonday[row] //row + 1
        
    }
}
