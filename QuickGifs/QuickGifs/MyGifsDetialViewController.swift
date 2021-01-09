//
//  MyGifsDetialViewController.swift
//  QuickGifs
//
//  Created by Sammy Alvarado on 12/17/20.
//

import UIKit

class MyGifsDetialViewController: UIViewController {
    
    var photo: UIImage?
    
    var data: CustomData? {
        didSet {
            guard let data = data else { return }
            gifImageView.image = data.image
        }
    }
    
    static let identifier = "detialGifCell"
    
    private let gifImageView: UIImageView  = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .systemPink
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy private var shareButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        button.backgroundColor = .blue
        button.setTitle("Share Gif", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleShareButton), for: .touchUpInside)
        return button
    }()

    private let editStickerButton: UIBarButtonItem = {
        let editButton = UIBarButtonItem()
        return editButton
    }()

    
    private let stickerCollecdtionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.regis
        cv.register(StickerGifCollectionViewCell.self, forCellWithReuseIdentifier: StickerGifCollectionViewCell.identifier)
        
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .purple
        return cv
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        stickerCollecdtionView.isHidden = true
        
        stickerCollecdtionView.delegate = self
        stickerCollecdtionView.dataSource = self
        
        view.addSubview(shareButton)

        view.addSubview(gifImageView)
//        gifImageView.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 40, width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width * 1.25)
        
//        view.addSubview(addStickerButton)
        
//        addStickerButton.frame = CGRect(x: view.bounds.midX - 62.5, y: (view.safeAreaInsets.top + 60) + (UIScreen.main.bounds.width * 1.25), width: 125, height: 40)
        
        view.addSubview(stickerCollecdtionView)
        
        
        
        NSLayoutConstraint.activate([
            gifImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            gifImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            gifImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            gifImageView.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 150),
            
            shareButton.topAnchor.constraint(equalTo: gifImageView.bottomAnchor, constant: 150),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            shareButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 20),
            
             
        ])
    }
    
    @objc func handleShareButton() {
        let activityVC = UIActivityViewController(activityItems: [data?.image ?? UIImage()], applicationActivities: nil)
                    activityVC.popoverPresentationController?.sourceView = self.view
                    self.present(activityVC, animated: true, completion: nil)
    }
    
//    @objc private func toggledHiddedButton(sender: UIButton){
//        addStickerButton.isSelected.toggle()
//
//        if addStickerButton.isSelected == true {
//            addStickerButton.isHidden = true
//            stickerCollecdtionView.isHidden = false
//        }
//
//
//    }
}

extension MyGifsDetialViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let stickerCell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerGifCollectionViewCell.identifier, for: indexPath) as! StickerGifCollectionViewCell
        stickerCell.backgroundColor = .purple
        
        return stickerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.width / 2 - 20, height: collectionView.bounds.width / 2 - 20)
        return CGSize(width: collectionView.bounds.width / 2.5, height: collectionView.bounds.width / 2
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
