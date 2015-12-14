//
//  MemeDetailViewController.swift
//  photoPick
//
//  Created by Wojtek Materka on 14/12/2015.
//  Copyright © 2015 Wojtek Materka. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    var meme: Meme!
    
    @IBOutlet weak var memeDetailImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = false
        memeDetailImage.image = meme.memedImage
    }

}
