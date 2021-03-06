//
//  DownloadsController.swift
//  Podcast
//
//  Created by Тимур Чеберда on 03/04/2019.
//  Copyright © 2019 Tmur Cheberda. All rights reserved.
//

import UIKit

class DownloadsController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    
    var episodes = UserDefaults.standard.downloadedEpisodes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupObservers()
    }
    
    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
    }
    
    @objc fileprivate func handleDownloadComplete(notification: Notification) {
        guard let episodeDownloadComplete = notification.object as? APIService.EpisodeDownloadComplete else { return }
        
        guard let index = self.episodes.firstIndex(where: {$0.title == episodeDownloadComplete.episodeTitle}) else { return }
        
        self.episodes[index].fileUrl = episodeDownloadComplete.fileUrl
    }
    
    @objc fileprivate func handleDownloadProgress(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        
        guard let progress = userInfo["progress"] as? Double else { return }
        guard let title = userInfo["title"] as? String else { return }
        
        guard let index = self.episodes.firstIndex(where: {$0.title == title}) else { return }
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodeCell else { return }
        cell.progressLabel.text = "\(Int(progress * 100))%"
        cell.progressLabel.isHidden = false 
        
        if progress == 1 {
            cell.progressLabel.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodes = UserDefaults.standard.downloadedEpisodes().reversed()
        tableView.reloadData()
        UIApplication.mainTabBarController()?.viewControllers?[2].tabBarItem.badgeValue = nil
    }
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        
        if episode.fileUrl != nil {
            UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
        } else {
            let ac = UIAlertController(title: "File URL not found", message: "Cannot find local file, play using stream url instead", preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
            }))
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(ac, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        cell.episode = self.episodes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
}
