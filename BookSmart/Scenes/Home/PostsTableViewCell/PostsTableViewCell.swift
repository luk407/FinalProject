
import SwiftUI

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
    
    var viewModel: PostsScenesViewModel?
    
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
        setupNamesStackViewConstraints()
        setupSpoilerTagStackViewConstraints()
        setupTimeLabelConstraints()
        setupPostContentStackViewConstraints()
        setupBodyLabelConstraints()
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
        viewModel?.getAuthorInfo(with: postInfo!.authorID) { [self] authorInfo in
            self.authorInfo = authorInfo
            self.retrieveImage()
            
            nameLabel.text = "\(authorInfo?.displayName ?? "")"
            usernameLabel.text = "@\(authorInfo?.userName ?? "")"
        }
        
        let timeAgo = MethodsManager.shared.timeAgoString(from: postInfo?.postingTime ?? Date())
        
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
            authorInfoStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 20),
            authorInfoStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupAuthorImageViewConstraints() {
        NSLayoutConstraint.activate([
            authorImageView.widthAnchor.constraint(equalToConstant: 50),
            authorImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupNamesStackViewConstraints() {
        NSLayoutConstraint.activate([
            namesStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 20),
        ])
    }
    
    private func setupSpoilerTagStackViewConstraints() {
        NSLayoutConstraint.activate([
            spoilerTagStackView.widthAnchor.constraint(equalToConstant: 50),
            spoilerTagStackView.heightAnchor.constraint(equalToConstant: 25),
            spoilerLabel.widthAnchor.constraint(equalToConstant: 50)
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
            postContentStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 20),
            postContentStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -20),
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
        mainStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    private func setupAuthorInfoStackViewUI() {
        authorInfoStackView.axis = .horizontal
        authorInfoStackView.distribution = .fillProportionally
        authorInfoStackView.alignment = .center
        authorInfoStackView.spacing = 8
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
        namesStackView.spacing = 4
    }
    
    private func setupNameLabelUI() {
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .customAccentColor
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
        spoilerLabel.textColor = .customBackgroundColor
        spoilerLabel.textAlignment = NSTextAlignment(.center)
    }
    
    private func setupTimeLabelUI() {
        timeLabel.font = .systemFont(ofSize: 14)
        timeLabel.textColor = .customAccentColor
    }
    
    private func setupPostContentStackViewUI() {
        postContentStackView.axis = .vertical
        postContentStackView.spacing = 8
        postContentStackView.alignment = .leading
        postContentStackView.distribution = .fillProportionally
        postContentStackView.layoutIfNeeded()
    }
    
    private func setupHeaderLabelUI() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.postHeaderOrBodyTapped))
        headerLabel.addGestureRecognizer(gestureRecognizer)
        headerLabel.isUserInteractionEnabled = true
        
        headerLabel.font = .boldSystemFont(ofSize: 16)
        headerLabel.textColor = .customAccentColor
    }
    
    private func setupBodyLabelUI() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.postHeaderOrBodyTapped))
        bodyLabel.addGestureRecognizer(gestureRecognizer)
        bodyLabel.isUserInteractionEnabled = true
        
        bodyLabel.font = .systemFont(ofSize: 14)
        bodyLabel.textColor = .customAccentColor
        bodyLabel.numberOfLines = 5
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
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .customAccentColor
        label.text = labelText
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: action)
        stackView.addGestureRecognizer(gestureRecognizer)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            authorImageView.layer.borderColor = UIColor.customAccentColor.cgColor
        }
    }
    
    // MARK: - Button Methods
    @objc private func authorImageTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            MethodsManager.shared.fadeAnimation(elements: authorImageView) {
                self.navigateToProfileScene()
            }
        }
    }
    
    @objc private func postHeaderOrBodyTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            MethodsManager.shared.fadeAnimation(elements: headerLabel, bodyLabel) {
                self.navigateToPostDetailsScene()
            }
        }
    }
    
    @objc private func likeButtonTapped(sender: UITapGestureRecognizer) {
        toggleLikePost() { hasLiked in
            self.updateLikeButtonUI(isLiked: hasLiked)
        }
        
        if sender.state == .ended {
            MethodsManager.shared.fadeAnimation(elements: likeButtonImageView, likeButtonLabel)
        }
    }
    
    @objc private func commentButtonTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            MethodsManager.shared.fadeAnimation(elements: commentButtonImageView, commentButtonLabel) {
                self.navigateToPostDetailsScene()
            }
        }
    }
    
    @objc private func shareButtonTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            MethodsManager.shared.fadeAnimation(elements: shareButtonImageView, shareButtonLabel) {
                self.sharePost()
            }
        }
    }
    
    // MARK: - Button Actions
    private func navigateToProfileScene() {
        let profileSceneViewController = UIHostingController(
            rootView: ProfileSceneView(
                profileSceneViewModel: ProfileSceneViewModel(
                    profileOwnerInfoID: postInfo!.authorID,
                    userInfo: viewModel!.userInfo)).background(Color(uiColor: .customBackgroundColor)))
        navigationController?.pushViewController(profileSceneViewController, animated: true)
    }
    
    private func navigateToPostDetailsScene() {
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            let commentDetailsViewController = PostDetailsSceneView(
                viewModel: PostDetailsSceneViewModel(
                    userInfo: viewModel!.userInfo,
                    postInfo: postInfo!))
            navigationController.pushViewController(commentDetailsViewController, animated: true)
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
    
    // MARK: - Firebase Methods
    func retrieveImage() {
        authorImageView.tintColor = .customAccentColor
        
        guard let postInfoAuthorIDString = postInfo?.authorID.uuidString else { return }
        
        FirebaseManager.shared.retrieveImage(postInfoAuthorIDString) { retrievedImage in
            UIView.transition(with: self.authorImageView,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                self.authorImageView.image = retrievedImage
            },
                              completion: nil)
        }
    }
    
    private func toggleLikePost(completion: @escaping (Bool) -> Void) {
        guard let postInfo else { return }
        guard let viewModel else { return }
        
        FirebaseManager.shared.toggleLikePost(userInfoIDString: viewModel.userInfo.id.uuidString,
                                              postInfoIDString: postInfo.id.uuidString) { hasLiked in
            completion(hasLiked)
        }
    }
    
    // MARK: - Update UI
    private func updateLikeButtonUI(isLiked: Bool) {
        DispatchQueue.main.async {
            let imageName = isLiked ? "heart.fill" : "heart"
            self.likeButtonImageView.image = UIImage(systemName: imageName)
        }
    }
}
