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
    
    private var passwordStrengthChecklistView = PasswordStrengthChecklistView(
        isMinLengthMet: false,
        isCapitalLetterMet: false,
        isNumberMet: false,
        isUniqueCharacterMet: false)
    
    private var emptyAlert = UIAlertController(title: "Nickname or Email field is empty", message: "Please fill in all fields to sign up", preferredStyle: .alert)
    
    private var signupSceneViewModel = SignupSceneViewModel()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        setupSubviews()
        setupConstraints()
        setupUI()
    }
    
    // MARK: - Setup Subviews, Constraints, UI
    private func setupSubviews() {
        view.addSubview(mainStackView)
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
        mainStackView.addArrangedSubview(signupButton)
        mainStackView.addArrangedSubview(passwordStrengthChecklistView)
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
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
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
            usernameStackView.widthAnchor.constraint(equalToConstant: 300),
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
        mainStackView.spacing = 20
        mainStackView.distribution = .fillProportionally
    }
    
    private func assignBackground(){
        let background = UIImage(named: "backgroundWithLogo")
        
        var imageView = UIImageView()
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    private func setupInputInfoStackViewUI() {
        inputInfoStackView.axis = .vertical
        inputInfoStackView.alignment = .center
        inputInfoStackView.spacing = 10
        inputInfoStackView.distribution = .fillProportionally
    }
    private func setupNicknameStackViewUI() {
        usernameStackView.axis = .vertical
        usernameStackView.alignment = .leading
        usernameStackView.spacing = 5
        usernameStackView.distribution = .fillProportionally
    }
    
    private func setupNicknameLabelUI() {
        usernameLabel.text = "Nickname"
        usernameLabel.font = .systemFont(ofSize: 14)
        usernameLabel.textColor = .customAccentColor
    }
    
    private func setupNicknameTextFieldUI() {
        usernameTextField.autocapitalizationType = .none
        usernameTextField.font = .systemFont(ofSize: 14)
        usernameTextField.backgroundColor = .white
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.backgroundColor = .customAccentColor.withAlphaComponent(0.5)
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Nickname...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
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
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.font = .systemFont(ofSize: 14)
        passwordTextField.backgroundColor = .white
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.backgroundColor = .customAccentColor.withAlphaComponent(0.5)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        passwordTextField.addTarget(self, action: #selector(SignupSceneView.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupSignupButtonUI() {
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.setTitleColor(.black, for: .normal)
        signupButton.backgroundColor = .lightGray
        signupButton.layer.cornerRadius = 8
        signupButton.addTarget(self, action: #selector(signupButtonPressed), for: .touchUpInside)
    }
    
    private func setupEmptyAlertUI() {
        emptyAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
    }
    
    // MARK: - Private Methods
    @objc private func signupButtonPressed() {
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
