//
//  FavoritesListViewController.swift
//  Sunny Day
//
//  Created by Heiner Bruß on 15.09.20.
//  Copyright © 2020 Heiner Bruß. All rights reserved.
//

import UIKit
import CoreData

//MARK:-Delegate Protocol

protocol FavoritesListViewControllerDelegate: class{
    func didSelectCity(city: Favorites)
}

//MARK:- FavoritesListController

class FavoritesListViewController: UITableViewController, UITextFieldDelegate {
    
    var savedFavorites = [Favorites]()
    let cellId = "cellId"
    weak var delegate: FavoritesListViewControllerDelegate?
    
    
    //MARK:- ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        view.backgroundColor = .white
        tableView.backgroundColor = .lightYellow
        tableView.separatorColor = .black
        tableView.tableFooterView = UIView()
        tableView.register(FavoritesCell.self, forCellReuseIdentifier: "cellId")
        savedFavorites = CoreDataManager.shared.fetchFavorites()
    }
    
    func setupNavBar() {
        navigationItem.title = "Sunny Day"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonPressed))
    }
    
    @objc func addButtonPressed() {
        let alertController = UIAlertController(title: "Add New Favorite", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter new city name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            if firstTextField.text != nil {
                guard let newCity = firstTextField.text else {return}
                CoreDataManager.shared.saveNewItem(newCity)
                
                self.updateTableView()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
