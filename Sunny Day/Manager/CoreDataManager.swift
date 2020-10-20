//
//  CoreDataManager.swift
//  Sunny Day
//
//  Created by Heiner Bruß on 15.09.20.
//  Copyright © 2020 Heiner Bruß. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject, NSFetchedResultsControllerDelegate{
    
    static let shared = CoreDataManager()
    
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SunnyDayModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of Store failed \(error)")
            }
        }
        return container
    }()
    
    //MARK:- Fetch Favorites
    
    func fetchFavorites() -> [Favorites] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Favorites>(entityName: "Favorites")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "cityName", ascending: true)
        ]
        
        do{
            let favorites = try context.fetch(fetchRequest)
            
            return favorites
        } catch let error {
            print("Could not fetch data: \(error)")
            return []
        }
    }
    
    //MARK:- SAVE
    
    func saveNewItem(_ itemToAdd: String) {
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: context)!
        let item = NSManagedObject(entity: entity, insertInto: context)
        item.setValue(itemToAdd, forKey: "cityName")
        
        do {
            try context.save()
        } catch let error {
            print("Saving new TableView Item failed", error)
        }
    }
    
    //MARK:- Delete
    
    func delete(object: Favorites) {
        let context = persistentContainer.viewContext
        context.delete(object)
        do {
            try context.save()
        } catch let saveErr {
            print("Failed to delete company", saveErr)
        }
    }
}
