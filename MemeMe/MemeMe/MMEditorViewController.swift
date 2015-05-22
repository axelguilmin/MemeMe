//
//  MMEditorViewController.swift
//  MemeMe
//
//  Created by Axel Guilmin on 5/2/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import UIKit
import AVFoundation

class MMEditorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

	// MARK: Properties
	
	private var _topConstraint: NSLayoutConstraint!
	private var _bottomConstraint: NSLayoutConstraint!
	
	// MARK: Outlet
	
	@IBOutlet private weak var _top: UITextField!
	@IBOutlet private weak var _bottom: UITextField!
	@IBOutlet private weak var _camera: UIBarButtonItem!
	@IBOutlet private weak var _cancel: UIBarButtonItem!
	@IBOutlet private weak var _imagePicker: UIImageView!
	@IBOutlet private weak var _toolbar: UIToolbar!
	@IBOutlet private weak var _navigationBar: UINavigationBar!
	
	// MARK: Layout
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		_camera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		let memeTextAttributes = [
			NSStrokeColorAttributeName : UIColor.blackColor(),
			NSForegroundColorAttributeName : UIColor.whiteColor(),
			NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
			// see http://stackoverflow.com/q/16047901/1327557
			NSStrokeWidthAttributeName : -4.0,
		]

		let placeholderTextAttributes = [
			NSStrokeColorAttributeName : UIColor.blackColor().colorWithAlphaComponent(0.8),
			NSForegroundColorAttributeName : UIColor.whiteColor().colorWithAlphaComponent(0.8),
			NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
			NSStrokeWidthAttributeName : -4.0,
		]
		
		_top.defaultTextAttributes = memeTextAttributes
		_top.attributedPlaceholder = NSAttributedString(string: "TOP", attributes: placeholderTextAttributes)
		_top.textAlignment = .Center;
		_top.delegate = self;
		
		_bottom.defaultTextAttributes = memeTextAttributes
		_bottom.attributedPlaceholder = NSAttributedString(string: "BOTTOM", attributes: placeholderTextAttributes)
		_bottom.textAlignment = .Center;
		_bottom.delegate = self;
		
		_cancel.enabled = MMDataController.instance.memes.count > 0
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layoutLabels()
	}
	
	override func viewWillDisappear(animated: Bool) {
		NSNotificationCenter.defaultCenter().removeObserver(self);
		super.viewWillDisappear(animated)
	}
	
	override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
		super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
		_top.hidden = true
		_bottom.hidden = true
	}
	
	// TODO: this method is deprecated
	// use https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIContentContainer_Ref/index.html#//apple_ref/occ/intfm/UIContentContainer/viewWillTransitionToSize:withTransitionCoordinator:
	override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
		super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
		layoutLabels()
		_top.hidden = false
		_bottom.hidden = false
	}
	
	/// Position the meme labels at the best place possible
	private func layoutLabels() {
		// Remove previous contraint if some
		if _topConstraint != nil {
			self.view.removeConstraint(_topConstraint)
		}
		if _bottomConstraint != nil {
			self.view.removeConstraint(_bottomConstraint)
		}
		
		// Position of the image inside the imageView
		let size = _imagePicker.image != nil ? _imagePicker.image!.size : _imagePicker.frame.size
		let frame = AVMakeRectWithAspectRatioInsideRect(size, _imagePicker.bounds);
		
		// The texts are diplayed inside the image, at 14% of border
		let margin = frame.origin.y + frame.size.height * 0.14
		
		_topConstraint = NSLayoutConstraint(
			item: _top,
			attribute: .Top,
			relatedBy: .Equal,
			toItem: _imagePicker,
			attribute: .Top,
			multiplier: 1.0,
			constant: margin)
		self.view.addConstraint(_topConstraint)
		
		_bottomConstraint = NSLayoutConstraint(
			item: _bottom,
			attribute: .Bottom,
			relatedBy: .Equal,
			toItem: _imagePicker,
			attribute: .Bottom,
			multiplier: 1.0,
			constant: -margin)
		self.view.addConstraint(_bottomConstraint)
	}
	
	// MARK: Action
	
	@IBAction func takeAPicture(sender: AnyObject) {
		let pickerVC = UIImagePickerController()
		pickerVC.delegate = self
		pickerVC.sourceType = .Camera
		pickerVC.allowsEditing = true
		pickerVC.showsCameraControls = true;
		self.presentViewController(pickerVC, animated: true, completion: nil)
	}
	
	@IBAction func pickAnImage(sender: AnyObject) {
		let pickerVC = UIImagePickerController()
		pickerVC.delegate = self
		pickerVC.sourceType = .PhotoLibrary
		self.presentViewController(pickerVC, animated: true, completion: nil)
	}
	
	@IBAction func share(sender: AnyObject) {
		_top.resignFirstResponder()
		_bottom.resignFirstResponder()
		let generatedMeme:MMMeme? = generateMeme()
		if let meme = generatedMeme {
			MMDataController.instance.memes.append(meme)

			let activityVC = UIActivityViewController(activityItems: [meme.meme], applicationActivities: nil);
			self.presentViewController(activityVC, animated:true, completion: nil)
			
			_cancel.enabled = true
		}
	}
	
	@IBAction func pop(sender: UIBarButtonItem) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	// MARK: Notification
	
	func keyboardWillShow(notification: NSNotification) {
		if _bottom.isFirstResponder() {
			self.view.frame.origin.y -= getKeyboardHeight(notification)
		}
	}
	
	func keyboardWillHide(notification: NSNotification) {
		self.view.frame.origin.y = 0
	}
	
	// MARK: UIImagePickerControllerDelegate
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
		if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
			_imagePicker.image = image
		} else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			_imagePicker.image = image
		}
	
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	// MARK: UITextViewDelegate

	/// called when 'return' key pressed. return NO to ignore.
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true;
	}
	
	// MARK:  UIResponder
	
	/// Hides keyboard when another part of layout was touched
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
		self.view.endEditing(true)
		super.touchesBegan(touches, withEvent: event)
	}

	// MARK: Method
	
	private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue // of CGRect
		return keyboardSize.CGRectValue().height
	}
	
	/// Take a screenshot to generate a MMMeme
	// TODO: fix the graphical glitch
	// http://stackoverflow.com/questions/26070420/ios8-scale-glitch-when-calling-drawviewhierarchyinrect-afterscreenupdatesyes
	// http://stackoverflow.com/questions/23157653/drawviewhierarchyinrectafterscreenupdates-delays-other-animations
	private func generateMeme() -> MMMeme? {
		if let image = _imagePicker.image {

			_toolbar.hidden = true
			_navigationBar.hidden = true
			
			// Frame of the UIImage
			var frame = AVMakeRectWithAspectRatioInsideRect(image.size, _imagePicker.bounds);
			// Note: the values returned by `AVMakeRectWithAspectRatioInsideRect` are not integrals, the `ceil` and `floor` are here to avoid capturing 1pixel (or half a point..) more than the image
			frame = CGRectMake(ceil(frame.origin.x), ceil(frame.origin.y), floor(frame.size.width), floor(frame.size.height))

			// Render view to an image
			UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
			self.view.drawViewHierarchyInRect(CGRectMake(-frame.origin.x, -frame.origin.y, self.view.frame.size.width, self.view.frame.size.height), afterScreenUpdates: true)
			let memedImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
			_toolbar.hidden = false
			_navigationBar.hidden = false
			
			return MMMeme(original: image, meme: memedImage, top: _top.text, bottom: _bottom.text)
		}
		else { // _imagePicker.image is nil
			print("Can't generate a meme with no image")
		}
		
		return nil
	}
}

