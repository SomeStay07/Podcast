//
//  APIService.swift
//  Podcast
//
//  Created by Тимур Чеберда on 29/03/2019.
//  Copyright © 2019 Tmur Cheberda. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
    static let shared = APIService()
    
    func fetchPodcasts(searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": searchText, "media": "podcast"]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect yahoo", err)
                return
            }
            
            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try
                    JSONDecoder().decode(SearchResult.self, from: data)
                completionHandler(searchResult.results)
            } catch let decodeError {
                print("Faild", decodeError)
            }
        }
    }
    
    struct SearchResult: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
    
}
