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
    
    private let postContentStackView = UIStackView()
    
    private let headerLabel = UILabel()
    
    private let bodyLabel = UILabel()
    
    private let interactionStackView = UIHostingController(rootView: InteractionStackView())

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        selectionStyle = .none
        setupSubViews()
        setupConstraints()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorImageView.image = nil
        nameLabel.text = nil
        usernameLabel.text = nil
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
        mainStackView.addArrangedSubview(postContentStackView)
        postContentStackView.addArrangedSubview(headerLabel)
        postContentStackView.addArrangedSubview(bodyLabel)
        //mainStackView.addArrangedSubview(interactionStackView.view)
    }
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
        setupAuthorInfoStackViewConstraints()
        setupAuthorImageViewConstraints()
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
        setupPostContentStackViewUI()
        setupHeaderLabelUI()
        setupBodyLabelUI()
    }
    
    func configureCell(with post: PostInfo) {
        #warning("fetch real user image")
        authorImageView.image = UIImage(systemName: "person.fill")
        nameLabel.text = "placeHolderName"
        usernameLabel.text = "@placeholderUsename"
        headerLabel.text = post.header
        bodyLabel.text = post.body
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
        mainStackView.customize(backgroundColor: .clear, radiusSize: 8, borderColor: .customAccentColor, borderWidth: 2)
    }
    
    private func setupAuthorInfoStackViewUI() {
        authorInfoStackView.axis = .horizontal
        authorInfoStackView.distribution = .fillProportionally
        authorInfoStackView.alignment = .center
        authorInfoStackView.spacing = 16
    }
    
    private func setupAuthorImageViewUI() {
        authorImageView.translatesAutoresizingMaskIntoConstraints = false
        authorImageView.contentMode = .scaleAspectFit
        authorImageView.layer.cornerRadius = 35
        authorImageView.layer.borderColor = UIColor.customAccentColor.cgColor
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
    
    private func setupPostContentStackViewUI() {
        postContentStackView.axis = .vertical
        postContentStackView.spacing = 16
        postContentStackView.alignment = .leading
        postContentStackView.distribution = .fillProportionally
    }
    
    private func setupHeaderLabelUI() {
        headerLabel.font = .boldSystemFont(ofSize: 16)
        headerLabel.textColor = .white
    }
    
    private func setupBodyLabelUI() {
        bodyLabel.font = .systemFont(ofSize: 14)
        bodyLabel.textColor = .white
        bodyLabel.numberOfLines = 0
        bodyLabel.lineBreakMode = .byWordWrapping
        bodyLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
}
