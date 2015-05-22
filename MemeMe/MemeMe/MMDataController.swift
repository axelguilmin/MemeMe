//
//  MMDataController.swift
//  MemeMe
//
//  Created by Axel Guilmin on 5/10/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import Foundation

class MMDataController {
	
	/// TODO: use Swift 1.2 syntax "static let sharedInstance = Singleton()"
	class var instance: MMDataController {
		struct Static {
			static let instance: MMDataController = MMDataController()
		}
		return Static.instance
	}
	
	var memes = [MMMeme]()
}