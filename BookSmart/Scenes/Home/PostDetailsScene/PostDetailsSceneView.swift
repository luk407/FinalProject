
import UIKit

final class PostDetailsSceneView: UIViewController {
    
    // MARK: - Properties
    
    private var detailsTableView = UITableView()
    
    private var typeCommentStackView = UIStackView()
    private var typeCommentTextView = UITextView()
    private var submitCommentButton = UIButton()
    
    private var lastDisplayedRow: Int = -1
    
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
        view.addSubview(detailsTableView)
        view.addSubview(typeCommentStackView)
        typeCommentStackView.addArrangedSubview(typeCommentTextView)
        typeCommentStackView.addArrangedSubview(submitCommentButton)
    }
    
    private func setupConstraints() {
        setupTableViewConstraints()
        setupTypeCommentStackViewConstraints()
        setupTypeCommentTextViewConstraint()
        setupSubmitCommentButtonConstraints()
    }
    
    private func setupUI() {
        setupTableViewUI()
        setupTypeCommentStackViewUI()
        setupTypeCommentTextViewUI()
        setupSubmitCommentButtonUI()
    }
    
    // MARK: - Constraints
    
    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            detailsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailsTableView.bottomAnchor.constraint(equalTo: typeCommentStackView.topAnchor, constant: -20),
        ])
    }
    
    private func setupTypeCommentStackViewConstraints() {
        NSLayoutConstraint.activate([
            typeCommentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            typeCommentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
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
    
    private func setupTableViewUI() {
        detailsTableView.translatesAutoresizingMaskIntoConstraints = false
        detailsTableView.backgroundColor = .customBackgroundColor
        detailsTableView.separatorColor = .clear
        detailsTableView.register(PostTableViewCell.self, forCellReuseIdentifier: "postCell")
        detailsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "commentCell")
        detailsTableView.register(AnnouncementTableViewCell.self, forCellReuseIdentifier: "announcementCell")
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
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
        typeCommentTextView.textColor = .black
    }
    
    private func setupSubmitCommentButtonUI() {
        submitCommentButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        submitCommentButton.tintColor = .customAccentColor
        submitCommentButton.addTarget(self, action: #selector(submitCommentButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Button Methods
    
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
                        cell.configureCell(viewModel: viewModel, userInfo: viewModel.userInfo, authorInfo: authorInfo!, postInfo: viewModel.postInfo)
                        cell.backgroundColor = .customBackgroundColor
                        cell.contentView.isUserInteractionEnabled = true
                        tableView.beginUpdates()
                        cell.layoutIfNeeded()
                        tableView.endUpdates()
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
                        cell.contentView.isUserInteractionEnabled = true
                        tableView.beginUpdates()
                        cell.layoutIfNeeded()
                        tableView.endUpdates()
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
                    viewModel.getAuthorInfo(with: commentInfo.authorID) { commentAuthorInfo in
                        cell.navigationController = self.navigationController
                        cell.configureCell(viewModel: self.viewModel, commentInfo: commentInfo, commentAuthorInfo: commentAuthorInfo!)
                        cell.backgroundColor = .customBackgroundColor
                        cell.contentView.isUserInteractionEnabled = true
                        tableView.beginUpdates()
                        cell.layoutIfNeeded()
                        tableView.endUpdates()
                    }
                    return cell
                }
            } else {
                return UITableViewCell()
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row <= lastDisplayedRow {
            lastDisplayedRow = -1
        }
        
        cell.alpha = 0
        
        let delay = 0.1 * Double(indexPath.row)
        
        UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseInOut, animations: {
            cell.alpha = 1
        }, completion: nil)
        
        lastDisplayedRow = indexPath.row
    }
}

extension PostDetailsSceneView: PostDetailsSceneViewDelegate {
    
    func postUpdated() {
        DispatchQueue.main.async {
            self.detailsTableView.reloadData()
        }
    }
    
    func commentAdded() {
        DispatchQueue.main.async {
            self.insertNewComment()
        }
    }
    
    private func insertNewComment() {
        let indexPath = IndexPath(row: 1, section: 0)
        detailsTableView.insertRows(at: [indexPath], with: .top)
        
        detailsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
