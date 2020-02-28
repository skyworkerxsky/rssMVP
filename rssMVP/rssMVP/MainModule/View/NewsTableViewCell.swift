//
//  NewsTableViewCell.swift
//  rssMVP
//
//  Created by Алексей Макаров on 28.02.2020.
//  Copyright © 2020 Алексей Макаров. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var item: RSSItem! {
        didSet {
            sourceLabel.text = item.author
            titleLabel.text = item.title
            descriptionLabel.text = ""
        }
    }
}
