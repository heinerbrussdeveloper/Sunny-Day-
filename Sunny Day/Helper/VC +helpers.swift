//
//  VC +helpers.swift
//  Sunny Day
//
//  Created by Heiner Bruß on 16.09.20.
//  Copyright © 2020 Heiner Bruß. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func setupOrangeBackgroundView(height: CGFloat) -> UIView{
        let orangeBackgroundView = UIView()
        orangeBackgroundView.backgroundColor = .newOrange
        orangeBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(orangeBackgroundView)
        
        orangeBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        orangeBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        orangeBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        orangeBackgroundView.heightAnchor.constraint(equalToConstant: height).isActive = true
        return orangeBackgroundView
        
    }
}
