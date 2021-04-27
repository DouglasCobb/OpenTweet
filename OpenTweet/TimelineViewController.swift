//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit


class TimelineViewController: UITableViewController {
    
    var tweets: [Tweet] = []

	override func viewDidLoad() {
        
        // Super
		super.viewDidLoad()
        
        // Register Cells
        tableView.register(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
        
        // Load
        loadTweets()
	}
    
    func loadTweets() {
        
        // Load Timeline
        NetworkClient<TimelineRequest>(session: URLSession.shared).load(clientRequest: TimelineRequest()) { [weak self] (tweets, error) in

            // Main Thread
            DispatchQueue.main.async {
                
                // Guard Self
                guard let self = self else { return }
                
                // Load Employees
                self.tweets = tweets ?? []
                
                // Update Table
                self.tableView.reloadData()
            }
        }
    }
}

extension TimelineViewController {
    
    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetTableViewCell
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
}
