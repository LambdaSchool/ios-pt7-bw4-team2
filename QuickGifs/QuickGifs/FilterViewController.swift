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
    
    // MARK: - Properties
//    var photo: gifImageView = {
//        let image = gifImageView()
//        image.contentMode = .scaleAspectFill
//        image.translatesAutoresizingMaskIntoConstraints = false
//        return image
//    }()
//
//    fileprivate let filterCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.translatesAutoresizingMaskIntoConstraints = false
//        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
//        return cv
//    }()
//
//    let topView: UIView = {
//       let view = UIView()
//        view.backgroundColor = .systemPink
//        return view
//    }()
    
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
    
    
//    var pickerImage: UIImage? {
//        didSet {
//            self.filteredImages = makeFilteredPhotos()
//        }
//    }
    
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

//extension FilterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[.editedImage] as? UIImage {
//            pickerImage = image
//        } else if let image = info[.originalImage] as? UIImage {
//            pickerImage = image
//        }
//        photo.image = pickerImage
//        dismiss(animated: true)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true)
//    }
//
//}

//class FilterCollectionViewCell: UICollectionViewCell {
//    
//     let filterPhoto: UIImageView = {
//        let imageView = UIImageView()
//        imageView.backgroundColor = UIColor.white
//        imageView.image = UIImage()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 20
//        return imageView
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: .zero)
//        contentView.addSubview(filterPhoto)
//        
//        filterPhoto.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        filterPhoto.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
//        filterPhoto.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
//        filterPhoto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func addViews() {
//        addSubview(filterPhoto)
//    }
//    
//   
//}//




