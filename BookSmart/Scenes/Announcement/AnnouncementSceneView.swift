//
//  AnnouncementSceneView.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import UIKit

final class AnnouncementSceneView: UIViewController {
    
    // MARK: - Properties
    
    private var mainStackView = UIStackView()
    
    private var announcementsTableView = UITableView()
    
    private let refreshControl = UIRefreshControl()
    
    var announcementSceneViewModel: PostsScenesViewModel
    
    // MARK: - Init
    
    init(announcementSceneViewModel: PostsScenesViewModel) {
        self.announcementSceneViewModel = announcementSceneViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        announcementSceneViewModel.delegate = self
        view.backgroundColor = .customBackgroundColor
        setupSubviews()
        setupConstraints()
        setupUI()
    }
    
    // MARK: - Setup Subviews, Constraints, UI
    
    private func setupSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(announcementsTableView)
    }
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
        setupAnnouncementsTableViewConstraints()
    }
    
    private func setupUI() {
        setupMainStackViewUI()
        setupAnnouncementsTableViewUI()
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
    
    private func setupAnnouncementsTableViewConstraints() {
        NSLayoutConstraint.activate([
            announcementsTableView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            announcementsTableView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            announcementsTableView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            announcementsTableView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
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
    
    private func setupAnnouncementsTableViewUI() {
        announcementsTableView.translatesAutoresizingMaskIntoConstraints = false
        announcementsTableView.backgroundColor = .clear
        announcementsTableView.estimatedRowHeight = 200
        announcementsTableView.rowHeight = UITableView.automaticDimension
        announcementsTableView.register(AnnouncementsTableViewCell.self, forCellReuseIdentifier: "announcementCell")
        announcementsTableView.dataSource = self
        announcementsTableView.delegate = self
        announcementsTableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        refreshControl.tintColor = .customAccentColor
    }
    
    @objc private func refreshTableView() {
        announcementsTableView.reloadData()
        refreshControl.endRefreshing()
    }
}

// MARK: - Extensions

extension AnnouncementSceneView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        announcementSceneViewModel.announcementPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let announcementPostInfo = announcementSceneViewModel.announcementPosts[indexPath.row]
        if let cell = announcementsTableView.dequeueReusableCell(withIdentifier: "announcementCell", for: indexPath) as? AnnouncementsTableViewCell {
            cell.navigationController = navigationController
            cell.viewModel = announcementSceneViewModel
            cell.postInfo = announcementPostInfo
            cell.configureCell()
            cell.contentView.isUserInteractionEnabled = false
            cell.layoutIfNeeded()
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension AnnouncementSceneView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension AnnouncementSceneView: PostsScenesViewModelDelegate {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.announcementsTableView.reloadData()
        }
    }
}
