//
//  String.swift
//  Podcast
//
//  Created by Тимур Чеберда on 30/03/2019.
//  Copyright © 2019 Tmur Cheberda. All rights reserved.
//

import Foundation

extension String {
    
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
