
import UIKit
import Lottie

final class LoginSceneView: UIViewController {
    // MARK: - Properties
    private var mainStackView = UIStackView()
    
    private var logoImageView = UIImageView()
    
    private var inputInfoStackView = UIStackView()
    
    private var emailStackView = UIStackView()
    
    private var emailLabel = UILabel()
    
    private var emailTextField = UITextField()
    
    private var passwordStackView = UIStackView()
    
    private var passwordLabel = UILabel()
    
    private var passwordTextField = UITextField()
    
    private var dontHaveAccountStackView = UIStackView()
    
    private var dontHaveAccountLabel = UILabel()
    
    private var signUpButton = UIButton()
    
    private var loginButton = UIButton()
    
    private var animationView: LottieAnimationView!
    
    private var loginErrorAlert = UIAlertController(title: "Login Error",
                                                    message: "Please try again",
                                                    preferredStyle: .alert)
    
    private var emptyAlert = UIAlertController(title: "Email or Password field is empty",
                                               message: "Please fill in all fields to log in",
                                               preferredStyle: .alert)
    
    var loginSceneViewModel = LoginSceneViewModel()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackgroundColor
        loginSceneViewModel.delegate = self
        setupSubviews()
        setupConstraints()
        setupUI()
    }
    
    // MARK: - Setup Subviews, Constraints, UI
    private func setupSubviews() {
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(logoImageView)
        mainStackView.addArrangedSubview(inputInfoStackView)
        inputInfoStackView.addArrangedSubview(emailStackView)
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTextField)
        inputInfoStackView.addArrangedSubview(passwordStackView)
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(loginButton)
        mainStackView.addArrangedSubview(dontHaveAccountStackView)
        dontHaveAccountStackView.addArrangedSubview(dontHaveAccountLabel)
        dontHaveAccountStackView.addArrangedSubview(signUpButton)
        dontHaveAccountStackView.addArrangedSubview(spacerView)
    }
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
        setupLogoConstraints()
        setupInputInfoStackViewConstraints()
        setupEmailStackViewConstraints()
        setupEmailTextFieldConstraints()
        setupPasswordStackViewConstraints()
        setupPasswordTextFieldConstraints()
        setupLoginButtonConstraints()
        setupDontHaveAccountStackViewConstraints()
    }
    
    private func setupUI() {
        setupMainStackViewUI()
        setupLogoImageViewUI()
        setupInputInfoStackViewUI()
        setupEmailStackViewUI()
        setupEmailLabelUI()
        setupEmailTextFieldUI()
        setupPasswordStackViewUI()
        setupPasswordLabelUI()
        setupPasswordTextFieldUI()
        setupDontHaveAccountStackViewUI()
        setupDontHaveAccountLabelUI()
        setupSignUpButtonUI()
        setupLoginButtonUI()
        setupAlertsUI()
        setupBookAnimationView()
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
            inputInfoStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            inputInfoStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
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
            passwordTextField.widthAnchor.constraint(equalTo: inputInfoStackView.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupLoginButtonConstraints() {
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.widthAnchor.constraint(equalTo: inputInfoStackView.widthAnchor)
        ])
    }
    
    private func setupDontHaveAccountStackViewConstraints() {
        NSLayoutConstraint.activate([
            dontHaveAccountStackView.heightAnchor.constraint(equalToConstant: 50),
            dontHaveAccountStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            dontHaveAccountStackView.trailingAnchor.constraint(greaterThanOrEqualTo: mainStackView.trailingAnchor),
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
    
    private func setupLogoImageViewUI(){
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
    }
    
    private func setupInputInfoStackViewUI() {
        inputInfoStackView.axis = .vertical
        inputInfoStackView.alignment = .center
        inputInfoStackView.spacing = 16
        inputInfoStackView.distribution = .fillProportionally
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
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.font = .systemFont(ofSize: 14)
        passwordTextField.textColor = .customAccentColor
        passwordTextField.tintColor = .customAccentColor
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.backgroundColor = .customBackgroundColor
        passwordTextField.layer.borderColor = UIColor.customAccentColor.cgColor
        passwordTextField.layer.borderWidth = 2
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.customAccentColor.withAlphaComponent(0.5)])
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: passwordTextField.frame.height))
        passwordTextField.leftView = paddingView
        passwordTextField.leftViewMode = .always
    }
    
    private func setupDontHaveAccountStackViewUI() {
        dontHaveAccountStackView.isLayoutMarginsRelativeArrangement = true
        dontHaveAccountStackView.spacing = 8
        dontHaveAccountStackView.customize(backgroundColor: .customBackgroundColor, radiusSize: 8, borderWidth: 1)
        dontHaveAccountStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    private func setupDontHaveAccountLabelUI() {
        dontHaveAccountLabel.text = "Don't have an account?"
        dontHaveAccountLabel.font = .systemFont(ofSize: 14)
        dontHaveAccountLabel.textColor = .customAccentColor
    }
    
    private func setupSignUpButtonUI() {
        let attributedTitle = NSAttributedString(
            string: "Sign Up",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                NSAttributedString.Key.foregroundColor: UIColor.customAccentColor,
                NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        signUpButton.setAttributedTitle(attributedTitle, for: .normal)
        signUpButton.addTarget(self, action: #selector(signupButtonPressed), for: .touchUpInside)
    }
    
    private func setupLoginButtonUI() {
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(.customBackgroundColor, for: .normal)
        loginButton.backgroundColor = .customAccentColor
        loginButton.layer.cornerRadius = 8
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }
    
    private func setupAlertsUI() {
        emptyAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
        loginErrorAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
    }
    
    private func setupBookAnimationView() {
        if let index = mainStackView.arrangedSubviews.firstIndex(where: { $0 === animationView }) {
            mainStackView.removeArrangedSubview(animationView)
            animationView.removeFromSuperview()
        }
        
        var animationName: String
        if traitCollection.userInterfaceStyle == .dark {
            animationName = "Animation-Book-Dark"
        } else {
            animationName = "Animation-Book-Light"
        }
        
        animationView = .init(name: animationName)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .autoReverse
        animationView.animationSpeed = 1
        animationView.play()
        let animationViewWidth: CGFloat = 250
        let animationViewHeight: CGFloat = 250
        
        animationView.frame = CGRect(
            x: (view.frame.width - animationViewWidth) / 2,
            y: (view.frame.height - animationViewHeight) / 2,
            width: animationViewWidth,
            height: animationViewHeight)
        
        mainStackView.addArrangedSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalToConstant: animationViewHeight),
            animationView.widthAnchor.constraint(equalToConstant: animationViewWidth),
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            setupBookAnimationView()
            emailTextField.layer.borderColor = UIColor.customAccentColor.cgColor
            passwordTextField.layer.borderColor = UIColor.customAccentColor.cgColor
        }
    }

    // MARK: - Button Methods
    @objc private func signupButtonPressed() {
        MethodsManager.shared.fadeAnimation(elements: signUpButton) {
            self.navigateToSignupScene()
        }
    }
    
    @objc private func loginButtonPressed() {
        MethodsManager.shared.fadeAnimation(elements: loginButton) {
            self.loginButtonAction()
        }
    }
    
    // MARK: - Button Actions
    private func navigateToSignupScene() {
        let signupScene = SignupSceneView()
        navigationController?.pushViewController(signupScene, animated: true)
    }
    
    private func loginButtonAction() {
        if emailTextField.text == "" || passwordTextField.text == "" {
            present(emptyAlert, animated: true, completion: nil)
        } else {
            loginSceneViewModel.loginAndNavigate(
                email: emailTextField.text ?? "",
                password: passwordTextField.text ?? "")
        }
    }
}

// MARK: - Extensions
extension LoginSceneView: LoginSceneViewDelegate {
    func navigateToTabBarController() {
        guard let fetchedUserData = loginSceneViewModel.fetchedUserData else { return }
        
        let tabbarController = TabBarController(userInfo: fetchedUserData)
        navigationController?.pushViewController(tabbarController, animated: true)
    }
    
    func loginError() {
        present(loginErrorAlert, animated: true)
    }
}
