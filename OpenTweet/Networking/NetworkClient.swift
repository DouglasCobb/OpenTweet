//
//  NetworkClient.swift
//  OpenTweet
//
//  Created by Douglas Cobb on 4/26/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation


protocol NetworkClientRequestProtocol {
    
    associatedtype response: Codable
    
    var url: URL { get }
    var httpMethod: String { get }
    
    func parse(_ data: Data) -> response?
}

extension NetworkClientRequestProtocol {
    
    func parse(_ data: Data) -> response? {
        do {
            return try JSONDecoder().decode(response.self, from: data)
        } catch {
            print("Generic Parse Error: \(error)")
            return nil
        }
    }
}

class NetworkClient<Request: NetworkClientRequestProtocol> {
    
    enum NetworkClientError: Error, CustomDebugStringConvertible {

        case data
        case parse
        
        var debugDescription: String {
            switch self {
            case .data:
                return "No employee data recieved from endpoint"
            case .parse:
                return "Unable to parse data recieved from endpoint"
            }
        }
    }
    
    typealias completeClosure = ( _ data: Request.response?, _ error: Error?) -> Void
    
    // MARK: Variables
    
    let session: URLSession
    
    // MARK: Init
    
    init(session: URLSession) {
        self.session = session
    }
    
    // MARK: Functions
    
    func load(clientRequest: Request, callback: @escaping completeClosure ) {
        
        var request = URLRequest(url: clientRequest.url)
        request.httpMethod = clientRequest.httpMethod
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // Guard Error
            if let error = error {
                
                // Connection Error
                callback(nil, error)
                
                return
            }
            
            // Guard Data
            guard let data = data else {
                
                // Data Error
                callback(nil, NetworkClientError.data)
                
                return
            }
            
            // Parse Data
            guard let response = clientRequest.parse(data) else {
                
                // Parse Error
                callback(nil, NetworkClientError.parse)
                
                return
            }
            
            // Success
            callback(response, nil)
        }
        
        task.resume()
    }
}

