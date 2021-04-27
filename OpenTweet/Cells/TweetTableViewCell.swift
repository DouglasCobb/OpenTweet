//
//  TweetTableViewCell.swift
//  OpenTweet
//
//  Created by Douglas Cobb on 4/26/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit


class TweetTableViewCell: UITableViewCell {
    
    // MARK: Public
    
    var tweet: Tweet? {
        didSet {
            updateInterface()
        }
    }
    
    // MARK: Private
    
    @IBOutlet weak private var authorLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var contentLabel: UILabel!

    override func awakeFromNib() {
        
        // Super
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        // Super
        super.setSelected(selected, animated: animated)
    }
}

extension TweetTableViewCell {
    
    private func updateInterface() {
        
        // Date Formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        // Update Text
        authorLabel.text = tweet?.author
        dateLabel.text = (tweet == nil) ? "N/A" : dateFormatter.string(from: tweet!.date)
        contentLabel.text = tweet?.content
    }
}
