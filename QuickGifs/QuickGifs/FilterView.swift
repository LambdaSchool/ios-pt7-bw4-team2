//
//  ViewController.swift
//  QuickGIFSBuildPractice
//
//  Created by BrysonSaclausa on 12/21/20.
//

import UIKit
import Photos


class FilterViewController: UIViewController {
    
    // MARK: - Properties
    let photo: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    fileprivate let filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
     var filteredImages = [UIImage]() {
        didSet {
            DispatchQueue.main.async {
                self.filterCollectionView.reloadData()
            }
        }
    }
    
    var pickerImage: UIImage? {
        didSet {
            self.filteredImages = makeFilteredPhotos()
        }
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
        "CIComicEffect"
    ]
    
    var context = CIContext(options: nil)
    
    private func makeFilteredPhotos() -> [UIImage] {
        var filteredImages = [UIImage]()
        (0..<CIFilterNames.count).forEach {
            let filter = CIFilter(name: CIFilterNames[$0])
            let newImage = resizeImage(image: pickerImage ?? UIImage(), newWidth: 150)
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
        setupNavBar()
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        addSubviews()
        configureCollectionView()
        configureImageOrVideoView()
    }
    
    
    // MARK: - Helper Methods
    
    func addSubviews() {
        view.addSubview(photo)
        view.addSubview(filterCollectionView)
    }
    
    func setupNavBar() {
        self.navigationItem.title = "Edit GIF View"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddActionSheet(sender:)))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped(sender:)))
    }
    
    @objc func saveTapped(sender: UIBarButtonItem!) {
        print("Save button was tapped!")
        
    }
    
    @objc func showAddActionSheet(sender: UIBarButtonItem!) {
        print("add button was tapped!")
        presentAlert()
        
    }
    
    func configureImageOrVideoView() {
        // Configure
        photo.center.x = view.center.x
        photo.layer.cornerRadius = 10
        photo.clipsToBounds = true
        photo.backgroundColor = .clear
        // Constraints
        photo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1).isActive = true
        photo.bottomAnchor.constraint(equalTo: filterCollectionView.topAnchor, constant: 2).isActive = true
        photo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        photo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    func configureCollectionView() {
        filterCollectionView.backgroundColor = .clear
        filterCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -1).isActive = true
        filterCollectionView.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 2).isActive = true
        filterCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        filterCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 1).isActive = true
        filterCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("Error")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        present(imagePicker, animated: true)
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "Please Choose", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: NSLocalizedString("Take a picture", comment: "Default action"), style: .default, handler: { _ in
        NSLog("Open camera")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Choose from library", comment: "Default action"), style: .default, handler: { _ in
        NSLog("Open camera roll")
        self.presentImagePickerController()
        }))

        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .default, handler: { _ in
        NSLog("Cancel add")
            alert.dismiss(animated: true, completion: nil)
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    
}

extension FilterViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/3.5
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilterCollectionViewCell
        cell.layer.borderWidth = 2
        cell.layer.borderColor = .none
        cell.layer.cornerRadius = 20
        cell.filterPhoto.image = filteredImages[indexPath.item]
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ciImage = CIImage(image: pickerImage!)
        let filter = CIFilter(name: CIFilterNames[indexPath.item])
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let filteredtImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let result = context.createCGImage(filteredtImage, from: filteredtImage.extent)
            self.photo.image = UIImage(cgImage: result!)
            
        }

    }
    
}

extension FilterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            pickerImage = image
        } else if let image = info[.originalImage] as? UIImage {
            pickerImage = image
        }
        photo.image = pickerImage
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

}

class FilterCollectionViewCell: UICollectionViewCell {
    
     let filterPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        imageView.image = UIImage()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(filterPhoto)
        
        filterPhoto.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        filterPhoto.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        filterPhoto.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        filterPhoto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubview(filterPhoto)
    }
    
   
}

