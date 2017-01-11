//
// DetailViewController.swift
//  meme
//
//  Created by 政达 何 on 2017/1/11.
//  Copyright © 2017年 政达 何. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  var memed : Meme!  
  @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.image = memed.memedImage
    }

}
