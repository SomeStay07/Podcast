//
//  UIApplication.swift
//  Podcast
//
//  Created by Тимур Чеберда on 01/04/2019.
//  Copyright © 2019 Tmur Cheberda. All rights reserved.
//

import UIKit

extension UIApplication {
    static func mainTabBarController() -> MainTabBarController? {
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
}
