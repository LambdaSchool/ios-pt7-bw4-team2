//
//  imageOrientation.swift
//  QuickGifs
//
//  Created by Norlan Tibanear on 1/7/21.
//

import UIKit

extension UIImage {
    
    var flattened: UIImage {
        if imageOrientation == .up { return self }
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { context in
          draw(at: .zero)
        }
      }
    
}
