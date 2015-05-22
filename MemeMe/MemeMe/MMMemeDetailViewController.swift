//
//  MMMemeDetailViewController.swift
//  MemeMe
//
//  Created by Axel Guilmin on 5/16/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import UIKit

class MMMemeDetailViewController : UIViewController {
	
	@IBOutlet private weak var _memeImageView: UIImageView!
	
	var meme: MMMeme?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if let image:UIImage = meme?.meme {
			_memeImageView.image = image
		}
	}
}
