//
//  MMMeme.swift
//  MemeMe
//
//  Created by Axel Guilmin on 5/2/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import UIKit

struct MMMeme {
	/// The image used to create the meme, without the text
	var original :UIImage
	/// The "memed" image
	var meme :UIImage
	/// Text displayed on top of the meme
	var top :NSString
	/// Text displayed on bottom of the meme
	var bottom :NSString
}