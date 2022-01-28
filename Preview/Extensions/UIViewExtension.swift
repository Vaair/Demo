//
//  UIViewExtension.swift
//  Moon Note
//
//  Created by Лера Тарасенко on 23.08.2021.
//

import UIKit

extension UIView {
    func takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: UIScreen.main.bounds.width,
                                                      height: UIScreen.main.bounds.width * 1.3),
                                               false,
                                               UIScreen.main.scale)
        drawHierarchy(in: self.frame, afterScreenUpdates: true)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {return UIImage()}
        UIGraphicsEndImageContext()
        return image
    }
    
    func animate(){
        UIView.animate(withDuration: 0) {
            self.alpha = 0.5
        } completion: {_ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {[weak self] in
                self?.alpha = 1
            }
        }
    }
}
