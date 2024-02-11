
import SwiftUI

final class CommentTableViewCell: UITableViewCell {
    
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
        if sender.state == .ended {
            MethodsManager.shared.fadeAnimation(elements: authorImageView, nameLabel) {
                self.navigateToProfileScene()
            }
        }
    }
    
    @objc private func likeButtonTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            MethodsManager.shared.fadeAnimation(elements: likeButtonImageView, likeButtonLabel) {
                self.toggleLikeComment()
            }
        }
    }
    
    @objc private func commentButtonTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            MethodsManager.shared.fadeAnimation(elements: commentButtonImageView, commentButtonLabel)
        }
    }

    // MARK: - Button Actions
    
    func toggleLikeComment() {
        guard let viewModel else { return }
        guard let commentInfo else { return }
        
        FirebaseManager.shared.toggleLikeComment(commentInfo: commentInfo, userInfoID: viewModel.userInfo.id) { isLiked in
            if !isLiked {
                if let indexOfUser = commentInfo.likedBy.firstIndex(of: self.viewModel!.userInfo.id) {
                    self.commentInfo?.likedBy.remove(at: indexOfUser)
                }
            } else {
                self.commentInfo?.likedBy.append(self.viewModel!.userInfo.id)
            }
            
            self.updateLikeButtonUI(isLiked: isLiked)
        }
    }
    
    func updateLikeButtonUI(isLiked: Bool) {
        DispatchQueue.main.async {
            let imageName = isLiked ? "heart.fill" : "heart"
            
            self.likeButtonImageView.image = UIImage(systemName: imageName)?.withTintColor(.customLikeButtonColor)
        }
    }
    
    private func navigateToProfileScene() {
        let profileSceneView = UIHostingController(rootView: ProfileSceneView(
            profileSceneViewModel: ProfileSceneViewModel(
                profileOwnerInfoID: authorInfo!.id,
                userInfo: viewModel!.userInfo)).background(Color(uiColor: .customBackgroundColor)))
        navigationController?.pushViewController(profileSceneView, animated: true)
    }
    
    // MARK: - Firebase Methods
    
    func getAuthorInfo(with authorID: UserInfo.ID, completion: @escaping (UserInfo?) -> Void) {
        FirebaseManager.shared.getAuthorInfo(with: authorID) { authorInfo in
            completion(authorInfo)
        }
    }
    
    func retrieveImage() {
        authorImageView.tintColor = .customAccentColor
        
        guard let authorIDString = commentInfo?.authorID.uuidString else { return }
        
        FirebaseManager.shared.retrieveImage(authorIDString) { commentAuthorImage in
            UIView.transition(with: self.authorImageView,
                                      duration: 0.3,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                          self.authorImageView.image = commentAuthorImage
                                      },
                                      completion: nil)
        }
    }
    
}
