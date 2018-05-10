//
//  ImageContentViewController.swift
//  AppStoreHomeInteractiveTransition
//
//  Created by Ramiro on 09/05/2018.
//  Copyright © 2018 Wirawit Rueopas. All rights reserved.
//

import UIKit

class ImageContentViewController: UIViewController {
    
    @IBOutlet weak var bkImageView: UIImageView!
    
    var pageIndex: Int?
    var titleText : String!
    var imageName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bkImageView.image = UIImage(named: imageName)
    }
}
