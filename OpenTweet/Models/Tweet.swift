//
//  Tweet.swift
//  OpenTweet
//
//  Created by Douglas Cobb on 4/26/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation


struct TimelineContainer: Codable {
    let timeline: [Tweet]
}

struct Tweet: Codable {
    let id: String
    let author: String
    let content: String
    let avatar: String?
    let inReplyTo: String?
    let date: Date
}
