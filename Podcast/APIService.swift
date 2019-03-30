//
//  APIService.swift
//  Podcast
//
//  Created by Тимур Чеберда on 29/03/2019.
//  Copyright © 2019 Tmur Cheberda. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

class APIService {
    
    static let shared = APIService()
    
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        
        guard let url = URL(string: secureFeedUrl) else { return }
        let parser = FeedParser(URL: url)
        parser.parseAsync { (result) in
            if let error = result.error {
                print("failed to parse XML feed:", error)
            }
            guard let feed = result.rssFeed else { return }
            
            let episodes = feed.toEpisodes()
            completionHandler(episodes)
        }
    }
    
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
