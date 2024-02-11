
import UIKit

final class PasswordStrengthChecklistView: UIView {
    
    // MARK: - Properties
    
    var isMinLengthMet: Bool = false {
        didSet { updateUI() }
    }
    var isCapitalLetterMet: Bool = false {
        didSet { updateUI() }
    }
    var isNumberMet: Bool = false {
        didSet { updateUI() }
    }
    var isUniqueCharacterMet: Bool = false {
        didSet { updateUI() }
    }

    // MARK: - Subviews
    
    private let mainStackView = UIStackView()
    
    private let requiredLabel = UILabel()

    private let minLengthItem = ChecklistItemView()

    private let capitalLetterItem = ChecklistItemView()

    private let numberItem = ChecklistItemView()

    private let uniqueCharacterItem = ChecklistItemView()

    // MARK: - Init
    
    init(isMinLengthMet: Bool, isCapitalLetterMet: Bool, isNumberMet: Bool, isUniqueCharacterMet: Bool) {
        self.isMinLengthMet = isMinLengthMet
        self.isCapitalLetterMet = isCapitalLetterMet
        self.isNumberMet = isNumberMet
        self.isUniqueCharacterMet = isUniqueCharacterMet
        
        super.init(frame: .zero)
        setupSubviews()
        setupMainStackViewConstraints()
        setupUI()
        updateUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    
    private func setupSubviews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(requiredLabel)
        mainStackView.addArrangedSubview(minLengthItem)
        mainStackView.addArrangedSubview(capitalLetterItem)
        mainStackView.addArrangedSubview(numberItem)
        mainStackView.addArrangedSubview(uniqueCharacterItem)
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
    
    private func setupUI() {
        setupMainStackViewUI()
        setupRequiredLabelUI()
    }
    
    private func setupMainStackViewUI() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.axis = .vertical
        mainStackView.spacing = 4
        mainStackView.alignment = .leading
        mainStackView.distribution = .fillProportionally
        mainStackView.customize(backgroundColor: .customAccentColor.withAlphaComponent(0.5), radiusSize: 8, borderWidth: 1)
        mainStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    private func setupRequiredLabelUI() {
        requiredLabel.textColor = .black
        requiredLabel.text = "Your password should have:"
        requiredLabel.font = .systemFont(ofSize: 15)
    }
    
    //MARK: - Private Methods
    
    private func updateUI() {
        minLengthItem.update(title: "At least 8 characters", isMet: isMinLengthMet)
        capitalLetterItem.update(title: "At least one capital letter", isMet: isCapitalLetterMet)
        numberItem.update(title: "At least one number", isMet: isNumberMet)
        uniqueCharacterItem.update(title: "At least one unique character", isMet: isUniqueCharacterMet)
    }
}
