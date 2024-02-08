
import UIKit
import SwiftUI
import Firebase
import FirebaseStorage

class CommentTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let mainStackView = UIStackView()
    
    private let authorInfoStackView = UIStackView()
    private let authorImageView = UIImageView()
    private let nameLabel = UILabel()
    
    private let timeLabel = UILabel()
    
    private let commentContentStackView = UIStackView()
    private let bodyTextView = UITextView()
    
    private let likeCommentStackView = UIStackView()
    
    private let likeStackView = UIStackView()
    private let likeButtonImageView = UIImageView()
    private let likeButtonLabel = UILabel()
    
    private let commentStackView = UIStackView()
    private let commentButtonImageView = UIImageView()
    private let commentButtonLabel = UILabel()
    
    var viewModel: PostDetailsSceneViewModel?
    
    var commentInfo: CommentInfo?
    
    var authorInfo: UserInfo?
    
    weak var navigationController: UINavigationController?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
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
        timeLabel.text = nil
        bodyTextView.text = nil
    }
    
    // MARK: - Setup Subviews, Constraints, UI
    
    private func setupSubViews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(authorInfoStackView)
        authorInfoStackView.addArrangedSubview(authorImageView)
        authorInfoStackView.addArrangedSubview(nameLabel)
        authorInfoStackView.addArrangedSubview(timeLabel)
        mainStackView.addArrangedSubview(commentContentStackView)
        commentContentStackView.addArrangedSubview(bodyTextView)
        mainStackView.addArrangedSubview(likeCommentStackView)
        likeCommentStackView.addArrangedSubview(likeStackView)
        likeCommentStackView.addArrangedSubview(commentStackView)
    }
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
        setupAuthorInfoStackViewConstraints()
        setupAuthorImageViewConstraints()
        setupTimeLabelConstraints()
        setupCommentContentStackViewConstraints()
        setupBodyLabelConstraints()
    }
    
    private func setupUI() {
        setupMainStackViewUI()
        setupAuthorInfoStackViewUI()
        setupAuthorImageViewUI()
        setupNameLabelUI()
        setupTimeLabelUI()
        setupCommentContentStackViewUI()
        setupBodyTextViewUI()
        setupLikeCommentStackViewUI()
        setupLikeStackViewUI()
        setupCommentStackViewUI()
    }
    
    func configureCell(viewModel: PostDetailsSceneViewModel, commentInfo: CommentInfo) {
        self.viewModel = viewModel
        self.commentInfo = commentInfo
        
        getAuthorInfo(with: commentInfo.authorID) { [self] authorInfo in
            self.authorInfo = authorInfo
            
            let isLiked = commentInfo.likedBy.contains(viewModel.userInfo.id)
            authorImageView.image = UIImage(systemName: "person.fill")
            nameLabel.text = authorInfo?.userName
            timeLabel.text = MethodsManager.shared.timeAgoString(from: commentInfo.commentTime)
            bodyTextView.text = commentInfo.body
            updateLikeButtonUI(isLiked: isLiked)
            retrieveImage()
        }
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
            authorInfoStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 20),
            authorInfoStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupAuthorImageViewConstraints() {
        NSLayoutConstraint.activate([
            authorImageView.widthAnchor.constraint(equalToConstant: 40),
            authorImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupTimeLabelConstraints() {
        NSLayoutConstraint.activate([
            timeLabel.widthAnchor.constraint(equalToConstant: 30),
            timeLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupCommentContentStackViewConstraints() {
        NSLayoutConstraint.activate([
            commentContentStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 33),
            commentContentStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 20),
            commentContentStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupBodyLabelConstraints() {
        NSLayoutConstraint.activate([
            bodyTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 33),
            bodyTextView.leadingAnchor.constraint(equalTo: commentContentStackView.leadingAnchor),
            bodyTextView.trailingAnchor.constraint(equalTo: commentContentStackView.trailingAnchor),
        ])
    }
    
    // MARK: - UI
    
    private func setupMainStackViewUI() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
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
        authorInfoStackView.spacing = 8
    }
    
    private func setupAuthorImageViewUI() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.authorImageOrNameTapped))
        authorImageView.addGestureRecognizer(gestureRecognizer)
        authorImageView.isUserInteractionEnabled = true
        
        authorImageView.translatesAutoresizingMaskIntoConstraints = false
        authorImageView.contentMode = .scaleAspectFill
        authorImageView.clipsToBounds = true
        authorImageView.layer.cornerRadius = 20
        authorImageView.layer.borderColor = UIColor.customAccentColor.withAlphaComponent(0.5).cgColor
        authorImageView.layer.borderWidth = 2
    }
    
    private func setupNameLabelUI() {
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .white
    }
    
    private func setupTimeLabelUI() {
        timeLabel.font = .systemFont(ofSize: 14)
        timeLabel.textColor = .white
    }
    
    private func setupCommentContentStackViewUI() {
        commentContentStackView.axis = .vertical
        commentContentStackView.spacing = 0
        commentContentStackView.alignment = .leading
        commentContentStackView.distribution = .fillProportionally
    }
    
    private func setupBodyTextViewUI() {
        bodyTextView.font = .systemFont(ofSize: 14)
        bodyTextView.textColor = .white
        bodyTextView.backgroundColor = .clear
        bodyTextView.isEditable = false
        bodyTextView.isScrollEnabled = false
    }
    
    private func setupLikeCommentStackViewUI() {
        likeCommentStackView.axis = .horizontal
        likeCommentStackView.distribution = .fillProportionally
        likeCommentStackView.alignment = .center
        likeCommentStackView.spacing = 32
    }
    
    private func setupLikeStackViewUI() {
        likeButtonImageView.image = UIImage(systemName: "heart")
        setupLikeCommentStackViewUI(
            likeStackView,
            imageView: likeButtonImageView,
            label: likeButtonLabel,
            labelText: "Like",
            buttonColor: .customLikeButtonColor,
            action: #selector(likeButtonTapped))
    }
    
    private func setupCommentStackViewUI() {
        commentButtonImageView.image = UIImage(systemName: "text.bubble")
        setupLikeCommentStackViewUI(
            commentStackView,
            imageView: commentButtonImageView,
            label: commentButtonLabel,
            labelText: "Comment",
            buttonColor: .customCommentButtonColor,
            action: #selector(commentButtonTapped))
    }
    
    private func setupLikeCommentStackViewUI(_ stackView: UIStackView, imageView: UIImageView, label: UILabel, labelText: String, buttonColor: UIColor, action: Selector) {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
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
    
    // MARK: - Button Methods
    @objc private func authorImageOrNameTapped(sender: UITapGestureRecognizer) {
        
        let profileSceneView = UIHostingController(rootView: ProfileSceneView(
            profileSceneViewModel: ProfileSceneViewModel(
                profileOwnerInfoID: authorInfo!.id,
                userInfo: viewModel!.userInfo)).background(Color(uiColor: .customBackgroundColor)))
        navigationController?.pushViewController(profileSceneView, animated: true)
        
        if sender.state == .ended {
            UIView.animate(withDuration: 0.1, animations: {
                self.authorImageView.alpha = 0.2
                self.nameLabel.alpha = 0.2
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.authorImageView.alpha = 1.0
                    self.nameLabel.alpha = 1.0
                }
            }
        }
    }
    
    @objc private func likeButtonTapped(sender: UITapGestureRecognizer) {
        
        toggleLikeComment()
        
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
                UIView.animate(withDuration: 0.1) { [self] in
                    self.commentButtonImageView.alpha = 1.0
                    self.commentButtonLabel.alpha = 1.0
                }
            }
        }
    }
    
//    private func updateCellUI(with commentInfo: CommentInfo?) {
//        
//        DispatchQueue.main.async { [self] in
//            let authorInfo = getAuthorInfo(with: commentInfo?.authorID ?? UUID())
//            authorImageView.image = UIImage(systemName: "person.fill")
//            nameLabel.text = authorInfo?.userName
//            timeLabel.text = viewModel?.timeAgoString(from: commentInfo?.commentTime ?? Date())
//            bodyTextView.text = commentInfo?.body
//        }
//    }
    
    
    func toggleLikeComment() {
        
        guard let commentInfo = commentInfo else { return }
        
        let database = Firestore.firestore()
        
        let commentReference = database.collection("CommentInfo").document(commentInfo.id.uuidString)
        
        let isLiked = commentInfo.likedBy.contains(viewModel!.userInfo.id)
        
        updateLikeButtonUI(isLiked: !isLiked)
        
        if isLiked {
            commentReference.updateData([
                "likedBy": FieldValue.arrayRemove([viewModel?.userInfo.id.uuidString ?? ""])
            ]) { [self] error in
                if let error = error {
                    print("Error removing user from likedBy in comment: \(error.localizedDescription)")
                    return
                }
                
                if let indexOfUser = commentInfo.likedBy.firstIndex(of: viewModel!.userInfo.id) {
                    self.commentInfo?.likedBy.remove(at: indexOfUser)
                    
                    DispatchQueue.main.async {
                        self.updateLikeButtonUI(isLiked: false)
                    }
                }
            }
        } else {
            commentReference.updateData([
                "likedBy": FieldValue.arrayUnion([viewModel?.userInfo.id.uuidString ?? ""])
            ]) { [self] error in
                if let error = error {
                    print("Error adding user to likedBy in comment: \(error.localizedDescription)")
                    return
                }
                
                self.commentInfo?.likedBy.append(viewModel!.userInfo.id)
                
                DispatchQueue.main.async {
                    self.updateLikeButtonUI(isLiked: true)
                }
            }
        }
    }
    
    func updateLikeButtonUI(isLiked: Bool) {
        DispatchQueue.main.async {
            let imageName = isLiked ? "heart.fill" : "heart"
            
            self.likeButtonImageView.image = UIImage(systemName: imageName)?.withTintColor(.customLikeButtonColor)
        }
    }
    
    func getAuthorInfo(with authorID: UserInfo.ID, completion: @escaping (UserInfo?) -> Void) {
        
        var authorInfo: UserInfo?
        
        let database = Firestore.firestore()
        let reference = database.collection("UserInfo")
        
        reference.getDocuments { [weak self] snapshot, error in
            
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching user information: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
            
            for document in snapshot.documents {
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
                    let quotesUsedData = data["quotesUsed"] as? [[String: String]]
                else {
                    print("Error parsing user data")
                    completion(nil)
                    continue
                }
                
                let badges = self.parseBadgesArray(badgesData)
                let quotesUsed = self.parseQuotesArray(quotesUsedData)
                let booksFinished = self.parseBooksFinishedArray(booksFinishedArray)
                
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
                    booksFinished: booksFinished,
                    quotesUsed: quotesUsed
                )
                authorInfo = userInfo
            }
            
            completion(authorInfo)
        }
    }
    
    private func parseBooksFinishedArray(_ booksFinishedArray: [[String: Any]]) -> [Book] {
        var booksFinished: [Book] = []
        
        for bookInfo in booksFinishedArray {
            if let title = bookInfo["title"] as? String,
               let authorName = bookInfo["authorName"] as? [String] {
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
    
    private func parseQuotesArray(_ quotesData: [[String: String]]) -> [Quote] {
        var quotes: [Quote] = []
        
        for quoteData in quotesData {
            if let text = quoteData["text"], let author = quoteData["author"] {
                let quote = Quote(text: text, author: author)
                quotes.append(quote)
            }
        }
        
        return quotes
    }
    
    func retrieveImage() {
        authorImageView.image = UIImage(systemName: "person.fill")
        authorImageView.tintColor = .customAccentColor
        
        guard let imageName = commentInfo?.authorID.uuidString else { return }
        
        if let cachedImage = CacheManager.instance.get(name: imageName) {
            authorImageView.image = cachedImage
        } else {
            let database = Firestore.firestore()
            database.collection("UserInfo").document((commentInfo?.authorID.uuidString)!).getDocument { document, error in
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
                    CacheManager.instance.add(image: fetchedImage, name: self.commentInfo?.authorID.uuidString ?? "")
                }
            } else {
                print("Error fetching image:", error?.localizedDescription ?? "Unknown error")
            }
        }
    }
}
