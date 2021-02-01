//
//  CustomTableViewCell.swift
//  WorldNewsTestAppForPecode
//
//  Created by Anton on 30.01.2021.
//

import UIKit
import Kingfisher

class CustomTableViewCell: UITableViewCell {
    
    //MARK: < Add Outlets>

    @IBOutlet weak var imageNewsImage: UIImageView!
    @IBOutlet weak var labelNewsTitle: UILabel!
    
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelSource: UILabel!
    
    @IBOutlet weak var labelDescription: UILabel!
    
    func setup(article: ArticleViewModel) {
        labelNewsTitle.text = article.title
        labelAuthor.text = article.author
        labelSource.text = article.source
        labelDescription.text = article.description
        
        imageNewsImage.kf.setImage(
           with: article.urlToImage,
            placeholder: UIImage(named: "Placeholder"))
    }
}
