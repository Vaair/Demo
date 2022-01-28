//
//  NewNoteViewController.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 17.07.2021.
//

import UIKit

class NewNoteViewController: UIViewController {
    
    private var scroll: UIScrollView = {
        let scr = UIScrollView(frame: CGRect(x: 0,
                                             y: 80,
                                             width: UIScreen.main.bounds.width,
                                             height: UIScreen.main.bounds.height))
        scr.alwaysBounceVertical = true
        scr.showsVerticalScrollIndicator = false
        scr.isScrollEnabled = false
        scr.contentSize.height = UIScreen.main.bounds.height - 80
        return scr
    }()
    
    private let dateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateCreatelabel: UILabel = {
        let label = UILabel()
        label.text = "Создана"
        label.textAlignment = .center
        label.font = .description3
        label.textColor = Colors.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateUpdateLabel: UILabel = {
        let label = UILabel()
        label.text = "Отредактирована"
        label.textAlignment = .center
        label.font = .description3
        label.textColor = Colors.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = .moonDay
        textField.textColor = Colors.title1
        textField.attributedPlaceholder = NSAttributedString(string: "Здесь может быть заголовок", attributes: [NSAttributedString.Key.foregroundColor : Colors.placeholder])
        textField.placeholder = "Здесь может быть заголовок"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .description
        textView.text = "Начните свою запись или вставьте текст"
        textView.backgroundColor = .clear
        textView.textColor = Colors.placeholder
        textView.allowsEditingTextAttributes = true
        textView.isScrollEnabled = true
        textView.alwaysBounceVertical = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let gradient: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, Colors.main.cgColor]
        return layer
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var popUpVC: OptionViewController?
    
    weak var viewModel: NoteViewModelProtocol? {
        didSet{
            guard let viewModel = viewModel else {return}
            titleTextField.text = viewModel.title
            descriptionTextView.attributedText = viewModel.descriptionText
            indicatorsView.viewModel = viewModel
            dateCreatelabel.text! += " " + viewModel.dateCreate.toStringWithRelativeTime() + ", " + viewModel.dateCreate.toString(dateStyle: .none, timeStyle: .short)
            dateUpdateLabel.text! += " " + viewModel.dateUpdate.toStringWithRelativeTime() + ", " + viewModel.dateUpdate.toString(dateStyle: .none, timeStyle: .short)
        }
    }
    
    private let indicatorsView = IndicatorsView()
    private var isNew: Bool = false
    
    private var heightConstraints: NSLayoutConstraint?
    private let maxHeaderHeight: CGFloat = 84.0
    private var lastContentOffset: CGFloat = 0.0
    
    private var isFirst = true
    private var isChanched = false
    
    private var closeBarButtonItem = UIBarButtonItem()
    private var saveBarButtonItem = UIBarButtonItem()
    private var optionBarButtonItem = UIBarButtonItem()
    
    init(isNew: Bool) {
        self.isNew = isNew
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        descriptionTextView.pasteDelegate = self
        
        titleTextField.delegate = self
        
        UINavigationBar.appearance().tintColor = nil
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        view.backgroundColor = Colors.main
        
        view.addSubview(scroll)
        
        setupPlaceholders()
        
        setupUpView()
        setupBarButtonItems()
        arrangeTitleTextField()
        arrangeDescriptionTextField()
        arrangeGradientView()
        arrangeIndicatorsView()
        
        setupNavigationItems()
    }
    
    private func setupNavigationItems(){
        guard let titleTF = titleTextField.text else {return}
        
        if titleTF.isEmpty && descriptionTextView.textColor == Colors.placeholder {
            navigationItem.rightBarButtonItems?[0].tintColor = Colors.placeholder
            navigationItem.rightBarButtonItems?[0].isEnabled = false
        } else {
            navigationItem.rightBarButtonItems?[0].tintColor = Colors.blue
            navigationItem.rightBarButtonItems?[0].isEnabled = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradient.frame = gradientView.bounds
        gradientView.layer.insertSublayer(gradient, at: 0)
        
        indicatorsView.layer.cornerRadius = indicatorsView.frame.height / 2
        
        scroll.frame.origin.y = view.safeAreaInsets.top
    }
    
    private func setupPlaceholders(){
        if isNew, let astroModel = DataProvider.getDateInfo(date: DateProvider.getDateDifDay(days: 0)) {
            let attributed = [NSAttributedString.Key.font : UIFont.description,
                              NSAttributedString.Key.foregroundColor : Colors.placeholder] as [NSAttributedString.Key : Any]
            let model = NoteModel(noteID: viewModel?.model.noteID ?? "",
                                  recordID: viewModel?.recordID ?? "",
                                  title: "",
                                  noteDescription: NSAttributedString(string: "Начните свою запись или вставьте текст", attributes: attributed),
                                  dateCreate: Date(),
                                  dateUpdate: Date(),
                                  selectedColor: viewModel?.colorInt ?? 0,
                                  moonDay: astroModel.numberMoonDay,
                                  sign: astroModel.sign.rawValue,
                                  illumination: astroModel.phaseString)
            indicatorsView.viewModel = NoteViewModel(model: model, indexPath: nil)
            viewModel = indicatorsView.viewModel
        }
    }
    
    private func setupBarButtonItems(){
        
        closeBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(backAction))
        
        navigationItem.leftBarButtonItem = closeBarButtonItem
        navigationItem.leftBarButtonItem?.tintColor = Colors.blue
        
        saveBarButtonItem = UIBarButtonItem(title: "Готово",
                                            style: .plain,
                                            target: self,
                                            action: #selector(saveAction))
        
        optionBarButtonItem = UIBarButtonItem(image: UIImage(named: "option"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(optionAction))
        
        navigationItem.rightBarButtonItems = [optionBarButtonItem]
        navigationItem.rightBarButtonItems?[0].tintColor = Colors.placeholder
    }
    
    private func updateBarButtonItems(isEditing: Bool){
        if isEditing{
            navigationItem.rightBarButtonItems = [saveBarButtonItem, optionBarButtonItem]
            navigationItem.rightBarButtonItems?[0].tintColor = Colors.blue
        } else {
            navigationItem.rightBarButtonItems = [optionBarButtonItem]
        }
    }
    
    private func setupUpView(){
        scroll.addSubview(dateView)
        dateView.topAnchor.constraint(equalTo: scroll.topAnchor, constant: -20).isActive = true
        dateView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 25).isActive = true
        dateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        heightConstraints = dateView.heightAnchor.constraint(equalToConstant: 0.0)
        heightConstraints?.isActive = true
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        dateView.addSubview(stack)
        stack.centerXAnchor.constraint(equalTo: dateView.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: dateView.centerYAnchor).isActive = true
        
        stack.addArrangedSubview(dateCreatelabel)
        stack.addArrangedSubview(dateUpdateLabel)
    }
    
    private func arrangeTitleTextField(){
        scroll.addSubview(titleTextField)
        titleTextField.keyboardAppearance = UIKeyboardAppearance.dark
        titleTextField.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 10).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 25).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    private func arrangeDescriptionTextField(){
        let scrollView = UIScrollView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: UIScreen.main.bounds.width,
                                                    height: 44))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .systemGray5
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 2, height: 44)
        descriptionTextView.inputAccessoryView = scrollView
        scroll.addSubview(descriptionTextView)
        descriptionTextView.keyboardAppearance = UIKeyboardAppearance.dark
        descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 10).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 20).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func arrangeGradientView(){
        view.addSubview(gradientView)
        gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        gradientView.heightAnchor.constraint(equalToConstant: 137).isActive = true
    }
    
    private func arrangeIndicatorsView(){
        indicatorsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicatorsView)
        indicatorsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        indicatorsView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicatorsView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        indicatorsView.widthAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        descriptionTextView.resignFirstResponder()
    }
    
    @objc func updateTextView(notification: Notification){
        guard let userInfo = notification.userInfo as? [String: Any],
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            descriptionTextView.contentInset = UIEdgeInsets.zero
        } else {
            descriptionTextView.contentInset = UIEdgeInsets(top: 0,
                                                            left: 0,
                                                            bottom: keyboardFrame.height,
                                                            right: 0)
        }
        
        descriptionTextView.scrollIndicatorInsets = descriptionTextView.contentInset
        descriptionTextView.scrollRangeToVisible(descriptionTextView.selectedRange)
    }
    
    @objc func saveAction(){
        view.endEditing(true)
    }
    
    @objc func optionAction(){
        view.endEditing(true)
        UIView.animate(withDuration: 0.5) {
            self.heightConstraints?.constant = 0.0
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.5) {[weak self] in
            guard let self = self else {return}
            self.indicatorsView.transform.ty = -(UIScreen.main.bounds.height - self.view.safeAreaInsets.top - (UIScreen.main.bounds.height - self.indicatorsView.frame.minY) - 20)
            self.titleTextField.transform.ty = self.indicatorsView.frame.height + 20
            self.descriptionTextView.transform.ty = self.indicatorsView.frame.height + 20
        }
        guard let title = titleTextField.text,
              let desc = descriptionTextView.text else {return}
        isChanched = true
        popUpVC = OptionViewController(name: title.isEmpty ? desc : title,
                                       date: viewModel?.dateCreate ?? Date(),
                                       moodColor: viewModel?.colorInt,
                                       indexPath: viewModel?.indexPath,
                                       screenshot: descriptionTextView.textColor == Colors.placeholder ? nil : descriptionTextView.takeSnapshot(),
                                       closer: {[weak self] color in
                                        guard let self = self else {return}
                                        UIView.animate(withDuration: 0.5) {
                                            self.indicatorsView.transform.ty = .zero
                                            self.titleTextField.transform.ty = .zero
                                            self.descriptionTextView.transform.ty = .zero
                                            self.viewModel?.colorInt = color
                                            self.indicatorsView.changeColor(color: moodColors[color])
                                        }
                                       }, closeNewNoteViewController: {[weak self] in
                                        guard let self = self else {return}
                                        self.backAction()
                                       })
        popUpVC?.modalPresentationStyle = .overCurrentContext
        
        present(popUpVC!, animated: true, completion: nil)
    }
    
    @objc func backAction(){
        
        if descriptionTextView.textColor != Colors.placeholder &&
            isChanched &&
            descriptionTextView.text != ""{
            guard let infoViewModel = DataProvider.getDateInfo(date: isNew ? DateProvider.getDateDifDay(days: 0) : (viewModel?.dateCreate ?? Date())),
                  let title = titleTextField.text else {return}
            let noteModel = NoteModel(noteID: viewModel?.model.noteID ?? "",
                                      recordID: viewModel?.recordID ?? "",
                                      title: title.isEmpty || title == " " ? " " : title,
                                      noteDescription: descriptionTextView.attributedText,
                                      dateCreate: isNew ? Date() : (viewModel?.dateCreate ?? Date()),
                                      dateUpdate: Date(),
                                      selectedColor: popUpVC?.moodColor ?? 0,
                                      moonDay: infoViewModel.numberMoonDay,
                                      sign: infoViewModel.sign.rawValue,
                                      illumination: infoViewModel.phaseString)
            if isNew {
                CoreDataProvider.saveNote(note: noteModel)
                MainViewController.shared?.updateNotes()
            } else {
                CoreDataProvider.updateNote(note: noteModel, isNotUpdate: false)
                MainViewController.shared?.updateNotes()
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - UITextViewDelegate
extension NewNoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        updateBarButtonItems(isEditing: true)
        if textView.textColor == Colors.placeholder {
            textView.text = nil
            textView.textColor = Colors.title1
            if titleTextField.text!.isEmpty {
                titleTextField.text = " "
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updateBarButtonItems(isEditing: false)
        if textView.text.isEmpty{
            textView.text = "Начните свою запись или вставьте текст"
            textView.textColor = Colors.placeholder
            if titleTextField.text! == " " {
                titleTextField.text = ""
            }
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        if navigationItem.rightBarButtonItems!.count > 1{
            if textView.text.isEmpty{
                if let titleTF = titleTextField.text,
                   titleTF == " "{
                    navigationItem.rightBarButtonItems?[1].tintColor = Colors.placeholder
                    navigationItem.rightBarButtonItems?[1].isEnabled = false
                    isChanched = false
                } else {
                    navigationItem.rightBarButtonItems?[1].tintColor = Colors.blue
                    navigationItem.rightBarButtonItems?[1].isEnabled = true
                    isChanched = true
                }
            } else {
                navigationItem.rightBarButtonItems?[1].tintColor = Colors.blue
                navigationItem.rightBarButtonItems?[1].isEnabled = true
                isChanched = true
            }
        }
    }
}

//MARK: - UITextFieldDelegate
extension NewNoteViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        isChanched = true
        if let titleTF = titleTextField.text,
           titleTF.isEmpty{
            if navigationItem.rightBarButtonItems!.count > 1{
                if descriptionTextView.textColor == Colors.placeholder{
                    navigationItem.rightBarButtonItems?[1].tintColor = Colors.placeholder
                    navigationItem.rightBarButtonItems?[1].isEnabled = false
                    isChanched = false
                } else {
                    navigationItem.rightBarButtonItems?[1].tintColor = Colors.blue
                    navigationItem.rightBarButtonItems?[1].isEnabled = true
                }
            }
        } else {
            if titleTextField.text == " "{
                titleTextField.text = ""
            } else {
                if navigationItem.rightBarButtonItems!.count > 1{
                    navigationItem.rightBarButtonItems?[1].tintColor = Colors.blue
                    navigationItem.rightBarButtonItems?[1].isEnabled = true
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionTextView.becomeFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateBarButtonItems(isEditing: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateBarButtonItems(isEditing: false)
    }
    
    
    
}

//MARK: - ScrollViewDelegate
extension NewNoteViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isFirst{
            if (scrollView.contentOffset.y < 0){
                //Scrolling up, scrolled to top
                UIView.animate(withDuration: 0.5) {
                    self.heightConstraints?.constant = self.maxHeaderHeight
                    self.view.layoutIfNeeded()
                }
            } else if (scrollView.contentOffset.y > 0){
                //Scrolling down
                UIView.animate(withDuration: 0.5) {
                    self.heightConstraints?.constant = 0.0
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            isFirst.toggle()
        }
    }
}

//MARK: - UIGestureRecognizerDelegate
extension NewNoteViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

//MARK: - UITextPasteDelegate
extension NewNoteViewController: UITextPasteDelegate{
    func textPasteConfigurationSupporting(_ textPasteConfigurationSupporting: UITextPasteConfigurationSupporting, transform item: UITextPasteItem) {
        guard let pb = UIPasteboard.general.string else {return}
        let attr = NSAttributedString(string: pb, attributes: [.foregroundColor : UIColor.white,
                                                               .font            : UIFont.description])
        item.setResult(attributedString: attr)
    }
}
