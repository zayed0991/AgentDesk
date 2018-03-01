//
//  Article.swift
//  TestApp
//
//  Created by Faraz Habib on 28/02/18.
//  Copyright © 2018 Faraz Habib. All rights reserved.
//

import Foundation
import CoreData

class Article: NSManagedObject {
    
    func setupManagedObject(articleDetails:ArticleDetails) {
        self.sourceId = articleDetails.getSourceId()
        self.sourceName = articleDetails.getSourceName()
        self.author = articleDetails.getAuthor()
        self.title = articleDetails.getTitle()
        self.newsDescription = articleDetails.getNewsDescription()
        self.link = articleDetails.getLink()
        self.imageUrl = articleDetails.getImageUrl()
        self.publishedAt = articleDetails.getPublishedAt()
    }
    
    func getSourceId() -> String {
        return sourceId
    }
    
    func getSourceName() -> String {
        return sourceName
    }
    
    func getAuthor() -> String {
        return author
    }
    
    func getTitle() -> String {
        return title
    }
    
    func getNewsDescription() -> String {
        return newsDescription
    }
    
    func getLink() -> String {
        return link
    }
    
    func getImageUrl() -> String {
        return imageUrl
    }
    
    func getPublishedAt() -> String {
        return publishedAt
    }
    
}

extension Article {
    
    @NSManaged private var sourceId:String
    @NSManaged private var sourceName:String
    @NSManaged private var author:String
    @NSManaged private var title:String
    @NSManaged private var newsDescription:String
    @NSManaged private var link:String
    @NSManaged private var imageUrl:String
    @NSManaged private var publishedAt:String
    
}
