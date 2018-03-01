//
//  DataAccessor.swift
//  TestApp
//
//  Created by Faraz Habib on 28/02/18.
//  Copyright © 2018 Faraz Habib. All rights reserved.
//

import Foundation

import CoreData
import UIKit

class DatabaseAccessor {
    
    var appDelegate:AppDelegate!
    var managedObjectContext:NSManagedObjectContext!
    
    init() {
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.managedObjectContext = self.appDelegate.persistentContainer.viewContext
    }
    
    func fetchArticles(offset:Int) -> [Article]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = 5
        do {
            if let results = try managedObjectContext.fetch(fetchRequest) as? [Article], results.count > 0 {
                return results
            }
        } catch {
            print ("There was an error")
        }
        return nil
    }
    
    func deleteArticles() {
        var persistantCoordinator:NSPersistentStoreCoordinator!
        persistantCoordinator = appDelegate.persistentContainer.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistantCoordinator.execute(deleteRequest, with: managedObjectContext)
        } catch {
            print ("There was an error")
        }
    }
    
}

