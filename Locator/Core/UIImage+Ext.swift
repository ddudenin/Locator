//
//  UIImage+Ext.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 27.11.2021.
//

import UIKit

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        let scaleFactor = min(targetSize.width / size.width, targetSize.height / size.height)
        
        let scaledImageSize = CGSize(width: size.width * scaleFactor,
                                     height: size.height * scaleFactor)
        
        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero,
                                 size: scaledImageSize))
        }
        
        return scaledImage
    }
}
