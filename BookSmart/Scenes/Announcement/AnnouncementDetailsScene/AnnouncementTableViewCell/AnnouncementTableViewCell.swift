//
//  AnnouncementTableViewCell.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 01.02.24.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseStorage

final class AnnouncementTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let mainStackView = UIStackView()
    
    private let announcementAuthorStackView = UIStackView()
    
    private let authorInfoStackView = UIStackView()
    
    private let backgroundImageView = UIImageView()
    
    private var authorImageView = UIImageView()
    
    private let namesStackView = UIStackView()
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    
    private let spoilerTagStackView = UIStackView()
    private let spoilerLabel = UILabel()
    
    private let timeLabel = UILabel()
    
    private let postContentStackView = UIStackView()
    private let headerLabel = UILabel()
    private let bodyLabel = UILabel()
    
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
    
    var postInfo: PostInfo?
    
    var userInfo: UserInfo?
    
    var authorInfo: UserInfo?
    
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImageView.image = nil
        authorImageView.image = nil
        nameLabel.text = nil
        usernameLabel.text = nil
        timeLabel.text = nil
        headerLabel.text = nil
        bodyLabel.text = nil
    }

    // MARK: - Setup Subviews, Constraints, UI
    
    private func setupSubviews() {
        addSubview(mainStackView) // vertical
        mainStackView.addArrangedSubview(announcementAuthorStackView) // horizontal
        mainStackView.addArrangedSubview(postContentStackView) // vertical
        mainStackView.addArrangedSubview(likeCommentShareStackView) // horizontal
        
        announcementAuthorStackView.addArrangedSubview(spoilerTagStackView)
        announcementAuthorStackView.addArrangedSubview(authorInfoStackView) //vertical
        announcementAuthorStackView.addArrangedSubview(timeLabel)
        
        spoilerTagStackView.addArrangedSubview(spoilerLabel)
        
        authorInfoStackView.addArrangedSubview(backgroundImageView)
        
        authorInfoStackView.addSubview(authorImageView)
        authorInfoStackView.addArrangedSubview(namesStackView)
        authorInfoStackView.bringSubviewToFront(authorImageView)
        
        namesStackView.addArrangedSubview(nameLabel)
        namesStackView.addArrangedSubview(usernameLabel)
                
        postContentStackView.addArrangedSubview(headerLabel)
        postContentStackView.addArrangedSubview(bodyLabel)
        
        likeCommentShareStackView.addArrangedSubview(likeStackView)
        likeCommentShareStackView.addArrangedSubview(commentStackView)
        likeCommentShareStackView.addArrangedSubview(shareStackView)
    }
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
        setupAnnouncementAuthorStackViewConstraints()
        setupAuthorInfoViewConstraints()
        setupSpoilerTagStackViewConstraints()
        setupAuthorImageViewConstraints()
        setupTimeLabelConstraints()
        setupPostContentStackViewConstraints()
        setupBodyLabelConstraints()
    }
    
    private func setupUI() {
        setupMainStackViewUI()
        setupAnnouncementAuthorStackViewUI()
        setupAuthorInfoViewUI()
        setupBackgroundImageViewUI()
        setupAuthorImageViewUI()
        setupNamesStackViewUI()
        setupNameLabelUI()
        setupUsernameLabelUI()
        setupSpoilerTagUI()
        setupTimeLabelUI()
        setupPostContentStackViewUI()
        setupHeaderLabelUI()
        setupBodyLabelUI()
        setupLikeCommentShareStackViewUI()
        setupLikeStackViewUI()
        setupCommentStackViewUI()
        setupShareStackViewUI()
    }
    
    func configureCell() {
        viewModel?.announcementCellDelegate = self
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        let timeAgo = viewModel?.timeAgoString(from: postInfo?.postingTime ?? Date())
        
        nameLabel.text = "\(authorInfo?.displayName ?? "")"
        usernameLabel.text = "@\(authorInfo?.userName ?? "")"
        timeLabel.text = timeAgo
        headerLabel.text = postInfo?.header
        bodyLabel.text = postInfo?.body
        spoilerLabel.text = postInfo?.spoilersAllowed ?? false ? "SPOILERS" : "SPOILER\nFREE"
        
        switch postInfo?.announcementType {
        case .finishedBook:
            backgroundImageView.image = UIImage(systemName: "book.closed.fill")
        case .startedBook:
            backgroundImageView.image = UIImage(systemName: "book.fill")
        case nil:
            break
        case .some(.none):
            break
        }
        
        let isLiked = viewModel?.userInfo.likedPosts.contains(postInfo!.id)
        self.retrieveImage()
        self.updateLikeButtonUI(isLiked: isLiked ?? false)
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
    
    private func setupAnnouncementAuthorStackViewConstraints() {
        NSLayoutConstraint.activate([
            announcementAuthorStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 20),
            announcementAuthorStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -20),
            announcementAuthorStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 20),
        ])
    }
    
    private func setupAuthorInfoViewConstraints() {
        NSLayoutConstraint.activate([
            authorInfoStackView.heightAnchor.constraint(equalToConstant: 170)
        ])
    }
    
    private func setupBackgroundImageViewConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.heightAnchor.constraint(equalToConstant: 100),
            backgroundImageView.widthAnchor.constraint(equalToConstant: 100),
        ])
    }

    private func setupSpoilerTagStackViewConstraints() {
        NSLayoutConstraint.activate([
            spoilerTagStackView.widthAnchor.constraint(equalToConstant: 50),
            spoilerTagStackView.heightAnchor.constraint(equalToConstant: 25),
            //spoilerTagStackView.centerYAnchor.constraint(equalTo: announcementAuthorStackView.centerYAnchor, constant: -16)
        ])

    }
    
    private func setupAuthorImageViewConstraints() {
        NSLayoutConstraint.activate([
            authorImageView.widthAnchor.constraint(equalToConstant: 60),
            authorImageView.heightAnchor.constraint(equalToConstant: 60),
            authorImageView.centerYAnchor.constraint(equalTo: authorInfoStackView.centerYAnchor),
            authorImageView.centerXAnchor.constraint(equalTo: authorInfoStackView.centerXAnchor),
        ])
    }
    
    private func setupNamesStackViewConstraints() {
        NSLayoutConstraint.activate([
            namesStackView.topAnchor.constraint(equalTo: authorImageView.bottomAnchor, constant: 8),
            namesStackView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setupTimeLabelConstraints() {
        NSLayoutConstraint.activate([
            timeLabel.widthAnchor.constraint(equalToConstant: 50),
            timeLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setupPostContentStackViewConstraints() {
        NSLayoutConstraint.activate([
            postContentStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 20),
            postContentStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -20),
            postContentStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
    
    private func setupBodyLabelConstraints() {
        NSLayoutConstraint.activate([
            bodyLabel.leadingAnchor.constraint(equalTo: postContentStackView.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: postContentStackView.trailingAnchor),
        ])
    }
    
    // MARK: - UI
    
    private func setupMainStackViewUI() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        mainStackView.alignment = .center
        mainStackView.customize(
            backgroundColor: .customAccentColor.withAlphaComponent(0.1),
            radiusSize: 8,
            borderColor: .customAccentColor,
            borderWidth: 1)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    private func setupAnnouncementAuthorStackViewUI() {
        announcementAuthorStackView.axis = .horizontal
        announcementAuthorStackView.spacing = 32
        announcementAuthorStackView.alignment = .top
        announcementAuthorStackView.distribution = .fillProportionally
    }
    
    private func setupAuthorInfoViewUI() {
        authorInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        authorInfoStackView.axis = .vertical
        authorInfoStackView.spacing = 8
    }
    
    private func setupBackgroundImageViewUI() {
        backgroundImageView.tintColor = .customAccentColor
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    }

    private func setupAuthorImageViewUI() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.authorImageTapped))
        authorImageView.addGestureRecognizer(gestureRecognizer)
        authorImageView.isUserInteractionEnabled = true
        
        authorImageView.translatesAutoresizingMaskIntoConstraints = false
        authorImageView.contentMode = .scaleAspectFill
        authorImageView.clipsToBounds = true
        authorImageView.layer.masksToBounds = true
        authorImageView.layer.cornerRadius = 30
        authorImageView.layer.borderColor = UIColor.customBackgroundColor.cgColor
        authorImageView.layer.borderWidth = 4
    }
    
    private func setupNamesStackViewUI() {
        namesStackView.axis = .vertical
        namesStackView.distribution = .fillProportionally
        namesStackView.alignment = .center
        namesStackView.spacing = 4
    }
    
    private func setupNameLabelUI() {
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .white
    }
    
    private func setupUsernameLabelUI() {
        usernameLabel.font = .systemFont(ofSize: 14)
        usernameLabel.textColor = .systemGray
    }
    
    private func setupSpoilerTagUI() {
        spoilerTagStackView.customize(
            backgroundColor: .customAccentColor,
            radiusSize: 8,
            borderColor: .clear,
            borderWidth: 0)
        spoilerTagStackView.isLayoutMarginsRelativeArrangement = true
        spoilerTagStackView.layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        spoilerLabel.font = .boldSystemFont(ofSize: 8)
        spoilerLabel.numberOfLines = 2
        spoilerLabel.textColor = .black
        spoilerLabel.textAlignment = NSTextAlignment(.center)
    }
    
    private func setupTimeLabelUI() {
        timeLabel.font = .systemFont(ofSize: 14)
        timeLabel.textColor = .white
        timeLabel.textAlignment = NSTextAlignment(.center)
    }
    
    private func setupPostContentStackViewUI() {
        postContentStackView.axis = .vertical
        postContentStackView.spacing = 16
        postContentStackView.alignment = .center
        postContentStackView.distribution = .fillProportionally
    }
    
    private func setupHeaderLabelUI() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.postHeaderOrBodyTapped))
        headerLabel.addGestureRecognizer(gestureRecognizer)
        headerLabel.isUserInteractionEnabled = true

        headerLabel.font = .boldSystemFont(ofSize: 16)
        headerLabel.textColor = .white
        headerLabel.numberOfLines = 0
        headerLabel.textAlignment = NSTextAlignment(.center)
    }
    
    private func setupBodyLabelUI() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.postHeaderOrBodyTapped))
        bodyLabel.addGestureRecognizer(gestureRecognizer)
        bodyLabel.isUserInteractionEnabled = true
        
        bodyLabel.font = .systemFont(ofSize: 14)
        bodyLabel.textColor = .white
        bodyLabel.numberOfLines = 0
        bodyLabel.lineBreakMode = .byWordWrapping
        bodyLabel.textAlignment = NSTextAlignment(.center)
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
        stackView.spacing = 4
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = buttonColor
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .customAccentColor
        label.text = labelText
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: action)
        stackView.addGestureRecognizer(gestureRecognizer)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
    }
    
    // MARK: - Private Methods
    
    @objc private func authorImageTapped(sender: UITapGestureRecognizer) {

        if sender.state == .ended {
            UIView.animate(withDuration: 0.1, animations: {
                self.authorImageView.alpha = 0.2
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.authorImageView.alpha = 1.0
                }
            }
            print("image tapped, go to profile page")
        }
        // fix force unwrap
        let profileSceneViewController = UIHostingController(
            rootView: ProfileSceneView(
                profileSceneViewModel: ProfileSceneViewModel(
                    profileOwnerInfoID: postInfo!.authorID,
                    userInfo: viewModel!.userInfo)).background(Color(uiColor: .customBackgroundColor)))
        navigationController?.pushViewController(profileSceneViewController, animated: true)
    }
    
    @objc private func postHeaderOrBodyTapped(sender: UITapGestureRecognizer) {
        
        guard let postInfo else { return }
        
        if sender.state == .ended {
            UIView.animate(withDuration: 0.1, animations: {
                self.headerLabel.alpha = 0.5
                self.bodyLabel.alpha = 0.5
            }) { _ in
                UIView.animate(withDuration: 0.1) { [self] in
                    self.headerLabel.alpha = 1.0
                    self.bodyLabel.alpha = 1.0
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
        
        guard let postInfo else { return }
        
        if sender.state == .ended {
            UIView.animate(withDuration: 0.1, animations: {
                self.commentButtonImageView.alpha = 0.2
                self.commentButtonLabel.alpha = 0.2
            }) { _ in
                UIView.animate(withDuration: 0.1) { [self] in
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
        }
    }
    
    func retrieveImage() {
        authorImageView.image = UIImage(systemName: "person.fill")
        authorImageView.tintColor = .customAccentColor
        
        guard let imageName = postInfo?.authorID.uuidString else { return }
        
        if let cachedImage = CacheManager.instance.get(name: imageName) {
            authorImageView.image = cachedImage
        } else {
            let database = Firestore.firestore()
            database.collection("UserInfo").document((postInfo?.authorID.uuidString)!).getDocument { document, error in
                if error == nil && document != nil {
                    let imagePath = document?.data()?["image"] as? String
                    self.fetchImage(imagePath ?? "")
                    print("fetched")
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
                    CacheManager.instance.add(image: fetchedImage, name: self.postInfo?.authorID.uuidString ?? "")
                    print("fetchedfdf")
                }
            } else {
                print("Error fetching image:", error?.localizedDescription ?? "Unknown error")
            }
        }
    }

    private func toggleLikePost() {
        
        guard let postInfo else { return }
        
        guard let viewModel else { return }
 
        let database = Firestore.firestore()
        
        let userReference = database.collection("UserInfo").document(viewModel.userInfo.id.uuidString)
        let postReference = database.collection("PostInfo").document(postInfo.id.uuidString)
        
        let isLiked = viewModel.userInfo.likedPosts.contains(postInfo.id)
        
        if isLiked {
            userReference.updateData([
                "likedPosts": FieldValue.arrayRemove([postInfo.id.uuidString])
            ]) { [self] error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                postReference.updateData([
                    "likedBy": FieldValue.arrayRemove([viewModel.userInfo.id.uuidString])
                ]) { error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                }
                updateLikeButtonUI(isLiked: viewModel.userInfo.likedPosts.contains(postInfo.id))
            }
        } else {
            userReference.updateData([
                "likedPosts": FieldValue.arrayUnion([postInfo.id.uuidString])
            ]) { [self] error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                postReference.updateData([
                    "likedBy": FieldValue.arrayUnion([viewModel.userInfo.id.uuidString])
                ]) {  error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                }
                updateLikeButtonUI(isLiked: viewModel.userInfo.likedPosts.contains(postInfo.id))
            }
        }
    }
}

extension AnnouncementTableViewCell: PostDetailsSceneViewDelegateForAnnouncement {
    func updateLikeButtonUI(isLiked: Bool) {
        DispatchQueue.main.async {
            let imageName = isLiked ? "heart.fill" : "heart"
            
            self.likeButtonImageView.image = UIImage(systemName: imageName)?.withTintColor(.customLikeButtonColor)
        }
    }
}
