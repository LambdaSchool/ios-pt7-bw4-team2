//
//  MyGifsDetialViewController.swift
//  QuickGifs
//
//  Created by Sammy Alvarado on 12/17/20.
//

import UIKit

class MyGifsDetialViewController: UIViewController {
    
   // Outlets
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var shareBTN: UIButton!
    
    
   // Properties
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = image
        
        photo.layer.cornerRadius = 15
        photo.clipsToBounds = true
        shareBTN.layer.cornerRadius = 15
        shareBTN.clipsToBounds = true
    }
    
    
    @IBAction func shareButton(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [image!], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
    }
    
}// CLASS


