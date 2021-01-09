//
//  MyGifsCollectionViewCell.swift
//  QuickGifs
//
//  Created by Sammy Alvarado on 12/16/20.
//

import UIKit

class MyGifsCollectionViewCell: UICollectionViewCell {
    
    var data: CustomData? {
        didSet {
            guard let data = data else { return }
            gifImageView.image = data.image
        }
    }
    
    static let identifier = "gifCell"
    
    private let gifImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "john-ko-K7fUYVvmLxk-unsplash")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tag = 1
        
        return imageView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
              
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .purple
        contentView.addSubview(gifImageView)
        gifImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        gifImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        gifImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        gifImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder) // This will allow me to use storyboard and programmatic UI.
//        fatalError("Storyboard is for clones") // This will allow us to crash the app if someone trys to use the storyboard.
    }
}
