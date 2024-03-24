
import UIKit

final class ChecklistItemView: UIView {
    // MARK: - Properties
    private let mainStackView = UIStackView()
    
    private let isMetIcon = UIImageView()
    
    private let titleLabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupMainStackViewConstraints()
        setupIsMetIconConstraints()
        setupMainStackViewUI()
        setupTitleLabelUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupSubviews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(isMetIcon)
        mainStackView.addArrangedSubview(titleLabel)
    }
    
    // MARK: - Constraints
    private func setupMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupIsMetIconConstraints() {
        NSLayoutConstraint.activate([
            isMetIcon.heightAnchor.constraint(equalToConstant: 12),
            isMetIcon.widthAnchor.constraint(equalToConstant: 12),
        ])
    }
    
    // MARK: - UI
    private func setupMainStackViewUI() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .horizontal
        mainStackView.spacing = 8
        mainStackView.alignment = .center
        mainStackView.distribution = .fill
    }
    
    private func setupTitleLabelUI() {
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .customBackgroundColor
    }
    
    func update(title: String, isMet: Bool) {
        titleLabel.text = title
        if isMet {
            isMetIcon.image = UIImage(systemName: "circle.fill")
            isMetIcon.tintColor = .customIsMetColor
        } else {
            isMetIcon.image = UIImage(systemName: "circle")?.withTintColor(.customIsMetColor)
            isMetIcon.tintColor = .customIsMetColor
        }
    }
}
