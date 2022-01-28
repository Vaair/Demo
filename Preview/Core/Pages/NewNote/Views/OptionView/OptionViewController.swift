//
//  OptionViewController.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 12.08.2021.
//

import UIKit

class OptionViewController: UIViewController{
    var optionsView: OptionsView!
    var closer: (Int)->() = {_ in}
    var closeNewNoteViewController: ()->()
    var moodColor = 0
    var indexPath: IndexPath?
    var screenshot: UIImage?
    var name: String
    var date: Date
    
    var chooseColorView: ChooseColorView!
    let mainDarkView = UIView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        
        mainDarkView.backgroundColor = .black
        mainDarkView.alpha = 0.01
        view.addSubview(mainDarkView)
        UIView.animate(withDuration: 0.9) { [weak self] in
            self?.mainDarkView.alpha = 0.6
        }
        
        let darkView = UIView(frame: UIScreen.main.bounds)
        darkView.backgroundColor = .black.withAlphaComponent(0.5)
        optionsView = OptionsView(name: name,
                                  date: date,
                                  color: moodColors[moodColor],
                                  screenshot: screenshot,
                                  indexPath: indexPath,
                                  closer: {
                                    [weak self] in
                                    self?.closer(self?.moodColor ?? 0)
                                    self?.dismiss(animated: false, completion: nil)
                                  }, chooseCloser: { [weak self] in
                                    guard let self = self else {return}
                                    self.chooseColorView = ChooseColorView(selectedColor: self.moodColor){ color in
                                        self.moodColor = color
                                        self.optionsView.changeColor(color: moodColors[color])
                                        darkView.removeFromSuperview()
                                    }
                                    self.chooseColorView.translatesAutoresizingMaskIntoConstraints = false
                                    
                                    self.view.addSubview(darkView)
                                    darkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.chooseColorViewClose)))
                                    
                                    self.view.addSubview(self.chooseColorView)
                                    self.chooseColorView.heightAnchor.constraint(equalToConstant: 375).isActive = true
                                    self.chooseColorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 375).isActive = true
                                    self.chooseColorView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
                                    self.chooseColorView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
                                    
                                    UIView.animate(withDuration: 0.5) {
                                        self.chooseColorView.transform.ty = -375
                                    }
                                  }, closeNewNoteViewController: {[weak self] in
                                    self?.dismiss(animated: false, completion: nil)
                                    self?.closeNewNoteViewController()
                                  })
        
        optionsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(optionsView)
        let bottom = optionsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        bottom.isActive = true
        optionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        optionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        optionsView.heightAnchor.constraint(equalToConstant: 232).isActive = true
        
    }
    
    @objc func chooseColorViewClose(){
        chooseColorView.close()
    }
    
    init(name: String,
         date: Date,
         moodColor: Int?,
         indexPath: IndexPath?,
         screenshot: UIImage?,
         closer: @escaping (Int)->(),
         closeNewNoteViewController: @escaping ()->()){
        self.closer = closer
        self.screenshot = screenshot
        self.moodColor = moodColor ?? 0
        self.indexPath = indexPath
        self.name = name
        self.date = date
        self.closeNewNoteViewController = closeNewNoteViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
