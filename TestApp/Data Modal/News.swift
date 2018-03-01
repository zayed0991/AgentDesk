//
//  News.swift
//  TestApp
//
//  Created by Faraz Habib on 28/02/18.
//  Copyright © 2018 Faraz Habib. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct News {
    
    var status = false
    
    init() {
        
    }
    
    init(responseData:Data) {
        do {
            guard let parsedData = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String:Any] else {
                print("error trying to convert data to JSON")
                return
            }

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            var managedObjectContext:NSManagedObjectContext!
            managedObjectContext = appDelegate.persistentContainer.viewContext
            
            if let list = parsedData["articles"] as? [[String:Any]] {
                status = true
                for article in list {
                    let articleModal = ArticleDetails(params: article)
                    
                    // Saving article to core data
                    let article = NSEntityDescription.insertNewObject(forEntityName: "Article", into: managedObjectContext) as! Article
                    article.setupManagedObject(articleDetails: articleModal)
                    
                    do {
                        try managedObjectContext.save()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
        } catch _ {
            print("error trying to convert data to JSON")
        }
    }
    
}

class ArticleDetails {
    
    private var sourceId: String?
    private var sourceName: String?
    private var author: String?
    private var title: String?
    private var newsDescription: String?
    private var link: String?
    private var imageUrl: String?
    private var publishedAt: String?
    
    init() {
        
    }
    
    fileprivate init(params:[String:Any]) {
        if let source = params["source"] as? [String:String] {
            self.sourceId = source["id"]
            self.sourceName = source["name"]
        }
        
        self.author = params["author"] as? String
        self.title = params["title"] as? String
        self.newsDescription = params["description"] as? String
        self.link = params["url"] as? String
        self.imageUrl = params["urlToImage"] as? String
        self.publishedAt = params["publishedAt"] as? String
    }
    
    func getSourceId() -> String {
        guard let value = sourceId else {
            return ""
        }
        
        return value
    }
    
    func getSourceName() -> String {
        guard let value = sourceName else {
            return ""
        }
        
        return value
    }
    
    func getAuthor() -> String {
        guard let value = author else {
            return ""
        }
        
        return value
    }
    
    func getTitle() -> String {
        guard let value = title else {
            return ""
        }
        
        return value
    }
    
    func getNewsDescription() -> String {
        guard let value = newsDescription else {
            return ""
        }
        
        return value
    }
    
    func getLink() -> String {
        guard let value = link else {
            return ""
        }
        
        return value
    }
    
    func getImageUrl() -> String {
        guard let value = imageUrl else {
            return ""
        }
        
        return value
    }
    
    func getPublishedAt() -> String {
        guard let value = publishedAt else {
            return ""
        }
        
        return value
    }
    
}
