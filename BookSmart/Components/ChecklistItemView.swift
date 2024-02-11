
import UIKit

final class ChecklistItemView: UIView {
    
    // MARK: - Properties
    
    private let mainStackView = UIStackView()
    
    private let titleLabel = UILabel()

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupMainStackViewConstraints()
        setupMainStackViewUI()
        setupTitleLabelUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    
    private func setupSubviews() {
        addSubview(mainStackView)
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
    
    // MARK: - UI
    
    private func setupMainStackViewUI() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .horizontal
        mainStackView.spacing = 8
        mainStackView.alignment = .leading
        mainStackView.distribution = .fillProportionally
    }
    
    private func setupTitleLabelUI() {
        titleLabel.font = .systemFont(ofSize: 12)
    }
    
    func update(title: String, isMet: Bool) {
        titleLabel.text = title
        if isMet {
            titleLabel.textColor = .customIsMetColor
        } else {
            titleLabel.textColor = .black
        }
    }
}
