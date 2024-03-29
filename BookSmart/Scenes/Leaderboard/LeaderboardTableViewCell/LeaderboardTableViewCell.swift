
import UIKit

final class LeaderboardTableViewCell: UITableViewCell {
    // MARK: - Properties
    private let mainStackView = UIStackView()
    
    private let placeLabel = UILabel()
    
    private let cellStackView = UIStackView()
    
    private let userImageView = UIImageView()
    
    private let usernameLabel = UILabel()
    
    private let bookIconImageView = UIImageView()
    
    private let booksReadCountLabel = UILabel()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
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
        usernameLabel.text = nil
        booksReadCountLabel.text = nil
    }
    
    // MARK: - Setup Subviews, Constraints, UI
    private func setupSubViews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(placeLabel)
        mainStackView.addArrangedSubview(cellStackView)
        cellStackView.addArrangedSubview(userImageView)
        cellStackView.addArrangedSubview(usernameLabel)
        cellStackView.addArrangedSubview(bookIconImageView)
        cellStackView.addArrangedSubview(booksReadCountLabel)
    }
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
        setupPlaceLabelConstraints()
        setupCellStackViewConstraints()
        setupUserImageViewConstraints()
        setupUsernameLabelConstraints()
        setupBookIconImageViewConstraints()
        setupBooksReadCountLabelConstraints()
    }
    
    private func setupUI() {
        setupMainStackViewUI()
        setupPlaceLabelUI()
        setupCellStackViewUI()
        setupUserImageViewUI()
        setupUsernameLabelUI()
        setupBookIconImageViewUI()
        setupBooksReadCountLabelUI()
    }
    
    func configureCell(userInfo: UserInfo, place: Int, userImage: UIImage) {
        placeLabel.text = "\(place)"
        usernameLabel.text = "@\(userInfo.userName)"
        booksReadCountLabel.text = "\(userInfo.booksFinished.count)"
        userImageView.image = userImage
    }
    
    // MARK: - Constraints
    private func setupMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            mainStackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupPlaceLabelConstraints() {
        NSLayoutConstraint.activate([
            placeLabel.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            placeLabel.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupCellStackViewConstraints() {
        NSLayoutConstraint.activate([
            cellStackView.leadingAnchor.constraint(equalTo: placeLabel.trailingAnchor, constant: 16),
        ])
    }
    
    private func setupUserImageViewConstraints() {
        NSLayoutConstraint.activate([
            userImageView.heightAnchor.constraint(equalToConstant: 50),
            userImageView.widthAnchor.constraint(equalToConstant: 50),
            userImageView.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor)
        ])
    }
    
    private func setupBookIconImageViewConstraints() {
        NSLayoutConstraint.activate([
            bookIconImageView.heightAnchor.constraint(equalToConstant: 30),
            bookIconImageView.widthAnchor.constraint(equalToConstant: 30),
            bookIconImageView.trailingAnchor.constraint(equalTo: booksReadCountLabel.leadingAnchor, constant: -16)
        ])
    }
    
    private func setupUsernameLabelConstraints() {
        NSLayoutConstraint.activate([
            usernameLabel.widthAnchor.constraint(equalToConstant: 100),
            usernameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
        ])
    }
    
    private func setupBooksReadCountLabelConstraints() {
        NSLayoutConstraint.activate([
            booksReadCountLabel.widthAnchor.constraint(equalToConstant: 30),
            booksReadCountLabel.trailingAnchor.constraint(equalTo: cellStackView.trailingAnchor),
        ])
    }
    
    // MARK: - UI
    private func setupMainStackViewUI() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .horizontal
        mainStackView.spacing = 16
        mainStackView.distribution = .fillProportionally
        mainStackView.alignment = .center
    }
    
    private func setupPlaceLabelUI() {
        placeLabel.font = .systemFont(ofSize: 20)
        placeLabel.textColor = .customAccentColor
    }
    
    private func setupCellStackViewUI() {
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.axis = .horizontal
        cellStackView.spacing = 16
        cellStackView.alignment = .center
        cellStackView.distribution = .fillProportionally
        cellStackView.customize(
            backgroundColor: .customAccentColor.withAlphaComponent(0.1),
            radiusSize: 25,
            borderColor: .clear,
            borderWidth: 0)
    }
    
    private func setupUserImageViewUI() {
        userImageView.contentMode = .scaleToFill
        userImageView.layer.cornerRadius = 25
        userImageView.clipsToBounds = true
        userImageView.image = UIImage(systemName: "person.fill")
        userImageView.tintColor = .customAccentColor
    }
    
    private func setupUsernameLabelUI() {
        usernameLabel.font = .systemFont(ofSize: 14)
        usernameLabel.textColor = .customAccentColor
    }
    
    private func setupBookIconImageViewUI() {
        bookIconImageView.image = UIImage(systemName: "book.circle")
        bookIconImageView.tintColor = .customAccentColor
    }
    
    private func setupBooksReadCountLabelUI() {
        booksReadCountLabel.font = .systemFont(ofSize: 14)
        booksReadCountLabel.textColor = .customAccentColor
    }
}
