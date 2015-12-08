//
//  memeModel.swift
//  photoPick
//
//  Created by Wojtek Materka on 04/12/2015.
//  Copyright © 2015 Wojtek Materka. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    // Properties
    
    var topText: String?
    var bottomText: String?
    var image: UIImage?
    var memedImage: UIImage
    
    // Initialisation
    init (topText: String?, bottomText: String?, image: UIImage?, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
        
    }
}