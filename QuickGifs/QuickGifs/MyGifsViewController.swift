//
//  MyGifsViewController.swift
//  QuickGifs
//
//  Created by Sammy Alvarado on 12/16/20.
//

import UIKit

struct CustomData {
    var image: UIImage
}

class MyGifsViewController: UIViewController {
    
    var image: UIImage?
    
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
    }
    
    

    
    // MARK: - Navigation
//    func performSegue(withIdentifier: MyGifsDetialSegue, sender: nil) {
//
//    }
    
//     In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     guard let selectedPath = collectionView else { return }
//     if let target = segue.destination as? UserViewController {
//     target.selectedUser = selectedPath.row
//     }
//     }
   
//     override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
//             if segue!.identifier == "Details" {
//                 let viewController:ViewController = segue!.destinationViewController as ViewController
//                 let indexPath = self.tableView.indexPathForSelectedRow()
//                 viewController.pinCode = self.exams[indexPath.row]
//
//             }
//
//         }
  
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let detailVC = segue.destination as! MyGifsDetialViewController
//        detailVC.photo = self.im
//
//        detailVC.photo?.images
//    }
    

}

extension MyGifsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // calling the collection view view collectionView controller or extention.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let gifCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyGifsCollectionViewCell.identifier, for: indexPath) as! MyGifsCollectionViewCell
        gifCell.data = self.testData[indexPath.row]
        return gifCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width / 2 - 20, height: collectionView.bounds.width / 2 - 20)
    
        
//        if indexPath == [0,0] {
//            return CGSize(width: collectionView.bounds.width / 2 - 10, height: collectionView.bounds.width / 2 - 10)
//        } else if indexPath == [0,1] {
//            return CGSize(width: collectionView.bounds.width / 2 - 10, height: collectionView.bounds.width / 2 - 10)
//        } else {
//
//            return CGSize(width: collectionView.bounds.width / 2 - 10, height: collectionView.bounds.width / 2 - 10)
//        }
        
        
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 1
//        // Horiontal spacing between cells
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
        // Vertcal spacing between cells
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = testData[indexPath.item].image
        self.image = photo
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let detialVC = storyboard.instantiateViewController(identifier: "MyGifsDetialViewController") as! MyGifsDetialViewController
//        let tabNC = storyboard.instantiateViewController(identifier: "gifTabNC") as! UINavigationController

        
        detialVC.data = CustomData.init(image: self.image ?? UIImage())
//        navigationController?.pushViewController(detialVC, animated: true)
        present(detialVC, animated: true, completion: nil)

        
        
//        performSegue(withIdentifier: "MyGifsDetialSegue", sender: self)
        
    
    }
    
}
