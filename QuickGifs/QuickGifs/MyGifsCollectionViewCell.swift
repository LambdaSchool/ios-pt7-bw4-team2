//
//  MyGifsCollectionViewCell.swift
//  QuickGifs
//
//  Created by Sammy Alvarado on 12/16/20.
//

import UIKit

class MyGifsCollectionViewCell: UICollectionViewCell {
    static let identifier = "gifCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .purple
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder) // This will allow me to use storyboard and programmatic UI.
//        fatalError("Storyboard is for clones") // This will allow us to crash the app if someone trys to use the storyboard.
    }
}
