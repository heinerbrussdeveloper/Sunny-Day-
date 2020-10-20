//
//  FavoritesCell.swift
//  Sunny Day
//
//  Created by Heiner Bruß on 16.09.20.
//  Copyright © 2020 Heiner Bruß. All rights reserved.
//

import UIKit


class FavoritesCell: UITableViewCell {
    
    //MARK:- Setup TableViewCell
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .niceYellow
        
        
        addSubview(cityNameLabel)
        cityNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        cityNameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cityNameLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cityNameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cityNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
