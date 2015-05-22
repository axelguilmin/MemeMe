//
//  MMSentMemesCollectionController.swift
//  MemeMe
//
//  Created by Axel Guilmin on 5/21/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import UIKit

class MMSentMemesCollectionController : UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	// MARK: UICollectionDataSource
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return MMDataController.instance.memes.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCell", forIndexPath: indexPath) as! UICollectionViewCell
		
		let meme = MMDataController.instance.memes[indexPath.item]
		
		let imageView = cell.viewWithTag(101) as! UIImageView
		imageView.image = meme.meme
		
		return cell
	}

	// MARK: UICollectionViewDelegateFlowLayout
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		let size = self.view.frame.size.width / 3.2
		return CGSize(width: size, height: size)
	}
	
	// MARK: UIViewController
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showMemeDetail" {
			let detailVS = segue.destinationViewController as! MMMemeDetailViewController
			let indexPath = self.collectionView!.indexPathForCell(sender as! UICollectionViewCell)
			detailVS.meme = MMDataController.instance.memes[indexPath!.item]
			
		}
	}
	
	override func viewWillAppear(animated: Bool) {
		self.collectionView!.reloadData()
		super.viewWillAppear(animated)
	}

	/** TODO: fixme
	 * This is an ugly way to fix the problem of the UICollectionView going under the UINavigationBar at the first display
	 */
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		let navBarHeight:CGFloat? = self.navigationController?.navigationBar.frame.height
		let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
		let offsetY = navBarHeight! + statusBarHeight
		
		self.collectionView!.contentInset = UIEdgeInsetsMake(offsetY, 0, 0, 0)
		self.collectionView!.contentOffset = CGPoint(x: 0, y: -offsetY)
		self.collectionView!.scrollIndicatorInsets.top = offsetY
	}
}