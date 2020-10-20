//
//  ExtensionFavoritesVC+tableView.swift
//  Sunny Day
//
//  Created by Heiner Bruß on 17.09.20.
//  Copyright © 2020 Heiner Bruß. All rights reserved.
//

import UIKit

extension FavoritesListViewController {
    
    //MARK:- TABLE VIEW METHODS
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedFavorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FavoritesCell
        let favItems = savedFavorites[indexPath.row]
        cell.cityNameLabel.text = favItems.cityName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .newOrange
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.savedFavorites[indexPath.item]
        delegate?.didSelectCity(city: object)
        navigationController?.popViewController(animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion)  in
            let favItem = self.savedFavorites[indexPath.row]
            print("Attempting to delete selected favorite:", favItem.cityName ?? "")
            
            self.savedFavorites.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            CoreDataManager.shared.delete(object: favItem)
            self.updateTableView()
            
        }
        deleteAction.backgroundColor = .lightRed
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    
     func updateTableView() {
        savedFavorites = CoreDataManager.shared.fetchFavorites()
        tableView.reloadData()
    }
    
}
