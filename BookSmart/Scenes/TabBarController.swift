//
//  TabBarController.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 18.01.24.
//

import UIKit

class TabBarController: UITabBarController {
    // MARK: - Properties
    var userInfo: UserInfo
    
    private var appNameLabel = UILabel()
    // MARK: - Init
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        setupAppNameLabelUI()
        
        navigationItem.titleView = appNameLabel
    
        let homeViewController =  HomeSceneView(userInfo: userInfo)
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
    
    private func setupAppNameLabelUI() {
        appNameLabel.text = "placeHolderName"
        appNameLabel.font = .systemFont(ofSize: 20)
        appNameLabel.textColor = .customAccentColor
        appNameLabel.sizeToFit()
    }
}

