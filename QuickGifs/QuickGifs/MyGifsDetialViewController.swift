//
//  MyGifsDetialViewController.swift
//  QuickGifs
//
//  Created by Sammy Alvarado on 12/17/20.
//

import UIKit

class MyGifsDetialViewController: UIViewController {
    
    private let gifImageView: UIImageView  = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .systemPink
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let addStickerButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        button.backgroundColor = .green
        button.setTitle("Set Sticker", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let collecdtionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.regis
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(gifImageView)
//        gifImageView.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 40, width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width * 1.25)
        
        view.addSubview(addStickerButton)
//        addStickerButton.frame = CGRect(x: view.bounds.midX - 62.5, y: (view.safeAreaInsets.top + 60) + (UIScreen.main.bounds.width * 1.25), width: 125, height: 40)
        
        NSLayoutConstraint.activate([
        
            gifImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            gifImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gifImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            gifImageView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 150),
            
            addStickerButton.topAnchor.constraint(equalTo: gifImageView.bottomAnchor, constant: 100),
            addStickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addStickerButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 2),
            addStickerButton.heightAnchor.constraint(equalToConstant: view.bounds.height / 20)
//            addStickerButton.leadingAnchor.constraint(equalTo: gifImageView.leadingAnchor, constant: 30),
//            addStickerButton.trailingAnchor.constraint(equalTo: gifImageView.trailingAnchor, constant: -30),
//            addStickerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 40)
        ])
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
