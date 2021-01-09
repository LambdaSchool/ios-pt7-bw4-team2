//
//  ViewController.swift
//  QuickGIFSBuildPractice
//
//  Created by BrysonSaclausa on 12/21/20.
//

import UIKit
import Photos


class FilterViewController: UIViewController {
    
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    @IBOutlet weak var photo: UIImageView!
    
    
     var filteredImages = [UIImage]() {
        didSet {
            DispatchQueue.main.async {
                self.filterCollectionView.reloadData()
            }
        }
    }
    
    var pickerImage: UIImage? {
        didSet {
          pickerImage = pickerImage?.flattened
          self.filteredImages = makeFilteredPhotos()    }
      }
    
    var CIFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISephiaTone",
    ]
    
    var context = CIContext(options: nil)
    
    private func makeFilteredPhotos() -> [UIImage] {
        var filteredImages = [UIImage]()
        (0..<CIFilterNames.count).forEach {
            let filter = CIFilter(name: CIFilterNames[$0])
            let newImage = resizeImage(image: pickerImage ?? UIImage(), newWidth: 150).flattened
            let ciImage = CIImage(image: newImage)
            filter?.setValue(ciImage, forKey: kCIInputImageKey)
            if let filteredtImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let result = context.createCGImage(filteredtImage, from: filteredtImage.extent)
                filteredImages.append(UIImage(cgImage: result!))
            }
        }
        
        return filteredImages
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return newImage!
    }//
   
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = pickerImage?.flattened
        photo.layer.cornerRadius = 15
        photo.clipsToBounds = true
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self

    }
    

    
    @IBAction func saveButton(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(photo.image!, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}//

extension FilterViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (UIScreen.main.bounds.width / 3) - 50
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterImageCollectionViewCell", for: indexPath) as! FilterImageCollectionViewCell
        cell.layer.borderWidth = 2
        cell.layer.borderColor = .none
        cell.layer.cornerRadius = 15
        cell.filterPhoto.image = filteredImages[indexPath.item]
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ciImage = CIImage(image: pickerImage!)
        let filter = CIFilter(name: CIFilterNames[indexPath.item])
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let filteredtImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let result = context.createCGImage(filteredtImage, from: filteredtImage.extent)
            
            self.photo.image = UIImage(cgImage: result!).flattened
            
        }

    }
    
}




