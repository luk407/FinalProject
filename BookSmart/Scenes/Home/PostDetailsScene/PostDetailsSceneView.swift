//
//  PostDetailsSceneView.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 22.01.24.
//

import UIKit
import Firebase

class PostDetailsSceneView: UIViewController {
    
    // MARK: - Properties
    
    private var mainScrollView = UIScrollView()
    
    private var contentStackView = UIStackView()
    
    private var postStackView = UIStackView()
    
    private var commentsListStackView = UIStackView()
    
    private let authorInfoStackView = UIStackView()
    
    private var authorImageView = UIImageView()
    
    private let namesStackView = UIStackView()
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    
    private let timeLabel = UILabel()
    
    private let postContentStackView = UIStackView()
    private let headerLabel = UILabel()
    private let bodyTextField = UITextField()
    
    private let likeCommentShareStackView = UIStackView()
    
    private let likeStackView = UIStackView()
    private let likeButtonImageView = UIImageView()
    private let likeButtonLabel = UILabel()
    
    private let commentStackView = UIStackView()
    private let commentButtonImageView = UIImageView()
    private let commentButtonLabel = UILabel()
    
    private let shareStackView = UIStackView()
    private let shareButtonImageView = UIImageView()
    private let shareButtonLabel = UILabel()
    
    private var commentsTableView = UITableView()
    
