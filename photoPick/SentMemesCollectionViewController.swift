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
}