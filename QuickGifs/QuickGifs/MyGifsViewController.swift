//
//  MyGifsViewController.swift
//  QuickGifs
//
//  Created by Sammy Alvarado on 12/16/20.
//

import UIKit
import Photos


class MyGifsViewController: UIViewController {
    
    // Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // Properties
    var imageArray = [UIImage]()
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        authorizationCode { (status) in
            if status {
                self.grapPhotos()
            } else {
                print("not authorized")
            }
        }
        
    }//
    
    
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
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gifsDetailVC  = segue.destination as! MyGifsDetialViewController
        gifsDetailVC.image = self.image
//        gifsDetailVC.photo.image = self.image
    }

}// CLASS

extension MyGifsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = imageArray[indexPath.row]
        cell.backgroundColor = .red
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 2 - 1.0
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let indexpath = collectionView.indexPathsForSelectedItems?.first
        let photo = imageArray[indexPath.item]
        self.image = photo
        performSegue(withIdentifier: "MyGifsDetialSegue", sender: self)
        
        print("You tapped me")
        
    }
    
}
