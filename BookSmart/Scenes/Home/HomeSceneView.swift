//
//  HomeView.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import UIKit
import SwiftUI

class HomeSceneView: UIViewController {
    
    // MARK: - Properties
    
    private var mainStackView = UIStackView()
    
    private var postsTableView = UITableView()
    
    var homeSceneViewModel: HomeSceneViewModel
    
    // MARK: - Init
    init(homeSceneViewModel: HomeSceneViewModel) {
        self.homeSceneViewModel = homeSceneViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeSceneViewModel.delegate = self
        homeSceneViewModel.homeSceneViewDidLoad()
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
        setupPostsTableViewConstraints()
    }
    
    private func setupUI() {
        setupMainStackViewUI()
        setupPostsTableViewUI()
    }
    
    // MARK: - Constraints
    private func setupMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupPostsTableViewConstraints() {
        NSLayoutConstraint.activate([
            postsTableView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            postsTableView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            postsTableView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            postsTableView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
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
        postsTableView.translatesAutoresizingMaskIntoConstraints = false
        postsTableView.backgroundColor = .clear
        postsTableView.estimatedRowHeight = 150
        postsTableView.rowHeight = UITableView.automaticDimension
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
        let postInfo = homeSceneViewModel.fetchedPostsInfo[indexPath.row]
        if let cell = postsTableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostsTableViewCell {
            cell.configureCell(viewModel: homeSceneViewModel, postInfo: postInfo)
            cell.contentView.isUserInteractionEnabled = false
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension HomeSceneView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension HomeSceneView: HomeSceneViewDelegate {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.postsTableView.reloadData()
        }
    }
}
