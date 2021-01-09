//
//  MyGifsViewController.swift
//  QuickGifs
//
//  Created by Sammy Alvarado on 12/16/20.
//

import UIKit
import Photos

struct CustomData {
    var image: UIImage
}

class MyGifsViewController: UIViewController {
    
    var image: UIImage?
    var imageArray = [UIImage]()
    
    let testData = [
        CustomData(image: #imageLiteral(resourceName: "john-ko-K7fUYVvmLxk-unsplash")),
        CustomData(image: #imageLiteral(resourceName: "field-inside-the-emblem-with-cow-mountain-and-plant-892ld")),
        CustomData(image: #imageLiteral(resourceName: "green-tree-plant-bio-organic-seed-logo-vector-17102220")),
        CustomData(image: #imageLiteral(resourceName: "leaf-plant-logo-ecology-people-wellness-green-leaves-nature-symbol-icon-set-designs-health-logo-template-business-leaf-107966551")),
        CustomData(image: #imageLiteral(resourceName: "john-ko-K7fUYVvmLxk-unsplash"))
    ]
        
    // creating the colletion Think of me draging out the collection to the storyboard
    private let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MyGifsCollectionViewCell.self, forCellWithReuseIdentifier: MyGifsCollectionViewCell.identifier)
        
        cv.contentInset = UIEdgeInsets(top: 20, left: 15, bottom: 0, right: 15)
        
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
        authorizationCode { (status) in
            if status {
                self.grapPhotos()
            } else {
                print("not authorized")
            }
        }
    }

    
    // MARK: - Navigation
    
    func authorizationCode(completion: @escaping (Bool) -> Void) {
        
        guard PHPhotoLibrary.authorizationStatus() != .authorized else {
          completion(true)
          return
        }
        // 2
        PHPhotoLibrary.requestAuthorization { status in
            completion(status == .authorized)
        }
        
    }//
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func grapPhotos() {
       
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
         let fetchResult : PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        if fetchResult.count > 0 {
            
            for i in 0..<fetchResult.count {
                imgManager.requestImage(for: fetchResult.object(at: i) , targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: requestOptions) { (image, error) in
                    
                    self.imageArray.append(image!)
                    
                }
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        } else {
            print("You got no photos")
            collectionView.reloadData()
        }
        
        
    }//
    

}

extension MyGifsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // calling the collection view view collectionView controller or extention.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let gifCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyGifsCollectionViewCell.identifier, for: indexPath) as! MyGifsCollectionViewCell
        let imageView = gifCell.viewWithTag(1) as! UIImageView
        imageView.image = imageArray[indexPath.row]
//        gifCell.data = self.testData[indexPath.row]
        return gifCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width / 2 - 20, height: collectionView.bounds.width / 2 - 20)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
        // Vertcal spacing between cells
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let photo = testData[indexPath.item].image
        let photo = imageArray[indexPath.item]
        self.image = photo
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let detialVC = storyboard.instantiateViewController(identifier: "MyGifsDetialViewController") as! MyGifsDetialViewController
//        let tabNC = storyboard.instantiateViewController(identifier: "gifTabNC") as! UINavigationController
        detialVC.data = CustomData.init(image: self.image ?? UIImage())
//        navigationController?.pushViewController(detialVC, animated: true)
        present(detialVC, animated: true, completion: nil)
        
    
    }
    
}
