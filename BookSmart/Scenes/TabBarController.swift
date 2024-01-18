//
//  TabBarController.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 18.01.24.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeViewController =  HomeSceneView()
        let announcementsViewController = AnnouncementSceneView()
        let createPostViewController = CreatePostSceneView()
        let leaderboardViewController = LeaderboardSceneView()
        let profileViewController = ProfileSceneView()
        
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), selectedImage: nil)
        announcementsViewController.tabBarItem = UITabBarItem(title: "Announcements", image: UIImage(systemName: "megaphone.fill"), selectedImage: nil)
        createPostViewController.tabBarItem = UITabBarItem(title: "Create Post", image: UIImage(systemName: "plus.circle"), selectedImage: nil)
        leaderboardViewController.tabBarItem = UITabBarItem(title: "Leaderboard", image: UIImage(systemName: "flag.2.crossed.fill"), selectedImage: nil)
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), selectedImage: nil)
        
        UITabBar.appearance().tintColor = UIColor.customAccentColor
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        
        viewControllers = [homeViewController, announcementsViewController, createPostViewController, leaderboardViewController, profileViewController]
    }
}
