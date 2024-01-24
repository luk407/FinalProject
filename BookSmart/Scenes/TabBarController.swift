//
//  TabBarController.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 18.01.24.
//

import UIKit
import SwiftUI

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
        
        self.delegate = self
        
        navigationItem.hidesBackButton = true
        
        setupAppNameLabelUI()
        
        navigationItem.titleView = appNameLabel
    
        let homeViewController =  HomeSceneView(homeSceneViewModel: HomeSceneViewModel(userInfo: userInfo))
        let announcementsViewController = AnnouncementSceneView()
        let createPostViewController = UIHostingController(rootView: CreatePostSceneView(userInfo: userInfo))
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
        
        appNameLabel.text = "BookSmart"
        appNameLabel.font = .systemFont(ofSize: 20)
        appNameLabel.textColor = .customAccentColor
        appNameLabel.sizeToFit()
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is UIHostingController<CreatePostSceneView> {
            let createPostViewController = UIHostingController(rootView: CreatePostSceneView(userInfo: userInfo))
            present(createPostViewController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
}

