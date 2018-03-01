//
//  ViewController.swift
//  TestApp
//
//  Created by Faraz Habib on 28/02/18.
//  Copyright © 2018 Faraz Habib. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableViewArticles: UITableView!
    @IBOutlet weak var viewLoader: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let databaseAccessor = DatabaseAccessor()
    let newsApiHandler = NewsAPIHandler()
    var articlesList = [Article]()
    var imageMapping = [Int:UIImage]()
    var offset = 0
    let limit = 5
    var hasNext = true
    var isFetching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DatabaseAccessor().deleteArticles()
        fetchNews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController {
    
    func fetchNews() {
        newsApiHandler.fetchNews(pageNo: 1) { [weak self] (responseData, error) in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.viewLoader.isHidden = true
                strongSelf.activityIndicator.stopAnimating()
            }
            
            if error != nil {
                print("Error in fetching news")
                return
            }
            
            if responseData?.status == true {
                strongSelf.reloadTableView()
            }
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell") as! ArticleTableViewCell
        
        let article = articlesList[indexPath.row]

        cell.setupCell(article: article)
        cell.readMoreBlock = { [weak self] (request) in
            self?.presentWebViewController(urlRequest: request)
        }
        
        if let articleImage = imageMapping[indexPath.row] {
            DispatchQueue.main.async {
                cell.imageViewArticle.image = articleImage
            }
        } else {
            let imageUrl = article.getImageUrl()
            if imageUrl.count > 0 {
                newsApiHandler.getDataFromUrl(urlStr: imageUrl, indexPath: indexPath ,completion: { [weak self] (image, lastIndexPath, error) in
                    if let articleImage = image {
                        DispatchQueue.main.async {
                            if let lastCell = self?.tableViewArticles.cellForRow(at: lastIndexPath) as? ArticleTableViewCell {
                                lastCell.imageViewArticle.image = articleImage
                            }
                        }
                        self?.imageMapping[lastIndexPath.row] = articleImage
                    }
                })
            }
        }
        
        return cell
    }
}

extension ViewController {
    
    func presentWebViewController(urlRequest:URLRequest) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let articleWebViewVC = storyboard.instantiateViewController(withIdentifier: "ArticleWebViewController") as! ArticleWebViewController
        articleWebViewVC.urlRequest = urlRequest
        DispatchQueue.main.async {
            self.present(articleWebViewVC, animated: true, completion: nil)
        }
    }
    
    func reloadTableView() {
        if hasNext == false {
            return
        }
        
        if let list = databaseAccessor.fetchArticles(offset: offset), list.count > 0 {
            if offset == 0 {
                DispatchQueue.main.async {
                    self.articlesList.append(contentsOf: list)
                    self.tableViewArticles.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    let firstIndex = self.offset
                    var i = 0
                    self.articlesList.append(contentsOf: list)
                    var indexList = [IndexPath]()
                    for _ in list {
                        let indexPath = IndexPath(item: firstIndex + i, section: 0)
                        indexList.append(indexPath)
                        i += 1
                    }
                    self.tableViewArticles.insertRows(at: indexList, with: .automatic)
                    self.isFetching = false
                }
            }
        } else {
            hasNext = false
        }
    }
    
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height && hasNext && !isFetching {
            isFetching = true
            offset += limit
            reloadTableView()
        }
    }
    
}
