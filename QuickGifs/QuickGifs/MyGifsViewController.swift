//
//  MyGifsViewController.swift
//  QuickGifs
//
//  Created by Sammy Alvarado on 12/16/20.
//

import UIKit

class MyGifsViewController: UIViewController {
    
    // creating the colletion Think of me draging out the collection to the storyboard
    private let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
//        layout.minimumInteritemSpacing = 2
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
/*
     In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     guard let selectedPath = collectionView else { return }
     if let target = segue.destination as? UserViewController {
     target.selectedUser = selectedPath.row
     }
     }
*/
    

}

extension MyGifsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // calling the collection view view collectionView controller or extention.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let gifCell = collectionView.dequeueReusableCell(withReuseIdentifier: MyGifsCollectionViewCell.identifier, for: indexPath) as! MyGifsCollectionViewCell
        
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
        performSegue(withIdentifier: "MyGifsDetialSegue", sender: nil)
    }
    
}
