//
//  TextFieldWithImage.swift
//  OnlineStore
//
//  Created by Дмитрий Дуденин on 22.09.2021.
//

import UIKit

@IBDesignable
class TextFieldWithImage: UITextField {
    
    // MARK: - Public properties
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            self.color.getRed(&r, green: &g, blue: &b, alpha: &a)
            let color = UIColor(red: r, green: g, blue: b, alpha: a)
            
            self.color = color
            
            updateView()
        }
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += self.leftPadding
        return textRect
    }
    
    // MARK: - Private methods
    private func updateView() {
        if let image = leftImage {
            self.leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: 20,
                                                      height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.tintColor = color
            self.leftView = imageView
        } else {
            self.leftViewMode = UITextField.ViewMode.never
            self.leftView = nil
        }
        
        self.attributedPlaceholder = NSAttributedString(
            string: self.placeholder ?? "",
            attributes: [NSAttributedString.Key
                            .foregroundColor: color])
    }
}
