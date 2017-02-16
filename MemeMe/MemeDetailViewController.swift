//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Zhang, David on 2/13/17.
//  Copyright © 2017 Zhang, David. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var detailedMemeImage: UIImageView!
    var meme : Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailedMemeImage.image = meme.memedImage;
    }
    
}
