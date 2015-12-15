
//
//  SentMemesCollectionViewController.swift
//  photoPick
//
//  Created by Wojtek Materka on 13/12/2015.
//  Copyright © 2015 Wojtek Materka. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes : [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    
    override func viewWillAppear(animated: Bool) {
        collectionView!.reloadData()
    }
    
    
    func adjustFlowSize(size: CGSize) {
        let space: CGFloat = 3.0
        
        let dimension:CGFloat = size.width >= size.height ? (size.width - (5 * space)) / 6.0 :  (size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initial flow size adjustment
        adjustFlowSize(self.view.frame.size)

    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        //adjust spacing and size when device changes orientation
        adjustFlowSize(size)

    }

    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        cell.MemeCellImage.image = meme.memedImage
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("collection item selected")
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("memeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.item]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}