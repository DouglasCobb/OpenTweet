//
//  TimelineRequest.swift
//  OpenTweet
//
//  Created by Douglas Cobb on 4/26/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation


struct TimelineRequest: NetworkClientRequestProtocol {
    
    typealias response = [Tweet]
    
    var url: URL {
        return Bundle.main.url(forResource: "timeline", withExtension: "json")!
    }
    
    var httpMethod: String {
        return "GET"
    }
    
    func parse(_ data: Data) -> [Tweet]? {
        do {
            
            // Decoder
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            // Parse
            let timelineContainer = try decoder.decode(TimelineContainer.self, from: data)

            // Return
            return timelineContainer.timeline
            
        } catch {
            print("Generic Parse Error: \(error)")
            return nil
        }
    }
}
