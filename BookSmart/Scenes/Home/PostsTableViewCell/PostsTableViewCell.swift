//
//  TableViewCell.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 19.01.24.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseStorage

final class PostsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let mainStackView = UIStackView()
    
    private let authorInfoStackView = UIStackView()
    
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
    
    var viewModel: HomeSceneViewModel?
    
    var postInfo: PostInfo?
    
    var authorInfo: UserInfo?
    
    weak var navigationController: UINavigationController?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
        setupConstraints()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorImageView.image = nil
        nameLabel.text = nil
        usernameLabel.text = nil
        timeLabel.text = nil
        headerLabel.text = nil
        bodyLabel.text = nil
        spoilerLabel.text = nil
    }
    
    // MARK: - Setup Subviews, Constraints, UI
    
    private func setupSubViews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(authorInfoStackView)
        authorInfoStackView.addArrangedSubview(authorImageView)
        authorInfoStackView.addArrangedSubview(namesStackView)
        namesStackView.addArrangedSubview(nameLabel)
        namesStackView.addArrangedSubview(usernameLabel)
        authorInfoStackView.addArrangedSubview(spoilerTagStackView)
        spoilerTagStackView.addArrangedSubview(spoilerLabel)
        authorInfoStackView.addArrangedSubview(timeLabel)
        mainStackView.addArrangedSubview(postContentStackView)
        postContentStackView.addArrangedSubview(headerLabel)
        postContentStackView.addArrangedSubview(bodyLabel)
        mainStackView.addArrangedSubview(likeCommentShareStackView)
        likeCommentShareStackView.addArrangedSubview(likeStackView)
        likeCommentShareStackView.addArrangedSubview(commentStackView)
        likeCommentShareStackView.addArrangedSubview(shareStackView)
    }
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
        setupAuthorInfoStackViewConstraints()
        setupAuthorImageViewConstraints()
        setupSpoilerTagStackViewConstraints()
        setupTimeLabelConstraints()
        setupPostContentStackViewConstraints()
        setupBodyLabelConstraints()
        //setupLikeCommentShareStackViewConstrains()
    }
    
    private func setupUI() {
        setupMainStackViewUI()
        setupAuthorInfoStackViewUI()
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

        DispatchQueue.main.async { [self] in
            getAuthorInfo(with: postInfo!.authorID) { [self] authorInfo in
                self.authorInfo = authorInfo
                self.retrieveImage()
                
                nameLabel.text = "\(authorInfo?.displayName ?? "")"
                usernameLabel.text = "@\(authorInfo?.userName ?? "")"
            }
        }
        
        let timeAgo = timeAgoString(from: postInfo?.postingTime ?? Date())
        
        timeLabel.text = timeAgo
        headerLabel.text = postInfo?.header
        bodyLabel.text = postInfo?.body
        setupSpoilerTagUI()
        let isLiked = viewModel?.userInfo.likedPosts.contains(postInfo!.id)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
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
    
    private func setupAuthorInfoStackViewConstraints() {
        NSLayoutConstraint.activate([
            authorInfoStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 10),
            authorInfoStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -10),
        ])
    }
    
    private func setupAuthorImageViewConstraints() {
        NSLayoutConstraint.activate([
            authorImageView.widthAnchor.constraint(equalToConstant: 50),
            authorImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupSpoilerTagStackViewConstraints() {
        NSLayoutConstraint.activate([
            spoilerTagStackView.widthAnchor.constraint(equalToConstant: 50),
            spoilerTagStackView.heightAnchor.constraint(equalToConstant: 25)
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
            postContentStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 10),
            postContentStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -10),
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
        mainStackView.spacing = 16
        mainStackView.alignment = .center
        mainStackView.customize(
            backgroundColor: .customAccentColor.withAlphaComponent(0.1),
            radiusSize: 8,
            borderColor: .clear,
            borderWidth: 1)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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
    
    private func setupSpoilerTagUI() {
        spoilerTagStackView.customize(
            backgroundColor: .customAccentColor,
            radiusSize: 8,
            borderColor: .clear,
            borderWidth: 0)
        spoilerTagStackView.isLayoutMarginsRelativeArrangement = true
        spoilerTagStackView.layoutMargins = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        spoilerLabel.text = postInfo?.spoilersAllowed ?? false ? "SPOILERS" : "SPOILER\nFREE"
        spoilerLabel.font = .boldSystemFont(ofSize: 8)
        spoilerLabel.numberOfLines = 2
        spoilerLabel.textColor = .black
        spoilerLabel.textAlignment = NSTextAlignment(.center)
    }
    
    private func setupTimeLabelUI() {
        timeLabel.font = .systemFont(ofSize: 14)
        timeLabel.textColor = .white
    }
    
    private func setupPostContentStackViewUI() {
        postContentStackView.axis = .vertical
        postContentStackView.spacing = 16
        postContentStackView.alignment = .leading
        postContentStackView.distribution = .fillProportionally
    }
    
    private func setupHeaderLabelUI() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.postHeaderOrBodyTapped))
        headerLabel.addGestureRecognizer(gestureRecognizer)
        headerLabel.isUserInteractionEnabled = true

        headerLabel.font = .boldSystemFont(ofSize: 16)
        headerLabel.textColor = .white
    }
    
    private func setupBodyLabelUI() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.postHeaderOrBodyTapped))
        bodyLabel.addGestureRecognizer(gestureRecognizer)
        bodyLabel.isUserInteractionEnabled = true
        
        bodyLabel.font = .systemFont(ofSize: 14)
        bodyLabel.textColor = .white
        bodyLabel.numberOfLines = 0
        bodyLabel.lineBreakMode = .byWordWrapping
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
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .customAccentColor
        label.text = labelText
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: action)
        stackView.addGestureRecognizer(gestureRecognizer)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
    }
    
    // MARK: - Private Methods
    
    private func timeAgoString(from date: Date) -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: currentDate)
        
        if let years = components.year, years > 0 {
            return "\(years)y"
        } else if let months = components.month, months > 0 {
            return "\(months)m"
        } else if let days = components.day, days > 0 {
            return "\(days)d"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours)h"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes)m"
        } else {
            return "Now"
        }
    }
    
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
                    
                    if let navigationController = self.window?.rootViewController as? UINavigationController {
                        //fix force unwrap
                        let commentDetailsViewController = PostDetailsSceneView(
                            viewModel: PostDetailsSceneViewModel(
                                userInfo: viewModel!.userInfo,
                                postInfo: postInfo))
                        navigationController.pushViewController(commentDetailsViewController, animated: true)
                    }
                }
            }
            print("post tapped, go to post details page")
        }
    }
    
    @objc private func likeButtonTapped(sender: UITapGestureRecognizer) {
        
        toggleLikePost()
        
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
                    
                    if let navigationController = self.window?.rootViewController as? UINavigationController {
                        // fix force unwrap
                        let commentDetailsViewController = PostDetailsSceneView(
                            viewModel: PostDetailsSceneViewModel(
                                userInfo: viewModel!.userInfo,
                                postInfo: postInfo))
                        navigationController.pushViewController(commentDetailsViewController, animated: true)
                    }
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
    
    func getAuthorInfo(with authorID: UserInfo.ID, completion: @escaping (UserInfo?) -> Void) {

        let database = Firestore.firestore()
        let reference = database.collection("UserInfo").whereField("id", isEqualTo: authorID.uuidString)

            reference.getDocuments { snapshot, error in
            
            if let error = error {
                print("Error fetching user information: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
                
                if let document = snapshot.documents.first {
                    let data = document.data()
                    
                    guard
                        let id = data["id"] as? String,
                        let username = data["username"] as? String,
                        let email = data["email"] as? String,
                        let password = data["password"] as? String,
                        let displayName = data["displayName"] as? String,
                        let registrationDateTimestamp = data["registrationDate"] as? Timestamp,
                        let bio = data["bio"] as? String,
                        let image = data["image"] as? String,
                        let badgesData = data["badges"] as? [[String: String]],
                        let posts = data["posts"] as? [String],
                        let comments = data["comments"] as? [String],
                        let likedPosts = data["likedPosts"] as? [String],
                        let connections = data["connections"] as? [String],
                        let booksFinishedArray = data["booksFinished"] as? [[String: Any]],
                        let quotesUsed = data["quotesUsed"] as? [Quote]
                    else {
                        print("Error parsing user data")
                        return
                    }
                    
                    let badges = self.parseBadgesArray(badgesData)
                    
                    let userInfo = UserInfo(
                        id: UUID(uuidString: id) ?? UUID(),
                        userName: username,
                        email: email,
                        password: password,
                        displayName: displayName,
                        registrationDate: registrationDateTimestamp.dateValue(),
                        bio: bio,
                        image: image,
                        badges: badges,
                        posts: posts.map { UUID(uuidString: $0) ?? UUID() },
                        comments: comments.map { UUID(uuidString: $0) ?? UUID() },
                        likedPosts: likedPosts.map { UUID(uuidString: $0) ?? UUID() },
                        connections: connections.map { UUID(uuidString: $0) ?? UUID() },
                        booksFinished: self.parseBooksFinishedArray(booksFinishedArray),
                        quotesUsed: quotesUsed
                    )
                    completion(userInfo)
                }
        }
    }
    
    private func parseBooksFinishedArray(_ booksFinishedArray: [[String: Any]]) -> [Book] {
        var booksFinished: [Book] = []
        
        for bookInfo in booksFinishedArray {
            if let title = bookInfo["title"] as? String,
               let authorName = bookInfo["author"] as? [String] {
                let book = Book(title: title, authorName: authorName)
                booksFinished.append(book)
            }
        }
        return booksFinished
    }
    
    private func parseBadgesArray(_ badgesData: [[String: String]]) -> [BadgeInfo] {
        
        var badges: [BadgeInfo] = []

        for badgeInfo in badgesData {
            if
                let categoryString = badgeInfo["category"],
                let category = BadgeCategory(rawValue: categoryString),
                let typeString = badgeInfo["type"],
                let type = BadgeType(rawValue: typeString)
            {
                let badge = BadgeInfo(category: category, type: type)
                badges.append(badge)
            }
        }
        return badges
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

    private func updateLikeButtonUI(isLiked: Bool) {
        DispatchQueue.main.async {
            let imageName = isLiked ? "heart.fill" : "heart"
            
            self.likeButtonImageView.image = UIImage(systemName: imageName)
            self.likeButtonLabel.textColor = .customLikeButtonColor
        }
    }
}
