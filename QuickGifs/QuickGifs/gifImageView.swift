//
//  gifImageView.swift
//  QuickGifs
//
//  Created by Norlan Tibanear on 1/8/21.
//

import UIKit

class gifImageView: UIImageView {
    
    override var image: UIImage?
    
    {
        didSet {
            guard var image = self.image else { return }
            image = image.flattened
        }
    }
    
}
