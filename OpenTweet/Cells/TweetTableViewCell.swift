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
    
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var authorLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var contentLabel: UILabel!
    
    private var convertedContent: NSAttributedString? {
        
        // Guard Content
        guard let content = tweet?.content else { return nil }
        
        // Process Content
        do {
            
            // Converted Content
            let convertedContent = NSMutableAttributedString(string: content)
            
            // Mentions
            let mentionRegex = try NSRegularExpression(pattern: "@\\S*", options: [])
            let mentions = mentionRegex.matches(in: content, options: [], range: NSMakeRange(0, content.count))
            
            // Format Mentions
            for mention in mentions {
                
                // Add Color
                convertedContent.addAttribute(.foregroundColor, value: tintColor ?? .blue, range: mention.range)
            }
            
            // Link Regex
            let linkRegex = try NSRegularExpression(pattern: "(www|http:|https:)+[^\\s]+[\\w]", options: [])
            let links = linkRegex.matches(in: content, options: [], range: NSMakeRange(0, content.count))
            
            // Format Links
            for link in links {
                
                // Add Color
                convertedContent.addAttribute(.foregroundColor, value: tintColor ?? .blue, range: link.range)
            }
            
            return convertedContent
            
        } catch {
            return nil
        }
    }

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
        
        // Set Placeholder Image
        avatarImageView.image = UIImage(named: "employeePlaceholder")
        
        // Avatar
        avatarImageView.isHidden = tweet?.avatar == nil
        if let avatar = tweet?.avatar, let avatarURL = NSURL(string: avatar) {
            
            // Load Image
            ImageCache.publicCache.load(avatarURL) { [weak self] image in
                
                // Verify Current URL
                if avatar == self?.tweet?.avatar {
                    self?.avatarImageView.image = image
                }
            }
        }
        
        // Author / Date Text
        authorLabel.text = tweet?.author
        dateLabel.text = (tweet == nil) ? "N/A" : dateFormatter.string(from: tweet!.date)
        contentLabel.attributedText = convertedContent
    }
}
