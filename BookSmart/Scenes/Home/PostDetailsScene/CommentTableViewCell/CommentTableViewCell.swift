//
//  CommentTableViewCell.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 22.01.24.
//

import UIKit
import Firebase

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
        setupBodyLabelUI()
        setupLikeCommentStackViewUI()
        setupLikeStackViewUI()
        setupCommentStackViewUI()
    }
    
    func configureCell(viewModel: PostDetailsSceneViewModel, commentInfo: CommentInfo.ID) {
        
        self.commentInfo = self.viewModel?.getCommentInfo(for: commentInfo)
        self.viewModel = viewModel
        self.viewModel?.commentInfoListener()
        
        updateCellUI(with: (self.viewModel?.getCommentInfo(for: commentInfo)))
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
    
    private func setupBodyLabelUI() {
        bodyTextView.font = .systemFont(ofSize: 14)
        bodyTextView.textColor = .white
        bodyTextView.backgroundColor = .clear
        bodyTextView.isEditable = false
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
        
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .customAccentColor
        label.text = labelText
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: action)
        stackView.addGestureRecognizer(gestureRecognizer)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
    }
    
    // MARK: - Private Methods
    
    // MARK: - Animations
    @objc private func authorImageOrNameTapped(sender: UITapGestureRecognizer) {
        
        #warning("go to profile")
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
            print("image tapped, go to profile page")
        }
    }
    
    @objc private func likeButtonTapped(sender: UITapGestureRecognizer) {
        
        viewModel?.toggleLikeComment(commentInfo: commentInfo)
        
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
    
    private func updateCellUI(with commentInfo: CommentInfo?) {
        DispatchQueue.main.async { [self] in
            authorImageView.image = UIImage(systemName: "person.fill")
            nameLabel.text = commentInfo?.authorID.uuidString
            timeLabel.text = viewModel?.timeAgoString(from: commentInfo?.commentTime ?? Date())
            bodyTextView.text = commentInfo?.body
        }
    }

    private func updateLikeButtonUI(isLiked: Bool) {
        DispatchQueue.main.async {
            let imageName = isLiked ? "heart.fill" : "heart"
            
            self.likeButtonImageView.image = UIImage(systemName: imageName)?.withTintColor(.customLikeButtonColor)
            self.likeButtonLabel.textColor = .customLikeButtonColor
        }
    }
}
