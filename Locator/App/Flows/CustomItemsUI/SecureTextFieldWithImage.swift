//
//  SecureTextFieldWithImage.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 17.10.2021.
//

import UIKit

@IBDesignable
class SecureTextFieldWithImage: TextFieldWithImage {

    // MARK: - Public properties
    @IBInspectable var normalStateImage: UIImage? = UIImage(systemName: "eye.circle")
    @IBInspectable var secureStateImage: UIImage? = UIImage(systemName: "eye.slash.circle")

    // MARK: - Subviews
    private var rightViewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(toggleRightView(_:)),
                         for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        return button
    }()

    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.autocorrectionType = .no

        setupRightView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupRightView()
    }

    // MARK: - Private methods
    @objc private func toggleRightView(_ sender: Any) {
        let isSecureTextEntry = self.isSecureTextEntry
        self.isSecureTextEntry = !isSecureTextEntry

        rightViewButton.setImage(isSecureTextEntry ? secureStateImage : normalStateImage,
                                 for: .normal)
    }

    private func setupRightView() {
        rightViewButton.imageView?.tintColor = color

        toggleRightView(self)

        self.rightView = rightViewButton
        self.rightViewMode = .always
    }
}
