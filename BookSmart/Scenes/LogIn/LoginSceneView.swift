//
//  LoginSceneViewController.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import UIKit

final class LoginSceneView: UIViewController {
    
    // MARK: - Properties
    private var mainStackView = UIStackView()
    
    private var appNameLabel = UILabel()
    
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
    
    private var emptyAlert = UIAlertController(title: "Email or Password field is empty", message: "Please fill in all fields to log in", preferredStyle: .alert)
    
    var loginSceneViewModel = LoginSceneViewModel()
    
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
        mainStackView.addArrangedSubview(appNameLabel)
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
    }
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
        setupEmailStackViewConstraints()
        setupEmailTextFieldConstraints()
        setupPasswordStackViewConstraints()
        setupPasswordTextFieldConstraints()
        setupLoginButtonConstraints()
    }
    
    private func setupUI() {
        setupMainStackViewUI()
        setupAppNameLabelUI()
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
        setupEmptyAlertUI()
    }
    
    // MARK: - Constraints
    private func setupMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
        ])
    }
    
    private func setupInputInfoStackViewConstraints() {
        NSLayoutConstraint.activate([
            inputInfoStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            inputInfoStackView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupEmailStackViewConstraints() {
        NSLayoutConstraint.activate([
            emailStackView.widthAnchor.constraint(equalToConstant: 300),
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
            passwordStackView.widthAnchor.constraint(equalToConstant: 300),
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
            loginButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // MARK: - UI
    private func setupMainStackViewUI() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 50
        mainStackView.distribution = .fillProportionally
    }
    
    private func setupAppNameLabelUI() {
        appNameLabel.text = "BookSmart"
        appNameLabel.font = .systemFont(ofSize: 30)
        appNameLabel.textColor = .customAccentColor
    }
    
    private func setupInputInfoStackViewUI() {
        inputInfoStackView.axis = .vertical
        inputInfoStackView.alignment = .center
        inputInfoStackView.spacing = 10
        inputInfoStackView.distribution = .fillProportionally
    }
    
    private func setupEmailStackViewUI() {
        emailStackView.axis = .vertical
        emailStackView.alignment = .leading
        emailStackView.spacing = 5
        emailStackView.distribution = .fillProportionally
    }
    
    private func setupEmailLabelUI() {
        emailLabel.text = "Email"
        emailLabel.font = .systemFont(ofSize: 14)
        emailLabel.textColor = .customAccentColor
    }
    
    private func setupEmailTextFieldUI() {
        emailTextField.autocapitalizationType = .none
        emailTextField.font = .systemFont(ofSize: 14)
        emailTextField.backgroundColor = .white
        emailTextField.borderStyle = .roundedRect
        emailTextField.backgroundColor = .customAccentColor.withAlphaComponent(0.5)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    private func setupPasswordStackViewUI() {
        passwordStackView.axis = .vertical
        passwordStackView.alignment = .leading
        passwordStackView.spacing = 5
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
        passwordTextField.backgroundColor = .white
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.backgroundColor = .customAccentColor.withAlphaComponent(0.5)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    private func setupDontHaveAccountStackViewUI() {
        dontHaveAccountStackView.spacing = 10
    }
    
    private func setupDontHaveAccountLabelUI() {
        dontHaveAccountLabel.text = "Don't have an account?"
        dontHaveAccountLabel.font = .systemFont(ofSize: 14)
        dontHaveAccountLabel.textColor = .white
    }
    
    private func setupSignUpButtonUI() {
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: 14)
        signUpButton.setTitleColor(.systemBlue, for: .normal)
        signUpButton.addTarget(self, action: #selector(signupButtonPressed), for: .touchUpInside)
    }
    
    private func setupLoginButtonUI() {
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.backgroundColor = .customAccentColor
        loginButton.layer.cornerRadius = 8
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }
    
    private func setupEmptyAlertUI() {
        emptyAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
    }
    
    // MARK: - Private Methods
    @objc private func signupButtonPressed() {
        guard let navigationControllerToPass = self.navigationController else { return }
        loginSceneViewModel.signupButtonPressed(navigationController: navigationControllerToPass)
    }
    
    @objc private func loginButtonPressed() {
        guard let navigationControllerToPass = self.navigationController else { return }
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            //present(emptyAlert, animated: true, completion: nil)
            #warning("change after finishing project")
            emailTextField.text = "luk@gmail.com"
            passwordTextField.text = "Luka!2345"            
        } else {
            loginSceneViewModel.login(
                email: emailTextField.text ?? "",
                password: passwordTextField.text ?? "")
            
            loginSceneViewModel.fetchUserInfoAndLogin(
                email: emailTextField.text ?? "",
                password: passwordTextField.text ?? "") { [weak self] success in
                    guard let self = self else { return }
                    if success {
                        self.loginSceneViewModel.navigateToTabBarController(navigationController: navigationControllerToPass)
                    } else {
                        print("Failed to fetch user information.")
                    }
                }
        }
    }
}
