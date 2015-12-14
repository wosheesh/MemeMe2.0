
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
    
    var memes : [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewWillAppear(animated: Bool) {
        collectionView!.reloadData()
    }
    
    override func viewDidLoad() {
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
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