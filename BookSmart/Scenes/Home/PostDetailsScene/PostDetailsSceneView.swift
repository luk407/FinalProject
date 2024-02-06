//
//  PostDetailsSceneView.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 22.01.24.
//

import UIKit
import Firebase

final class PostDetailsSceneView: UIViewController {
    
    // MARK: - Properties
    
    private var mainStackView = UIStackView()
    
    private var tableView = UITableView()
    
    private var typeCommentStackView = UIStackView()
    private var typeCommentTextView = UITextView()
    private var submitCommentButton = UIButton()
    
    var viewModel: PostDetailsSceneViewModel
    
    // MARK: - Init
    
    init(viewModel: PostDetailsSceneViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        view.backgroundColor = .customBackgroundColor
        setupSubviews()
        setupConstraints()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.postDetailsSceneViewWillAppear()
    }

    
    // MARK: - Setup Subviews, Constraints, UI
    
    private func setupSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addSubview(tableView)
        mainStackView.addSubview(typeCommentStackView)
        typeCommentStackView.addArrangedSubview(typeCommentTextView)
        typeCommentStackView.addArrangedSubview(submitCommentButton)
    }
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
        setupTableViewConstraints()
        setupTypeCommentStackViewConstraints()
        setupTypeCommentTextViewConstraint()
        setupSubmitCommentButtonConstraints()
    }
    
    private func setupUI() {
        setupMainStackViewUI()
        setupTableViewUI()
        setupTypeCommentStackViewUI()
        setupTypeCommentTextViewUI()
        setupSubmitCommentButtonUI()
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
    
    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: typeCommentStackView.topAnchor, constant: -20),
        ])
    }
    
    private func setupTypeCommentStackViewConstraints() {
        NSLayoutConstraint.activate([
            typeCommentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            typeCommentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            typeCommentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupTypeCommentTextViewConstraint() {
        NSLayoutConstraint.activate([
            typeCommentTextView.heightAnchor.constraint(equalToConstant: 50),
            typeCommentTextView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
    
    private func setupSubmitCommentButtonConstraints() {
        NSLayoutConstraint.activate([
            submitCommentButton.heightAnchor.constraint(equalToConstant: 50),
            submitCommentButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - UI
    
    private func setupMainStackViewUI() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.backgroundColor = .customBackgroundColor
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.alignment = .center
        mainStackView.distribution = .fillProportionally
    }
    
    private func setupTableViewUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .customBackgroundColor
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "postCell")
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "commentCell")
        tableView.register(AnnouncementTableViewCell.self, forCellReuseIdentifier: "announcementCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupTypeCommentStackViewUI() {
        typeCommentStackView.translatesAutoresizingMaskIntoConstraints = false
        typeCommentStackView.axis = .horizontal
        typeCommentStackView.spacing = 8
        typeCommentStackView.alignment = .center
        typeCommentStackView.distribution = .fillProportionally
    }
    
    private func setupTypeCommentTextViewUI() {
        typeCommentTextView.font = .systemFont(ofSize: 16)
        typeCommentTextView.backgroundColor = .customAccentColor.withAlphaComponent(0.5)
        typeCommentTextView.layer.cornerRadius = 8
        typeCommentTextView.tintColor = .black
    }
    
    private func setupSubmitCommentButtonUI() {
        submitCommentButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        submitCommentButton.tintColor = .customAccentColor
        submitCommentButton.addTarget(self, action: #selector(submitCommentButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Private Methods
    
    @objc private func submitCommentButtonTapped() {
        viewModel.submitCommentButtonTapped(commentText: typeCommentTextView.text)
        typeCommentTextView.text = ""
        typeCommentTextView.resignFirstResponder()
    }
}

// MARK: - Extensions

extension PostDetailsSceneView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.postInfo.comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            switch viewModel.postInfo.type {
            case .story:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell {
                    viewModel.getAuthorInfo(with: viewModel.postInfo.authorID) { [self] authorInfo in
                        cell.navigationController = navigationController
                        cell.configureCell(viewModel: viewModel, userInfo: viewModel.userInfo, authorInfo: authorInfo ?? viewModel.userInfo, postInfo: viewModel.postInfo)
                        cell.backgroundColor = .customBackgroundColor
                        cell.contentView.isUserInteractionEnabled = false
                    }
                    return cell
                } else {
                    return UITableViewCell()
                }
            case .announcement:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "announcementCell", for: indexPath) as? AnnouncementTableViewCell {
                    viewModel.getAuthorInfo(with: viewModel.postInfo.authorID) { [ weak self ] authorInfo in
                        cell.viewModel = self?.viewModel
                        cell.userInfo = self?.viewModel.userInfo
                        cell.postInfo = self?.viewModel.postInfo
                        cell.authorInfo = authorInfo
                        cell.navigationController = self?.navigationController
                        cell.configureCell()
                        cell.backgroundColor = .customBackgroundColor
                        cell.contentView.isUserInteractionEnabled = false
                    }
                    return cell
                } else {
                    return UITableViewCell()
                }
            }            
        } else {
            if let commentsInfo = viewModel.commentsInfo, indexPath.row - 1 < commentsInfo.count {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentTableViewCell {
                    let commentInfo = commentsInfo[indexPath.row - 1]
                    cell.navigationController = navigationController
                    cell.configureCell(viewModel: viewModel, commentInfo: commentInfo)
                    cell.backgroundColor = .customBackgroundColor
                    cell.contentView.isUserInteractionEnabled = false
                    return cell
                }
            }
        }
        let emptyCell = UITableViewCell()
        emptyCell.backgroundColor = .customBackgroundColor
        return emptyCell
    }
}

extension PostDetailsSceneView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension PostDetailsSceneView: PostDetailsSceneViewDelegate {
    func postUpdated() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
