//
//  NewsAPIHandler.swift
//  TestApp
//
//  Created by Faraz Habib on 28/02/18.
//  Copyright © 2018 Faraz Habib. All rights reserved.
//

import Foundation
import UIKit

class NewsAPIHandler {
    
    private var session:URLSession!
    
    init() {
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    func fetchNews(pageNo:Int, completionHandler: @escaping (News?, Error?) -> Void) {
        let endPoint = "https://newsapi.org/v2/top-headlines?country=us&category=technology&apiKey=a8fabd9ff4234c82aad08eaaa4ea17a0"
        guard let url = URL(string: endPoint) else {
            print("Error in creating url")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        session.dataTask(with: urlRequest) { (data, responseURL, error) in
            if let responseData = data {
                let news = News(responseData: responseData)
                completionHandler(news, error)
            } else {
                completionHandler(nil, error)
            }
        }.resume()
    }
    
    func getDataFromUrl(urlStr: String, indexPath:IndexPath, completion: @escaping (UIImage?, IndexPath,Error?) -> ()) {
        guard let url = URL(string: urlStr) else {
            print("Error in creating url")
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            if let responseData = data, let image = UIImage(data: responseData) {
                completion(image, indexPath,nil)
            } else {
                completion(nil, indexPath,error)
            }
        }.resume()
        
    }

}
