//
//  RequestProvider.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 21/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import Moya

class RequestProvider<T: API> {
    
    private let provider = MoyaProvider<T>()
    
    func performRequest<U: Decodable>(_ target: T, completionHandler: @escaping (_ decodedData: U?, _ error: APIError?) -> ()) {
        
        provider.request(target) { response in
            switch response {
            case let .success(moyaResponse):
                
                do {
                    let decodedData = try JSONDecoder().decode(U.self, from: moyaResponse.data)
                    completionHandler(decodedData, nil)
                } catch {
                    let serializationError = APIError.objectSerialization(reason: error.localizedDescription)
                    completionHandler(nil, serializationError)
                }
            case let .failure(error):
                
                let networkError = APIError.network(reason: error.localizedDescription)
                completionHandler(nil, networkError)
            }
        }
    }
}
