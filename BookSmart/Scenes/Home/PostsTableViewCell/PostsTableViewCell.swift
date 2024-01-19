//
//  TableViewCell.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 19.01.24.
//

import UIKit
import SwiftUI

class PostsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let mainStackView = UIStackView()
    
    private let authorInfoStackView = UIStackView()
    
    private let authorImageView = UIImageView()
    
    private let namesStackView = UIStackView()
    
    private let nameLabel = UILabel()
    
    private let usernameLabel = UILabel()
    
    private let postContentStackView = UIStackView()
    
    private let headerLabel = UILabel()
    
    private let bodyTextView = UITextView()
    
    private let interactionStackView = UIHostingController(rootView: InteractionStackView())

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        postContentStackView.addArrangedSubview(bodyTextView)
        mainStackView.addArrangedSubview(interactionStackView.view)
    }
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
    }
    
    private func setupUI() {
        setupMainStackViewUI()
    }
    
    func configureCell(with post: PostInfo) {
        
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
    
    // MARK: - UI
    
    private func setupMainStackViewUI() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        mainStackView.alignment = .center
        mainStackView.customize(radiusSize: 8, borderColor: .customAccentColor, borderWidth: 2)
    }
}
