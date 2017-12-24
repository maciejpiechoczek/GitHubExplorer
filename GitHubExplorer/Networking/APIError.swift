//
//  APIError.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 21/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import Foundation

enum APIError: Error {
    
    case network(reason: String)
    case objectSerialization(reason: String)
    
    enum Description: String {
        
        case wrongDateFormat = "Wrong date format."
    }
}

extension APIError: LocalizedError {
    
    public var errorDescription: String? {
        
        switch self {
        case .network(let reason):
            return reason
            
        case .objectSerialization(let reason):
            return reason
        }
    }
}
