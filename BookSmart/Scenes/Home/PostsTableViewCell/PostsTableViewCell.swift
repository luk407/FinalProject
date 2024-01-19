//
//  TableViewCell.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 19.01.24.
//

import UIKit
import SwiftUI

final class PostsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let mainStackView = UIStackView()
    
    private let authorInfoStackView = UIStackView()
    
    private let authorImageView = UIImageView()
    
    private let namesStackView = UIStackView()
    
    private let nameLabel = UILabel()
    
    private let usernameLabel = UILabel()
    
    private let timeLabel = UILabel()
    
    private let postContentStackView = UIStackView()
    
    private let headerLabel = UILabel()
    
    private let bodyLabel = UILabel()
    
    private let interactionStackView = UIStackView()
    
    private let likeButton = UIButton()
    
    private let commentButton = UIButton()
    
    private let shareButton = UIButton()
    
    private var userInfo: UserInfo?
    
    private var postInfo: PostInfo?

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
        setupConstraints()
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubViews()
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
        bodyLabel.text = nil
    }
    
    // MARK: - Setup Subviews, Constraints, UI

    private func setupSubViews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(authorInfoStackView)
        authorInfoStackView.addArrangedSubview(authorImageView)
        authorInfoStackView.addArrangedSubview(namesStackView)
        namesStackView.addArrangedSubview(nameLabel)
        namesStackView.addArrangedSubview(usernameLabel)
        authorInfoStackView.addArrangedSubview(timeLabel)
        mainStackView.addArrangedSubview(postContentStackView)
        postContentStackView.addArrangedSubview(headerLabel)
        postContentStackView.addArrangedSubview(bodyLabel)
        mainStackView.addArrangedSubview(interactionStackView)
        interactionStackView.addArrangedSubview(likeButton)
        interactionStackView.addArrangedSubview(commentButton)
        interactionStackView.addArrangedSubview(shareButton)
    }
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
        setupAuthorInfoStackViewConstraints()
        setupAuthorImageViewConstraints()
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
        setupTimeLabelUI()
        setupPostContentStackViewUI()
        setupHeaderLabelUI()
        setupBodyLabelUI()
        setupInteractionStackViewUI()
        setupLikeButtonUI()
        setupCommentButtonUI()
        setupShareButtonUI()
    }
    
    func configureCell(userInfo: UserInfo, post: PostInfo) {
        #warning("fetch real user image")
        self.userInfo = userInfo
        self.postInfo = post
        
        let timeAgo = timeAgoString(from: post.postingTime)
        
        authorImageView.image = UIImage(systemName: "person.fill")?.withTintColor(.customAccentColor)
        nameLabel.text = "placeHolderName"
        usernameLabel.text = "@placeholderUsename"
        timeLabel.text = timeAgo
        headerLabel.text = post.header
        bodyLabel.text = post.body
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    // MARK: - Constraints
    
    private func setupMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
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
            authorImageView.widthAnchor.constraint(equalToConstant: 70),
            authorImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setupTimeLabelConstraints() {
        NSLayoutConstraint.activate([
            timeLabel.widthAnchor.constraint(equalToConstant: 20),
            timeLabel.heightAnchor.constraint(equalToConstant: 20)
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
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.alignment = .center
        mainStackView.customize(backgroundColor: .clear, radiusSize: 8, borderColor: .customAccentColor.withAlphaComponent(0.5), borderWidth: 2)
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
        authorImageView.layer.cornerRadius = 35
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
        bodyLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private func setupInteractionStackViewUI() {
        interactionStackView.axis = .horizontal
        interactionStackView.distribution = .fillEqually
        interactionStackView.alignment = .center
        interactionStackView.spacing = 16
    }
    
    private func setupLikeButtonUI() {
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.customLikeButtonColor
        
        let label = UILabel()
        label.text = "Like"
        label.textColor = UIColor.customLikeButtonColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        likeButton.addSubview(imageView)
        likeButton.addSubview(label)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: 8),
            imageView.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            label.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
        ])
    }
    
    private func setupCommentButtonUI() {
        commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        
        let imageView = UIImageView(image: UIImage(systemName: "text.bubble.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.customCommentButtonColor
        
        let label = UILabel()
        label.text = "Comment"
        label.textColor = UIColor.customCommentButtonColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        commentButton.addSubview(imageView)
        commentButton.addSubview(label)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: commentButton.leadingAnchor, constant: 8),
            imageView.centerYAnchor.constraint(equalTo: commentButton.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            label.centerYAnchor.constraint(equalTo: commentButton.centerYAnchor),
        ])
    }
    
    private func setupShareButtonUI() {
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        
        let imageView = UIImageView(image: UIImage(systemName: "square.and.arrow.up.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.customCommentButtonColor
        
        let label = UILabel()
        label.text = "Share"
        label.textColor = UIColor.customCommentButtonColor
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        shareButton.addSubview(imageView)
        shareButton.addSubview(label)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: 8),
            imageView.centerYAnchor.constraint(equalTo: shareButton.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 4),
            label.centerYAnchor.constraint(equalTo: shareButton.centerYAnchor),
        ])
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
        #warning("changee")
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
    }
    
    @objc private func postHeaderOrBodyTapped(sender: UITapGestureRecognizer) {
        #warning("changee")
        if sender.state == .ended {
            UIView.animate(withDuration: 0.1, animations: {
                self.headerLabel.alpha = 0.5
                self.bodyLabel.alpha = 0.5
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.headerLabel.alpha = 1.0
                    self.bodyLabel.alpha = 1.0
                }
            }
            print("post tapped, go to post details page")
        }
    }
    
    @objc private func likeButtonTapped() {
        print("Like")
    }
    
    @objc private func commentButtonTapped() {
        print("Comment")
    }
    
    @objc private func shareButtonTapped() {
        print("Share")
    }
}
