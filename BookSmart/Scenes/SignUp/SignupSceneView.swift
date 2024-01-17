//
//  SignupView.swift
//  BookSmart
//
//  Created by Luka Gazdeliani on 16.01.24.
//

import UIKit

class SignupSceneView: UIViewController {
    
    // MARK: - Properties
    private var mainStackView = UIStackView()
    
    private var appNameLabel = UILabel()
    
    private var inputInfoStackView = UIStackView()
    
    private var nicknameStackView = UIStackView()
    
    private var nicknameLabel = UILabel()
    
    private var nicknameTextField = UITextField()
    
    private var emailStackView = UIStackView()
    
    private var emailLabel = UILabel()
    
    private var emailTextField = UITextField()
    
    private var passwordStackView = UIStackView()
    
    private var passwordLabel = UILabel()
    
    private var passwordTextField = UITextField()
    
    private var signupButton = UIButton()
    
    var signupSceneViewModel = SignupSceneViewModel()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBackgroundColor
        setupSubviews()
        setupConstraints()
        setupUI()
    }
    
    // MARK: - Methods
    private func setupSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(appNameLabel)
        mainStackView.addArrangedSubview(inputInfoStackView)
        inputInfoStackView.addArrangedSubview(nicknameStackView)
        nicknameStackView.addArrangedSubview(nicknameLabel)
        nicknameStackView.addArrangedSubview(nicknameTextField)
        inputInfoStackView.addArrangedSubview(emailStackView)
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(emailTextField)
        inputInfoStackView.addArrangedSubview(passwordStackView)
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordTextField)
        mainStackView.addArrangedSubview(signupButton)
    }
    
    private func setupConstraints() {
        setupMainStackViewConstraints()
        setupInputInfoStackViewConstraints()
        setupNicknameStackViewConstraints()
        setupNicknameTextFieldConstraints()
        setupEmailStackViewConstraints()
        setupEmailTextFieldConstraints()
        setupPasswordStackViewConstraints()
        setupPasswordTextFieldConstraints()
        setupSignupButtonConstraints()
    }
    
    private func setupUI() {
        setupMainStackViewUI()
        setupAppNameLabelUI()
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
    }
    
    // MARK: - Constraints
    private func setupMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
        ])
    }
    
    private func setupInputInfoStackViewConstraints() {
        NSLayoutConstraint.activate([
            inputInfoStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            inputInfoStackView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupNicknameStackViewConstraints() {
        NSLayoutConstraint.activate([
            nicknameStackView.widthAnchor.constraint(equalToConstant: 300),
        ])
    }
    
    private func setupNicknameTextFieldConstraints() {
        NSLayoutConstraint.activate([
            nicknameTextField.widthAnchor.constraint(equalTo: nicknameStackView.widthAnchor),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 50),
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
            passwordTextField.widthAnchor.constraint(equalTo: passwordStackView.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    private func setupSignupButtonConstraints() {
        NSLayoutConstraint.activate([
            signupButton.heightAnchor.constraint(equalToConstant: 50),
            signupButton.widthAnchor.constraint(equalToConstant: 200)
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
        appNameLabel.text = "placeHolderName"
        appNameLabel.font = .systemFont(ofSize: 30)
        appNameLabel.textColor = .customAccentColor
    }
    
    private func setupInputInfoStackViewUI() {
        inputInfoStackView.axis = .vertical
        inputInfoStackView.alignment = .center
        inputInfoStackView.spacing = 10
        inputInfoStackView.distribution = .fillProportionally
    }
    private func setupNicknameStackViewUI() {
        nicknameStackView.axis = .vertical
        nicknameStackView.alignment = .leading
        nicknameStackView.spacing = 5
        nicknameStackView.distribution = .fillProportionally
    }
    
    private func setupNicknameLabelUI() {
        nicknameLabel.text = "Nickname"
        nicknameLabel.font = .systemFont(ofSize: 14)
        nicknameLabel.textColor = .customAccentColor
    }
    
    private func setupNicknameTextFieldUI() {
        nicknameTextField.font = .systemFont(ofSize: 14)
        nicknameTextField.backgroundColor = .white
        nicknameTextField.borderStyle = .roundedRect
        nicknameTextField.backgroundColor = .customAccentColor.withAlphaComponent(0.5)
        nicknameTextField.attributedPlaceholder = NSAttributedString(string: "Nickname...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        nicknameTextField.text = signupSceneViewModel.nickname
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
        emailTextField.font = .systemFont(ofSize: 14)
        emailTextField.backgroundColor = .white
        emailTextField.borderStyle = .roundedRect
        emailTextField.backgroundColor = .customAccentColor.withAlphaComponent(0.5)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        emailTextField.text = signupSceneViewModel.email
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
        passwordTextField.font = .systemFont(ofSize: 14)
        passwordTextField.backgroundColor = .white
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.backgroundColor = .customAccentColor.withAlphaComponent(0.5)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        passwordTextField.text = signupSceneViewModel.password
    }
    
    private func setupSignupButtonUI() {
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.setTitleColor(.black, for: .normal)
        signupButton.backgroundColor = .customAccentColor
        signupButton.layer.cornerRadius = 8
    }
}
