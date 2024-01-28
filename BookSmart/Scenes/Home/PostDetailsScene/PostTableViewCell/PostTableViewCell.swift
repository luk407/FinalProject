//
//  PostTableViewCell.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 23.01.24.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseStorage

class PostTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private var mainStackView = UIStackView()
    
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
    
    var viewModel: PostDetailsSceneViewModel?
    
    weak var navigationController: UINavigationController?

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupSubviews()
        setupConstraints()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        setupConstraints()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorImageView.image = nil
        nameLabel.text = nil
        usernameLabel.text = nil
        timeLabel.text = nil
        headerLabel.text = nil
        bodyTextField.text = nil
    }

    // MARK: - Setup Subviews, Constraints, UI
    
    private func setupSubviews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(authorInfoStackView)
        authorInfoStackView.addArrangedSubview(authorImageView)
        authorInfoStackView.addArrangedSubview(namesStackView)
        namesStackView.addArrangedSubview(nameLabel)
        namesStackView.addArrangedSubview(usernameLabel)
        authorInfoStackView.addArrangedSubview(timeLabel)
        mainStackView.addArrangedSubview(postContentStackView)
        postContentStackView.addArrangedSubview(headerLabel)
        postContentStackView.addArrangedSubview(bodyTextField)
        mainStackView.addArrangedSubview(likeCommentShareStackView)
        likeCommentShareStackView.addArrangedSubview(likeStackView)
        likeCommentShareStackView.addArrangedSubview(commentStackView)
        likeCommentShareStackView.addArrangedSubview(shareStackView)
    }
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
        setupAuthorImageViewConstraints()
        setupTimeLabelConstraints()
    }
    
    private func setupUI() {
        setupMainStackViewUI()
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
    }
    
    func configureCell(viewModel: PostDetailsSceneViewModel, userInfo: UserInfo, postInfo: PostInfo) {
        
        let isLiked = viewModel.userInfo.likedPosts.contains(postInfo.id)

        self.viewModel = viewModel
        viewModel.postCellDelegate = self
        
        authorImageView.image = UIImage(systemName: "person.fill")
        nameLabel.text = userInfo.userName
        usernameLabel.text = userInfo.userName
        timeLabel.text = viewModel.timeAgoString(from: postInfo.postingTime)
        headerLabel.text = postInfo.header
        bodyTextField.text = postInfo.body
        
        retrieveImage()
        
        self.updateLikeButtonUI(isLiked: isLiked)
    }
    
    // MARK: - Constraints
    
    private func setupMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
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
    
    // MARK: - UI
    
    private func setupMainStackViewUI() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        mainStackView.backgroundColor = .customBackgroundColor
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        mainStackView.alignment = .center
        mainStackView.customize(
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
    
    
    // MARK: - Button Methods
    
    @objc private func authorImageTapped(sender: UITapGestureRecognizer) {
        
        let profileSceneView = UIHostingController(rootView: ProfileSceneView(
            profileSceneViewModel: ProfileSceneViewModel(
                profileOwnerInfoID: viewModel!.postInfo.authorID,
                userInfo: viewModel!.userInfo)).background(Color(uiColor: .customBackgroundColor)))
        navigationController?.pushViewController(profileSceneView, animated: true)
        
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
        
        viewModel?.toggleLikePost()
        
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
        
        if let viewController = self.window?.rootViewController {
            activityViewController.popoverPresentationController?.sourceView = self
            viewController.present(activityViewController, animated: true, completion: nil)
        } else {
            
        }
    }
    
    func retrieveImage() {
        authorImageView.image = UIImage(systemName: "person.fill")
        authorImageView.tintColor = .customAccentColor
        
        guard let imageName = viewModel?.postInfo.authorID.uuidString else { return }
        
        if let cachedImage = CacheManager.instance.get(name: imageName) {
            authorImageView.image = cachedImage
        } else {
            let database = Firestore.firestore()
            database.collection("UserInfo").document((viewModel?.postInfo.authorID.uuidString)!).getDocument { document, error in
                if error == nil && document != nil {
                    let imagePath = document?.data()?["image"] as? String
                    self.fetchImage(imagePath ?? "")
                }
            }
        }
    }
    
    private func fetchImage(_ imagePath: String) {
        let storageReference = Storage.storage().reference()
        let fileReference = storageReference.child(imagePath)
        
        fileReference.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let data = data, error == nil, let fetchedImage = UIImage(data: data) {
                print("Image fetched successfully.")
                DispatchQueue.main.async {
                    self.authorImageView.image = fetchedImage
                    CacheManager.instance.add(image: fetchedImage, name: self.viewModel?.postInfo.authorID.uuidString ?? "")
                }
            } else {
                print("Error fetching image:", error?.localizedDescription ?? "Unknown error")
            }
        }
    }
}

// MARK: - Extensions
extension PostTableViewCell: PostDetailsSceneViewDelegateForCells {
    
    func updateLikeButtonUI(isLiked: Bool) {
        DispatchQueue.main.async {
            let imageName = isLiked ? "heart.fill" : "heart"
            
            self.likeButtonImageView.image = UIImage(systemName: imageName)?.withTintColor(.customLikeButtonColor)
            self.likeButtonLabel.textColor = .customLikeButtonColor
        }
    }
}
