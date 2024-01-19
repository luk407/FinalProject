//
//  HomeView.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import UIKit

class HomeSceneView: UIViewController {
    
    // MARK: - Properties
    
    private var appNameLabel = UILabel()
    
    private var mainStackView = UIStackView()
    
    private var postsTableView = UITableView()
    
    private var homeSceneViewModel = HomeSceneViewModel()
    
    var userInfo: UserInfo
    
    // MARK: - Init
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        homeSceneViewModel.userInfo = userInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackgroundColor
        setupSubviews()
        setupConstraints()
        setupUI()
    }
    
    // MARK: - Setup Subviews, Constraints, UI
    
    private func setupSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(postsTableView)
    }
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
    }
    
    private func setupUI() {
        setupMainStackViewUI()
    }
    
    // MARK: - Constraints
    private func setupMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    // MARK: - UI
    
    private func setupMainStackViewUI() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 0
        mainStackView.distribution = .fillProportionally
    }
    
    private func setupPostsTableViewUI() {
        postsTableView.register(PostsTableViewCell.self, forCellReuseIdentifier: "postCell")
        postsTableView.dataSource = self
        postsTableView.delegate = self
    }
}

// MARK: Extensions
extension HomeSceneView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        homeSceneViewModel.fetchedPostsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let post = homeSceneViewModel.fetchedPostsInfo[indexPath.row]
        cell = postsTableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        if let postCell = cell as? PostsTableViewCell {
            postCell.configureCell(with: post)
        }
        
        return cell
    }
}

extension HomeSceneView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        #warning("go to post details View")
    }
}
