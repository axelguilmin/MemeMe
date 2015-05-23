//
//  MMSentMemesTableViewController.swift
//  MemeMe
//
//  Created by Axel Guilmin on 5/10/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import UIKit

class MMSentMemesTableViewController : UITableViewController, UITableViewDataSource {

	// MARK: UITableViewDataSource
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return MMDataController.instance.memes.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let meme = MMDataController.instance.memes[indexPath.row]
		
		var cell = tableView.dequeueReusableCellWithIdentifier("memeCell") as! UITableViewCell
		
		let imageView = cell.viewWithTag(101) as! UIImageView
		let label = cell.viewWithTag(102) as! UILabel

		imageView.image = meme.meme
		label.text = (meme.top as String) + " " + (meme.bottom as String)
		
		return cell
	}
	
	override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
	}

	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			MMDataController.instance.memes.removeAtIndex(indexPath.row)
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
			tableView.reloadData()
		}
	}
	
	// MARK: UIViewController
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showMemeDetail" {
			let detailVS = segue.destinationViewController as! MMMemeDetailViewController
			let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell)
			detailVS.meme = MMDataController.instance.memes[indexPath!.row]
			
		}
	}
}
