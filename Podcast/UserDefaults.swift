//
//  UserDefaults.swift
//  Podcast
//
//  Created by Тимур Чеберда on 03/04/2019.
//  Copyright © 2019 Tmur Cheberda. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let favoritedPodcastKey = "favoritedPodcastKey"
    static let downloadedEpisodeKey = "downloadedEpisodeKey"
    
    func downloadEpisode(episode: Episode) {
        do {
            var episodes = downloadedEpisodes()
            episodes.append(episode)
            let data = try JSONEncoder().encode(episodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
        } catch let encodeError {
            print("Failed to encode episode:", encodeError)
        }
    }
    
    func downloadedEpisodes() -> [Episode] {
        guard let episodeData = data(forKey: UserDefaults.downloadedEpisodeKey) else { return [] }
        
        do {
            let episodes = try JSONDecoder().decode([Episode].self, from: episodeData)
            return episodes
        } catch let decodeError {
            print("Failed to decode:", decodeError)
        }
        return []
    }
    
    func savedPodcasts() -> [Podcast] {
        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return [] }
        guard let savedPodcasts = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastsData) as? [Podcast] else { return [] }
        return savedPodcasts
    }
    
    func deletePodcast(podcast: Podcast) {
        let podcasts = savedPodcasts()
        let filteredPodcast = podcasts.filter { (p) -> Bool in
            return p.trackName != podcast.trackName && p.artistName != podcast.artistName
        }
        let data = try? NSKeyedArchiver.archivedData(withRootObject: filteredPodcast, requiringSecureCoding: false)
        UserDefaults.standard.setValue(data, forKeyPath: UserDefaults.favoritedPodcastKey)
    }
}
