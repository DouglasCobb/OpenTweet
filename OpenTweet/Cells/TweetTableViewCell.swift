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
    var replies: [Tweet]? {
        didSet {
            updateInterface()
        }
    }
    
    // MARK: Private
    
    @IBOutlet weak private var avatarImageView: UIImageView!
    @IBOutlet weak private var authorLabel: UILabel!
    @IBOutlet weak private var dateLabel: UILabel!
    @IBOutlet weak private var contentLabel: UILabel!
    @IBOutlet weak private var replyStackView: UIStackView!
    
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
        
        // Toggle Replies
        replyStackView.isHidden = !replyStackView.isHidden
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
        
        // Remove Reply Views
        replyStackView.arrangedSubviews.forEach { view in
            
            // Remove From Arranged
            replyStackView.removeArrangedSubview(view)
            
            // Remove From Superview
            view.removeFromSuperview()
        }
        
        // Create Replies
        for reply in replies ?? [] {
            
            let replyView = UIView()
            replyView.translatesAutoresizingMaskIntoConstraints = false
            
            // Add Stack View
            let replyContentStackView = UIStackView()
            replyContentStackView.axis = .vertical
            replyView.addSubview(replyContentStackView)
            replyContentStackView.translatesAutoresizingMaskIntoConstraints = false
            
            // Constraints
            let leading = NSLayoutConstraint(item: replyContentStackView, attribute: .leading, relatedBy: .equal, toItem: replyView, attribute: .leading, multiplier: 1, constant: 0)
            let trailing = NSLayoutConstraint(item: replyContentStackView, attribute: .trailing, relatedBy: .equal, toItem: replyView, attribute: .trailing, multiplier: 1, constant: 0)
            let top = NSLayoutConstraint(item: replyContentStackView, attribute: .top, relatedBy: .equal, toItem: replyView, attribute: .top, multiplier: 1, constant: 0)
            let bottom = NSLayoutConstraint(item: replyContentStackView, attribute: .bottom, relatedBy: .equal, toItem: replyView, attribute: .bottom, multiplier: 1, constant: 0)
            
            NSLayoutConstraint.activate([leading,trailing,top,bottom])
            
            // Labels
            let replyAuthorLabel = UILabel()
            replyAuthorLabel.text = reply.author
            
            let replyDate = UILabel()
            replyDate.text = dateFormatter.string(from: reply.date)
            
            let replyContentLabel = UILabel()
            replyContentLabel.text = reply.content
            replyContentLabel.numberOfLines = 0
            
            // Add Content
            replyContentStackView.addArrangedSubview(replyAuthorLabel)
            replyContentStackView.addArrangedSubview(replyDate)
            replyContentStackView.addArrangedSubview(replyContentLabel)
            
            // Add
            replyStackView.addArrangedSubview(replyView)
        }
    }
}
