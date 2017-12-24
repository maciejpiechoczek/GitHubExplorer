//
//  API.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 21/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import Moya

protocol API: TargetType {}

extension API {
    
    var sampleData: Data {
        
        return Data()
    }
    
    var headers: [String: String]? {
        
        return nil
    }
}
