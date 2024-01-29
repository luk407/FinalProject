//
//  LeaderboardTableViewCell.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 29.01.24.
//

import UIKit

class LeaderboardTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private let mainStackView = UIStackView()
    
    private let userImageView = UIImageView()
    
    private let usernameLabel = UILabel()
    
    private let bookIconImageView = UIImageView()
    
    private let booksReadCountLabel = UILabel()
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup Subviews, Constraints, UI
    
    private func setupSubViews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(userImageView)
        mainStackView.addArrangedSubview(usernameLabel)
        mainStackView.addArrangedSubview(bookIconImageView)
        mainStackView.addArrangedSubview(booksReadCountLabel)
    }
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
        setupUserImageViewConstraints()
        setupBookIconImageViewConstraints()
    }
    
    private func setupUI() {
        setupMainStackViewUI()
        setupUserImageViewUI()
        setupUsernameLabelUI()
        setupBookIconImageViewUI()
        setupBooksReadCountLabelUI()
    }
    
    // MARK: - Constraints
    
    private func setupMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupUserImageViewConstraints() {
        NSLayoutConstraint.activate([
            userImageView.heightAnchor.constraint(equalToConstant: 50),
            userImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupBookIconImageViewConstraints() {
        NSLayoutConstraint.activate([
            booksReadCountLabel.heightAnchor.constraint(equalToConstant: 50),
            booksReadCountLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - UI
    
    private func setupMainStackViewUI() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .horizontal
        mainStackView.spacing = 16
        mainStackView.alignment = .center
        mainStackView.distribution = .fillProportionally
        mainStackView.customize(
            backgroundColor: .customAccentColor.withAlphaComponent(0.1),
            borderColor: .clear,
            borderWidth: 0)
    }
    
    private func setupUserImageViewUI() {
        userImageView.contentMode = .scaleAspectFit
        userImageView.layer.cornerRadius = 25
    }
    
    private func setupUsernameLabelUI() {
        usernameLabel.font = .systemFont(ofSize: 12)
        usernameLabel.textColor = .white
    }
    
    private func setupBookIconImageViewUI() {
        bookIconImageView.image = UIImage(systemName: "book.circle")
    }
    
    private func setupBooksReadCountLabelUI() {
        booksReadCountLabel.font = .systemFont(ofSize: 12)
        booksReadCountLabel.textColor = .white
    }
    
    // MARK: - Private Methods
    
    
}
