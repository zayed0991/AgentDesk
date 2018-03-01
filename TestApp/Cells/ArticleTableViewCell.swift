//
//  ArticleTableViewCell.swift
//  TestApp
//
//  Created by Faraz Habib on 28/02/18.
//  Copyright © 2018 Faraz Habib. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    typealias ReadMoreBlock = (URLRequest) -> Void
    var readMoreBlock:ReadMoreBlock?

    @IBOutlet weak var imageViewArticle: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNewsDescription: UILabel!
    @IBOutlet weak var lblPusblishedDate: UILabel!
    @IBOutlet weak var btnReadMore: UIButton!
    
    var link:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(article:Article) {
        lblTitle.text = article.getTitle()
        lblNewsDescription.text = article.getNewsDescription()
        lblPusblishedDate.text = article.getPublishedAt()
        link = article.getLink()
    }

    @IBAction func readMoreTapped(_ sender: UIButton) {
        if let urlStr = link, urlStr.count > 0 {
            guard let url = URL(string: urlStr) else {
                return
            }
            
            let urlRequest = URLRequest(url: url)
            readMoreBlock?(urlRequest)
        }
    }
    
}
