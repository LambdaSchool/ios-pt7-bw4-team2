//
//  DetialGifCollectionViewCell.swift
//  QuickGifs
//
//  Created by Sammy Alvarado on 12/19/20.
//

import UIKit

class StickerGifCollectionViewCell: UICollectionViewCell {
    static let identifier = "stickerCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
