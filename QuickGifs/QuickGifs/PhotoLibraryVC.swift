//
//  PhotoLibraryVC.swift
//  QuickGifs
//
//  Created by Norlan Tibanear on 1/6/21.
//

import UIKit

class PhotoLibraryVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var photo: UIImageView!
    
    
    // Properties
    var image: UIImage? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        setupImageView()
    }
    
    func setupImageView() {
        photo.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        photo.addGestureRecognizer(tapGesture)
    }//
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }//
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFilterVCSegue" {
            let filterVC = segue.destination as! FilterViewController
            filterVC.pickerImage = self.image
        }
    }
    

}//


extension PhotoLibraryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            image = imageSelected
            photo.image = imageSelected
        }
        
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            image = imageOriginal
            photo.image = imageOriginal
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}//
