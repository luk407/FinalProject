
import UIKit

class SignupSceneView: UIViewController {
    // MARK: - Properties
    private var mainStackView = UIStackView()
    
    private var logoImageView = UIImageView()
    
    private var inputInfoStackView = UIStackView()
    
    private var usernameStackView = UIStackView()
    
    private var usernameLabel = UILabel()
    
    private var usernameTextField = UITextField()
    
    private var emailStackView = UIStackView()
    
    private var emailLabel = UILabel()
    
    private var emailTextField = UITextField()
    
    private var passwordStackView = UIStackView()
    
    private var passwordLabel = UILabel()
    
    private var passwordTextField = UITextField()
    
    private var signupButton = UIButton()
    
    private var passwordStrengthChecklistView = PasswordStrengthChecklistView(isMinLengthMet: false,
                                                                              isCapitalLetterMet: false,
                                                                              isNumberMet: false,
                                                                              isUniqueCharacterMet: false)
    
    private var emptyAlert = UIAlertController(title: "Nickname or Email field is empty",
                                               message: "Please fill in all fields to sign up",
                                               preferredStyle: .alert)
    
    private var signupSceneViewModel = SignupSceneViewModel()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackgroundColor
        setupSubviews()
        setupConstraints()
        setupUI()
    }
    
    // MARK: - Setup Subviews, Constraints, UI
    private func setupSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(logoImageView)
        mainStackView.addArrangedSubview(inputInfoStackView)
        inputInfoStackView.addArrangedSubview(usernameStackView)
        usernameStackView.addArrangedSubview(usernameLabel)
        usernameStackView.addArrangedSubview(usernameTextField)
        inputInfoStackView.addArrangedSubview(emailStackView)
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTextField)
        inputInfoStackView.addArrangedSubview(passwordStackView)
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(passwordStrengthChecklistView)
        mainStackView.addArrangedSubview(signupButton)
    }
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
        setupLogoConstraints()
        setupInputInfoStackViewConstraints()
        setupNicknameStackViewConstraints()
        setupNicknameTextFieldConstraints()
        setupEmailStackViewConstraints()
        setupEmailTextFieldConstraints()
        setupPasswordStackViewConstraints()
        setupPasswordTextFieldConstraints()
        setupSignupButtonConstraints()
        setupPasswordStrengthChecklistViewConstraints()
    }
    
    private func setupUI() {
        setupMainStackViewUI()
        setupLogoImageViewUI()
        setupInputInfoStackViewUI()
        setupNicknameStackViewUI()
        setupNicknameLabelUI()
        setupNicknameTextFieldUI()
        setupEmailStackViewUI()
        setupEmailLabelUI()
        setupEmailTextFieldUI()
        setupPasswordStackViewUI()
        setupPasswordLabelUI()
        setupPasswordTextFieldUI()
        setupSignupButtonUI()
        setupEmptyAlertUI()
    }
    
    // MARK: - Constraints
    private func setupMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupLogoConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupInputInfoStackViewConstraints() {
        NSLayoutConstraint.activate([
            inputInfoStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
        ])
    }
    
    private func setupNicknameStackViewConstraints() {
        NSLayoutConstraint.activate([
            usernameStackView.widthAnchor.constraint(equalTo: inputInfoStackView.widthAnchor),
        ])
    }
    
    private func setupNicknameTextFieldConstraints() {
        NSLayoutConstraint.activate([
            usernameTextField.widthAnchor.constraint(equalTo: usernameStackView.widthAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupEmailStackViewConstraints() {
        NSLayoutConstraint.activate([
            emailStackView.widthAnchor.constraint(equalTo: inputInfoStackView.widthAnchor),
        ])
    }
    
    private func setupEmailTextFieldConstraints() {
        NSLayoutConstraint.activate([
            emailTextField.widthAnchor.constraint(equalTo: emailStackView.widthAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupPasswordStackViewConstraints() {
        NSLayoutConstraint.activate([
            passwordStackView.widthAnchor.constraint(equalTo: inputInfoStackView.widthAnchor),
        ])
    }
    
    private func setupPasswordTextFieldConstraints() {
        NSLayoutConstraint.activate([
            passwordTextField.widthAnchor.constraint(equalTo: passwordStackView.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupSignupButtonConstraints() {
        NSLayoutConstraint.activate([
            signupButton.heightAnchor.constraint(equalToConstant: 50),
            signupButton.widthAnchor.constraint(equalTo: inputInfoStackView.widthAnchor)
        ])
    }
    
    private func setupPasswordStrengthChecklistViewConstraints() {
        NSLayoutConstraint.activate([
            passwordStrengthChecklistView.widthAnchor.constraint(equalTo: inputInfoStackView.widthAnchor),
        ])
    }
    
    // MARK: - UI
    private func setupMainStackViewUI() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 16
        mainStackView.distribution = .fillProportionally
    }
    
    private func setupLogoImageViewUI() {
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
    }
    
    private func setupInputInfoStackViewUI() {
        inputInfoStackView.axis = .vertical
        inputInfoStackView.alignment = .center
        inputInfoStackView.spacing = 16
        inputInfoStackView.distribution = .fillProportionally
    }
    private func setupNicknameStackViewUI() {
        usernameStackView.axis = .vertical
        usernameStackView.alignment = .leading
        usernameStackView.spacing = 8
        usernameStackView.distribution = .fillProportionally
    }
    
    private func setupNicknameLabelUI() {
        usernameLabel.text = "Nickname"
        usernameLabel.font = .systemFont(ofSize: 14)
        usernameLabel.textColor = .customAccentColor
    }
    
    private func setupNicknameTextFieldUI() {
        usernameTextField.autocapitalizationType = .none
        usernameTextField.autocorrectionType = .no
        usernameTextField.font = .systemFont(ofSize: 14)
        usernameTextField.textColor = .customAccentColor
        usernameTextField.tintColor = .customAccentColor
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.backgroundColor = .customBackgroundColor
        usernameTextField.layer.borderColor = UIColor.customAccentColor.cgColor
        usernameTextField.layer.borderWidth = 2
        usernameTextField.layer.cornerRadius = 8
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Nickname...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.customAccentColor.withAlphaComponent(0.5)])
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: usernameTextField.frame.height))
        usernameTextField.leftView = paddingView
        usernameTextField.leftViewMode = .always
    }
    
    private func setupEmailStackViewUI() {
        emailStackView.axis = .vertical
        emailStackView.alignment = .leading
        emailStackView.spacing = 8
        emailStackView.distribution = .fillProportionally
    }
    
    private func setupEmailLabelUI() {
        emailLabel.text = "Email"
        emailLabel.font = .systemFont(ofSize: 14)
        emailLabel.textColor = .customAccentColor
    }
    
    private func setupEmailTextFieldUI() {
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.font = .systemFont(ofSize: 14)
        emailTextField.textColor = .customAccentColor
        emailTextField.tintColor = .customAccentColor
        emailTextField.borderStyle = .roundedRect
        emailTextField.backgroundColor = .customBackgroundColor
        emailTextField.layer.borderColor = UIColor.customAccentColor.cgColor
        emailTextField.layer.borderWidth = 2
        emailTextField.layer.cornerRadius = 8
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.customAccentColor.withAlphaComponent(0.5)])
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: emailTextField.frame.height))
        emailTextField.leftView = paddingView
        emailTextField.leftViewMode = .always
    }
    
    private func setupPasswordStackViewUI() {
        passwordStackView.axis = .vertical
        passwordStackView.alignment = .leading
        passwordStackView.spacing = 8
        passwordStackView.distribution = .fillProportionally
    }
    
    private func setupPasswordLabelUI() {
        passwordLabel.text = "Password"
        passwordLabel.font = .systemFont(ofSize: 14)
        passwordLabel.textColor = .customAccentColor
    }
    
    private func setupPasswordTextFieldUI() {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.font = .systemFont(ofSize: 14)
        passwordTextField.textColor = .customAccentColor
        passwordTextField.tintColor = .customAccentColor
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.backgroundColor = .customBackgroundColor
        passwordTextField.layer.borderColor = UIColor.customAccentColor.cgColor
        passwordTextField.layer.borderWidth = 2
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.customAccentColor.withAlphaComponent(0.5)])
        passwordTextField.addTarget(self, action: #selector(SignupSceneView.textFieldDidChange(_:)), for: .editingChanged)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: passwordTextField.frame.height))
        passwordTextField.leftView = paddingView
        passwordTextField.leftViewMode = .always
    }
    
    private func setupSignupButtonUI() {
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.setTitleColor(.customBackgroundColor, for: .normal)
        signupButton.backgroundColor = .lightGray
        signupButton.layer.cornerRadius = 8
        signupButton.addTarget(self, action: #selector(signupButtonPressed), for: .touchUpInside)
    }
    
    private func setupEmptyAlertUI() {
        emptyAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            usernameTextField.layer.borderColor = UIColor.customAccentColor.cgColor
            emailTextField.layer.borderColor = UIColor.customAccentColor.cgColor
            passwordTextField.layer.borderColor = UIColor.customAccentColor.cgColor
        }
    }
    
    // MARK: - Button Methods
    @objc private func signupButtonPressed() {
        MethodsManager.shared.fadeAnimation(elements: signupButton) {
            self.signupButtonAction()
        }
    }
    
    // MARK: - Button Actions
    private func signupButtonAction() {
        
        if signupSceneViewModel.isSignUpEnabled {
            if usernameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" {
                present(emptyAlert, animated: true, completion: nil)
            } else {
                signupSceneViewModel.register(emailText: emailTextField.text ?? "", passwordText: passwordTextField.text ?? "")
                signupSceneViewModel.addUserData(
                    username: usernameTextField.text ?? "",
                    email: emailTextField.text ?? "",
                    password: passwordTextField.text ?? "")
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - Private Methods
    @objc private func textFieldDidChange(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.signupSceneViewModel.passwordTextChange(textField.text ?? "")
            self.updateTextField()
        }
    }
    
    private func updateTextField() {
        signupSceneViewModel.updatePasswordCriteria(password: passwordTextField.text ?? "")
        passwordTextField.text = signupSceneViewModel.password
        passwordStrengthChecklistView.isMinLengthMet = signupSceneViewModel.isMinLengthMet
        passwordStrengthChecklistView.isNumberMet = signupSceneViewModel.isNumberMet
        passwordStrengthChecklistView.isCapitalLetterMet = signupSceneViewModel.isCapitalLetterMet
        passwordStrengthChecklistView.isUniqueCharacterMet = signupSceneViewModel.isUniqueCharacterMet
        updateSignupButton()
    }
    
    private func updateSignupButton() {
        DispatchQueue.main.async {
            if !self.signupSceneViewModel.isSignUpEnabled {
                self.signupButton.isEnabled = false
                self.signupButton.backgroundColor = .lightGray
            } else {
                self.signupButton.isEnabled = true
                self.signupButton.backgroundColor = .customAccentColor
            }
        }
    }
}
