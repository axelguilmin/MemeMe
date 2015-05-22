//
//  MMSentMemesViewController.swift
//  MemeMe
//
//  Created by Axel Guilmin on 5/8/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import UIKit

class MMSentMemesViewController: UITabBarController {
	
	// MARK: Properties
	
	// MARK: Outlet
	
	// MARK: Layout
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Hack to make the navigation bar more transparent from http://stackoverflow.com/a/12389579/1327557
		let navBarBackground = self.navigationController?.navigationBar.subviews[0] as UIView?
		navBarBackground?.alpha = 0.85
	}

	override func viewDidAppear(animated: Bool) {
		if MMDataController.instance.memes.count < 1 {
			self.performSegueWithIdentifier("createAMeme", sender: self)
		}
		super.viewDidAppear(animated)
	}
}