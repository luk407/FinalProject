
import SwiftUI
import Firebase

final class TabBarController: UITabBarController {
    // MARK: - Properties
    private var appNameLabel = UILabel()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        searchBar.placeholder = "Search..."
        searchBar.delegate = self
        return searchBar
    }()
    
    private var searchButton: UIBarButtonItem!
    private var logoutButton: UIBarButtonItem!
    var userInfo: UserInfo
    
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
        setupLogoutButton()
        setupSearchButtonAndBar()
        
        let postsScenesViewModel = PostsScenesViewModel(userInfo: userInfo)
        
        let homeViewController = HomeSceneView(homeSceneViewModel: postsScenesViewModel)
        
        let announcementsViewController = AnnouncementSceneView(announcementSceneViewModel: postsScenesViewModel)
        
        let createPostViewController = UIHostingController(
            rootView: CreatePostSceneView(
                userInfo: userInfo))
        
        let leaderboardViewController = LeaderboardSceneView(
            leaderboardSceneViewModel: LeaderboardSceneViewModel(
                userInfo: userInfo))
        
        let profileViewController = UIHostingController(
            rootView: ProfileSceneView(
                profileSceneViewModel: ProfileSceneViewModel(
                    profileOwnerInfoID: userInfo.id,
                    userInfo: userInfo)).background(Color(uiColor: .customBackgroundColor)))
        
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), selectedImage: nil)
        homeViewController.tabBarItem.tag = 0
        
        announcementsViewController.tabBarItem = UITabBarItem(title: "Announcements", image: UIImage(systemName: "megaphone.fill"), selectedImage: nil)
        announcementsViewController.tabBarItem.tag = 1
        
        createPostViewController.tabBarItem = UITabBarItem(title: "Create Post", image: UIImage(systemName: "plus.circle"), selectedImage: nil)
        createPostViewController.tabBarItem.tag = 2
        
        leaderboardViewController.tabBarItem = UITabBarItem(title: "Leaderboard", image: UIImage(systemName: "flag.2.crossed.fill"), selectedImage: nil)
        leaderboardViewController.tabBarItem.tag = 3
        
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), selectedImage: nil)
        profileViewController.tabBarItem.tag = 4
        
        UITabBar.appearance().tintColor = UIColor.customAccentColor
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        
        viewControllers = [homeViewController, announcementsViewController, createPostViewController, leaderboardViewController, profileViewController]
    }
    
    private func setupSearchButtonAndBar() {
        searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed))
        navigationItem.titleView = searchBar
        searchBar.isHidden = true
        navigationItem.rightBarButtonItem = searchButton
        searchBar.barTintColor = .customBackgroundColor
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.tintColor = .white
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = .white
        }
    }
    
    @objc private func searchButtonPressed() {
        searchBar.isHidden.toggle()
        
        if searchBar.isHidden {
            if let homeViewController = viewControllers?.first as? HomeSceneView {
                searchBar.text = ""
                homeViewController.homeSceneViewModel.filterStoryPosts(with: "")
            }
        }
        
        if !searchBar.isHidden {
            searchBar.becomeFirstResponder()
        }
    }
    
    private func setupLogoutButton() {
        logoutButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(logoutButtonPressed))
        logoutButton.isHidden = false
    }
    
    @objc private func logoutButtonPressed() {
        do {
            try Auth.auth().signOut()
            
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
               let rootNavigationController = sceneDelegate.window?.rootViewController as? UINavigationController {
                rootNavigationController.popToRootViewController(animated: true)
            } else {
                print("Error accessing the root navigation controller.")
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    private func setupAppNameLabelUI() {
        appNameLabel.text = "BookSmart"
        appNameLabel.font = .systemFont(ofSize: 20)
        appNameLabel.textColor = .customAccentColor
        appNameLabel.sizeToFit()
    }
}

// MARK: - Extensions
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

extension TabBarController {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.tabBarItem.tag == 0 {
            navigationItem.rightBarButtonItem = searchButton
        } else if viewController.tabBarItem.tag == 4 {
            if let homeViewController = viewControllers?.first as? HomeSceneView {
                searchBar.text = ""
                homeViewController.homeSceneViewModel.filterStoryPosts(with: "")
            }
            navigationItem.rightBarButtonItem = logoutButton
            searchBar.resignFirstResponder()
            searchBar.isHidden = true
        } else {
            if let homeViewController = viewControllers?.first as? HomeSceneView {
                searchBar.text = ""
                homeViewController.homeSceneViewModel.filterStoryPosts(with: "")
            }
            navigationItem.rightBarButtonItem = .none
            searchBar.resignFirstResponder()
            searchBar.isHidden = true
        }
    }
}

extension TabBarController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let homeViewController = viewControllers?.first as? HomeSceneView {
            homeViewController.homeSceneViewModel.filterStoryPosts(with: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.isHidden = true
        searchButton.isEnabled = true
        searchButtonPressed()
        if let homeViewController = viewControllers?.first as? HomeSceneView {
            searchBar.text = ""
            homeViewController.homeSceneViewModel.filterStoryPosts(with: "")
        }
    }
}