    private var temporaryText = UILabel()
    
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
        viewModel.configureUI()
        view.backgroundColor = .customBackgroundColor
        setupSubviews()
        setupConstraints()
        setupUI()
    }
    
    // MARK: - Setup Subviews, Constraints, UI
    
    private func setupSubviews() {
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(postStackView)
        contentStackView.addArrangedSubview(commentsListStackView)
        postStackView.addArrangedSubview(authorInfoStackView)
        authorInfoStackView.addArrangedSubview(authorImageView)
        authorInfoStackView.addArrangedSubview(namesStackView)
        namesStackView.addArrangedSubview(nameLabel)
        namesStackView.addArrangedSubview(usernameLabel)
        authorInfoStackView.addArrangedSubview(timeLabel)
        postStackView.addArrangedSubview(postContentStackView)
        postContentStackView.addArrangedSubview(headerLabel)
        postContentStackView.addArrangedSubview(bodyTextField)
        postStackView.addArrangedSubview(likeCommentShareStackView)
        likeCommentShareStackView.addArrangedSubview(likeStackView)
        likeCommentShareStackView.addArrangedSubview(commentStackView)
        likeCommentShareStackView.addArrangedSubview(shareStackView)
        commentsListStackView.addArrangedSubview(temporaryText)
        view.addSubview(typeCommentStackView)
        typeCommentStackView.addArrangedSubview(typeCommentTextView)
        typeCommentStackView.addArrangedSubview(submitCommentButton)
    }
    
    private func setupConstraints() {
        setupMainScrollViewConstraints()
        setupContentStackViewConstraints()
        setupAuthorInfoStackViewConstraints()
        setupAuthorImageViewConstraints()
        setupTimeLabelConstraints()
        setupPostContentStackViewConstraints()
        setupBodyTextFieldConstraints()
        setupTypeCommentStackViewConstraints()
        setupTypeCommentTextViewConstraint()
        setupSubmitCommentButtonConstraints()
    }
    
    private func setupUI() {
        setupMainScrollViewUI()
        setupContentStackViewUI()
        setupPostStackViewUI()
        setupAuthorInfoStackViewUI()
        setupAuthorImageViewUI()
        setupNamesStackViewUI()
        setupNameLabelUI()
        setupUsernameLabelUI()
        setupTimeLabelUI()
        setupPostContentStackViewUI()
        setupHeaderLabelUI()
        setupBodyTextFieldUI()
        setupLikeCommentShareStackViewUI()
        setupLikeStackViewUI()
        setupCommentStackViewUI()
        setupShareStackViewUI()
        setupCommentsListStackViewUI()
        setupTemporaryComments()
        setupTypeCommentStackViewUI()
        setupTypeCommentTextViewUI()
        setupSubmitCommentButtonUI()
    }
    
    // MARK: - Constraints
    
    private func setupMainScrollViewConstraints() {
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: typeCommentStackView.topAnchor, constant: -20),
        ])
    }
    
    private func setupContentStackViewConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
        ])
    }
    
    private func setupAuthorInfoStackViewConstraints() {
        NSLayoutConstraint.activate([
            authorInfoStackView.leadingAnchor.constraint(equalTo: postStackView.leadingAnchor, constant: 20),
            authorInfoStackView.trailingAnchor.constraint(equalTo: postStackView.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupAuthorImageViewConstraints() {
        NSLayoutConstraint.activate([
            authorImageView.widthAnchor.constraint(equalToConstant: 50),
            authorImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupTimeLabelConstraints() {
        NSLayoutConstraint.activate([
            timeLabel.widthAnchor.constraint(equalToConstant: 30),
            timeLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupPostContentStackViewConstraints() {
        NSLayoutConstraint.activate([
            postContentStackView.leadingAnchor.constraint(equalTo: postStackView.leadingAnchor, constant: 20),
            postContentStackView.trailingAnchor.constraint(equalTo: postStackView.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupBodyTextFieldConstraints() {
        NSLayoutConstraint.activate([
            bodyTextField.leadingAnchor.constraint(equalTo: postContentStackView.leadingAnchor),
            bodyTextField.trailingAnchor.constraint(equalTo: postContentStackView.trailingAnchor),
            bodyTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            bodyTextField.bottomAnchor.constraint(equalTo: postContentStackView.bottomAnchor)
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
    
    private func setupMainScrollViewUI() {
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    private func setupContentStackViewUI() {
        contentStackView.axis = .vertical
        contentStackView.spacing = 0
        contentStackView.alignment = .center
        contentStackView.distribution = .fillProportionally
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupPostStackViewUI() {
        postStackView.translatesAutoresizingMaskIntoConstraints = false
        postStackView.isLayoutMarginsRelativeArrangement = true
        postStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        postStackView.axis = .vertical
        postStackView.spacing = 16
        postStackView.alignment = .center
        postStackView.customize(
            backgroundColor: .customAccentColor.withAlphaComponent(0.1),
            radiusSize: 8,
            borderColor: .clear,
            borderWidth: 1)
    }
    
    private func setupAuthorInfoStackViewUI() {
        authorInfoStackView.axis = .horizontal
        authorInfoStackView.distribution = .fillProportionally
        authorInfoStackView.alignment = .center
        authorInfoStackView.spacing = 16
    }
    
    private func setupAuthorImageViewUI() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.authorImageTapped))
        authorImageView.addGestureRecognizer(gestureRecognizer)
        authorImageView.isUserInteractionEnabled = true
        
        authorImageView.translatesAutoresizingMaskIntoConstraints = false
        authorImageView.contentMode = .scaleAspectFill
        authorImageView.image = UIImage(systemName: "person.fill")
        authorImageView.clipsToBounds = true
        authorImageView.layer.cornerRadius = 25
        authorImageView.layer.borderColor = UIColor.customAccentColor.withAlphaComponent(0.5).cgColor
        authorImageView.layer.borderWidth = 2
    }
    
    private func setupNamesStackViewUI() {
        namesStackView.axis = .vertical
        namesStackView.distribution = .fillProportionally
        namesStackView.alignment = .leading
        namesStackView.spacing = 8
    }
    
    private func setupNameLabelUI() {
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .white
    }
    
    private func setupUsernameLabelUI() {
        usernameLabel.font = .systemFont(ofSize: 14)
        usernameLabel.textColor = .systemGray
    }
    
    private func setupTimeLabelUI() {
        timeLabel.font = .systemFont(ofSize: 14)
        timeLabel.textColor = .white
    }
    
    private func setupPostContentStackViewUI() {
        postContentStackView.clipsToBounds = false
        postContentStackView.axis = .vertical
        postContentStackView.spacing = 16
        postContentStackView.alignment = .leading
        postContentStackView.distribution = .fillProportionally
    }
    
    private func setupHeaderLabelUI() {
        headerLabel.font = .boldSystemFont(ofSize: 16)
        headerLabel.textColor = .white
    }
    
    private func setupBodyTextFieldUI() {
        bodyTextField.font = .systemFont(ofSize: 14)
        bodyTextField.isEnabled = false
        bodyTextField.backgroundColor = .clear
        bodyTextField.textColor = .white
    }

    private func setupLikeCommentShareStackViewUI() {
        likeCommentShareStackView.axis = .horizontal
        likeCommentShareStackView.distribution = .fillProportionally
        likeCommentShareStackView.alignment = .center
        likeCommentShareStackView.spacing = 32
    }
    
    private func setupLikeStackViewUI() {
        likeButtonImageView.image = UIImage(systemName: "heart")
        setupLikeCommentShareStackViewUI(
            likeStackView,
            imageView: likeButtonImageView,
            label: likeButtonLabel,
            labelText: "Like",
            buttonColor: .customLikeButtonColor,
            action: #selector(likeButtonTapped))
    }
    
    private func setupCommentStackViewUI() {
        commentButtonImageView.image = UIImage(systemName: "text.bubble")
        setupLikeCommentShareStackViewUI(
            commentStackView,
            imageView: commentButtonImageView,
            label: commentButtonLabel,
            labelText: "Comment",
            buttonColor: .customCommentButtonColor,
            action: #selector(commentButtonTapped))
    }
    
    private func setupShareStackViewUI() {
        shareButtonImageView.image = UIImage(systemName: "square.and.arrow.up")
        setupLikeCommentShareStackViewUI(
            shareStackView,
            imageView: shareButtonImageView,
            label: shareButtonLabel,
            labelText: "Share",
            buttonColor: .customShareButtonColor,
            action: #selector(shareButtonTapped))
    }
    
    private func setupLikeCommentShareStackViewUI(_ stackView: UIStackView, imageView: UIImageView, label: UILabel, labelText: String, buttonColor: UIColor, action: Selector) {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = buttonColor
        
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .customAccentColor
        label.text = labelText
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: action)
        stackView.addGestureRecognizer(gestureRecognizer)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
    }
    
    private func setupCommentsListStackViewUI() {
        commentsListStackView.translatesAutoresizingMaskIntoConstraints = false
        commentsListStackView.isLayoutMarginsRelativeArrangement = true
        commentsListStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        commentsListStackView.axis = .vertical
        commentsListStackView.spacing = 8
        commentsListStackView.alignment = .center
        commentsListStackView.distribution = .fillProportionally
    }
    
    private func setupTemporaryComments() {
        temporaryText.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam pretium vehicula lacinia. Sed justo sapien, commodo ut molestie eget, vestibulum eget turpis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Integer volutpat ligula nunc, porta consectetur erat volutpat in. Pellentesque aliquet risus porta ligula feugiat, sit amet sollicitudin felis varius. Suspendisse a felis a purus placerat blandit. Integer porta est sit amet mi gravida pharetra. Fusce ultricies nisl eu nunc dapibus, tempor feugiat purus aliquam. Fusce tempus ipsum odio. Nam porttitor iaculis justo, vel fringilla metus placerat eu.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam pretium vehicula lacinia. Sed justo sapien, commodo ut molestie eget, vestibulum eget turpis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Integer volutpat ligula nunc, porta consectetur erat volutpat in. Pellentesque aliquet risus porta ligula feugiat, sit amet sollicitudin felis varius. Suspendisse a felis a purus placerat blandit. Integer porta est sit amet mi gravida pharetra. Fusce ultricies nisl eu nunc dapibus, tempor feugiat purus aliquam. Fusce tempus ipsum odio. Nam porttitor iaculis justo, vel fringilla metus placerat eu.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam pretium vehicula lacinia. Sed justo sapien, commodo ut molestie eget, vestibulum eget turpis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Integer volutpat ligula nunc, porta consectetur erat volutpat in. Pellentesque aliquet risus porta ligula feugiat, sit amet sollicitudin felis varius. Suspendisse a felis a purus placerat blandit. Integer porta est sit amet mi gravida pharetra. Fusce ultricies nisl eu nunc dapibus, tempor feugiat purus aliquam. Fusce tempus ipsum odio. Nam porttitor iaculis justo, vel fringilla metus placerat eu.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam pretium vehicula lacinia. Sed justo sapien, commodo ut molestie eget, vestibulum eget turpis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Integer volutpat ligula nunc, porta consectetur erat volutpat in. Pellentesque aliquet risus porta ligula feugiat, sit amet sollicitudin felis varius. Suspendisse a felis a purus placerat blandit. Integer porta est sit amet mi gravida pharetra. Fusce ultricies nisl eu nunc dapibus, tempor feugiat purus aliquam. Fusce tempus ipsum odio. Nam porttitor iaculis justo, vel fringilla metus placerat eu.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam pretium vehicula lacinia. Sed justo sapien, commodo ut molestie eget, vestibulum eget turpis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Integer volutpat ligula nunc, porta consectetur erat volutpat in. Pellentesque aliquet risus porta ligula feugiat, sit amet sollicitudin felis varius. Suspendisse a felis a purus placerat blandit. Integer porta est sit amet mi gravida pharetra. Fusce ultricies nisl eu nunc dapibus, tempor feugiat purus aliquam. Fusce tempus ipsum odio. Nam porttitor iaculis justo, vel fringilla metus placerat eu."
        temporaryText.numberOfLines = 0
        temporaryText.textColor = .white
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
    
    // MARK: - Animations
    
    @objc private func authorImageTapped(sender: UITapGestureRecognizer) {
        
#warning("changee")
        
        if sender.state == .ended {
            UIView.animate(withDuration: 0.1, animations: {
                self.authorImageView.alpha = 0.2
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.authorImageView.alpha = 1.0
                }
            }
        }
    }
    
    @objc private func likeButtonTapped(sender: UITapGestureRecognizer) {
        
        viewModel.toggleLikePost()
        
        if sender.state == .ended {
            UIView.animate(withDuration: 0.1, animations: {
                self.likeButtonImageView.alpha = 0.2
                self.likeButtonLabel.alpha = 0.2
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.likeButtonImageView.alpha = 1.0
                    self.likeButtonLabel.alpha = 1.0
                }
            }
        }
    }
    
    @objc private func commentButtonTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            UIView.animate(withDuration: 0.1, animations: {
                self.commentButtonImageView.alpha = 0.2
                self.commentButtonLabel.alpha = 0.2
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.commentButtonImageView.alpha = 1.0
                    self.commentButtonLabel.alpha = 1.0
                }
            }
        }
    }
    
    @objc private func shareButtonTapped(sender: UITapGestureRecognizer) {
        
        sharePost()
        
        if sender.state == .ended {
            UIView.animate(withDuration: 0.1, animations: {
                self.shareButtonImageView.alpha = 0.2
                self.shareButtonLabel.alpha = 0.2
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.shareButtonImageView.alpha = 1.0
                    self.shareButtonLabel.alpha = 1.0
                }
            }
        }
    }
    
    private func sharePost() {
        
        let textToShare = "Check out this post on BookSmart!"
        let postURL = URL(string: "someURL")
        let items: [Any] = [textToShare, postURL as Any]
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [
            .addToReadingList,
            .assignToContact,
            .saveToCameraRoll
        ]
        
        if let viewController = self.presentingViewController {
            activityViewController.popoverPresentationController?.sourceView = self.view
            viewController.present(activityViewController, animated: true, completion: nil)
        } else {
            
        }
    }
    
    @objc private func submitCommentButtonTapped() {
        
        viewModel.submitCommentButtonTapped(commentText: typeCommentTextView.text)
        typeCommentTextView.text = ""
        typeCommentTextView.resignFirstResponder()
    }
}

// MARK: - Extensions
extension PostDetailsSceneView: PostDetailsSceneViewDelegate {
    
    internal func updateLikeButtonUI(isLiked: Bool) {
        
        DispatchQueue.main.async {
            let imageName = isLiked ? "heart.fill" : "heart"
            
            self.likeButtonImageView.image = UIImage(systemName: imageName)?.withTintColor(.customLikeButtonColor)
            self.likeButtonLabel.textColor = .customLikeButtonColor
        }
    }

    func updateUI() {
        
        DispatchQueue.main.async {
            #warning("do this later after cell is ready")
            //self.commentButtonLabel.text = "Comment (\(self.postInfo.comments.count))"
        }
    }
    
    func configureUI(name: String, userName: String, time: String, header: String, body: String) {
        nameLabel.text = name
        usernameLabel.text = userName
        timeLabel.text = time
        headerLabel.text = header
        bodyTextField.text = body
    }    
}

extension PostDetailsSceneView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CommentTableViewCell()
        
        return cell
    }
}

extension PostDetailsSceneView: UITableViewDelegate {
    
}
