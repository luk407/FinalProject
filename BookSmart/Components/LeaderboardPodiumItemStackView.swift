
import UIKit

final class LeaderboardPodiumItemStackView: UIStackView {
    // MARK: - Properties
    private let crownImageView = UIImageView()
    private let placeLabel = UILabel()
    private let userImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let booksReadCountStackView = UIStackView()
    private let booksReadCountLabel = UILabel()
    private let bookIconImageView = UIImageView()
    private let shadowContainer = UIView()
    
    // MARK: - Init
    init(place: Int, userImage: UIImage, imageSize: CGFloat, username: String, booksReadCount: Int, shadowColor: UIColor) {
        super.init(frame: .zero)
        addSubviews(place: place)
        setupUI(place: place, userImage: userImage, imageSize: imageSize, username: username, booksReadCount: booksReadCount, shadowColor: shadowColor)
        addShadowToUserImageView(imageView: userImageView, shadowColor: shadowColor)
        
        self.axis = .vertical
        self.alignment = .center
        self.spacing = 8
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Subviews, Constraints, UI
    private func addSubviews(place: Int) {
        if place == 1 {
            addArrangedSubview(crownImageView)
        } else {
            addArrangedSubview(placeLabel)
        }
        addArrangedSubview(shadowContainer)
        shadowContainer.addSubview(userImageView)
        addArrangedSubview(userImageView)
        addArrangedSubview(usernameLabel)
        addArrangedSubview(booksReadCountStackView)
        booksReadCountStackView.addArrangedSubview(bookIconImageView)
        booksReadCountStackView.addArrangedSubview(booksReadCountLabel)
    }
    
    func setupUI(place: Int, userImage: UIImage, imageSize: CGFloat, username: String, booksReadCount: Int, shadowColor: UIColor = .clear) {
        booksReadCountStackView.axis = .horizontal
        booksReadCountStackView.spacing = 8
        
        setupIconUI(imageView: crownImageView,
                    image: UIImage(systemName: "crown.fill"),
                    size: 50,
                    color: .customGoldColor)
        
        setupLabelUI(
            label: placeLabel,
            text: "\(place)",
            textColor: .customAccentColor,
            font: UIFont.boldSystemFont(ofSize: 16),
            backgroundColor: .clear)
        
        setupImageViewUI(
            imageView: userImageView,
            image: userImage,
            size: imageSize)
        
        setupLabelUI(
            label: usernameLabel,
            text: "@\(username)",
            textColor: .customAccentColor,
            font: UIFont.systemFont(ofSize: 13))
        
        setupLabelUI(
            label: booksReadCountLabel,
            text: "\(booksReadCount)",
            textColor: .customAccentColor,
            font: UIFont.systemFont(ofSize: 12))
        
        setupIconUI(
            imageView: bookIconImageView,
            image: UIImage(systemName: "book.circle"),
            size: 20,
            color: .customAccentColor)
    }
    
    // MARK: - UI
    private func setupLabelUI(label: UILabel, text: String, textColor: UIColor, font: UIFont, backgroundColor: UIColor? = .clear) {
        label.text = text
        label.textColor = textColor
        label.font = font
        label.backgroundColor = backgroundColor
    }
    
    private func setupImageViewUI(imageView: UIImageView, image: UIImage?, size: CGFloat) {
        imageView.image = image
        imageView.contentMode = .scaleToFill
        imageView.heightAnchor.constraint(equalToConstant: size).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: size).isActive = true
        imageView.tintColor = .white
        imageView.layer.cornerRadius = size / 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.customAccentColor.cgColor
    }
    
    private func setupIconUI(imageView: UIImageView, image: UIImage?, size: CGFloat, color: UIColor) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: size).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: size).isActive = true
        imageView.tintColor = color
    }
    
    private func addShadowToUserImageView(imageView: UIImageView, shadowColor: UIColor) {
        imageView.layer.shadowColor = shadowColor.cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowRadius = 50
    }
    
    // MARK: - Methods
    func updateUserImage(image: UIImage?) {
        DispatchQueue.main.async {
            self.userImageView.image = image
        }
    }
}
