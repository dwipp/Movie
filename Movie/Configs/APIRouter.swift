//
//  APIRouter.swift
//  Movie
//
//  Created by Dwi Putra on 03/12/20.
//

import Foundation
import Alamofire

enum APIRouter: APIConfiguration {
    case heroList
    
    var method: HTTPMethod {
        switch self {
        case .heroList:
            return .get
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case .heroList:
            return .body([:])
        }
    }
    
    var path: String {
        switch self {
        case .heroList:
            return "/herostats"
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        let url = try Constants.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        switch parameters {
        case .body(let params):
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        case .url(let params):
            let queryParams = params.map { pair in
                return URLQueryItem(name: pair.key, value: "\(pair.value)")
            }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            urlRequest.url = components?.url
        }
        return urlRequest
    }
    
    
}