//
//  MemeEditorViewController.swift
//  photoPick
//
//  Created by Wojtek Materka on 01/12/2015.
//  Copyright © 2015 Wojtek Materka. All rights reserved.
//

import UIKit

var activeField: UITextField?

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var takePictureButton: UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var bottomNavBar: UIToolbar!
    @IBOutlet weak var topNavBar: UIToolbar!
    @IBOutlet weak var scrollSpace: UIScrollView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var memeContainer: UIView!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -4.0,
    ]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // making sure we disable the option to use the camera if the device doesn't support it
        
        takePictureButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    
    override func viewDidLoad() {
        prepTextFields(textFieldTop, text: "TOP")
        prepTextFields(textFieldBottom, text: "BOTTOM")
    }
    
    
    func prepTextFields(textField: UITextField, text: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
        textField.clearsOnBeginEditing = true
        textField.text = text
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
// USER ACTIONS

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // load the image view with the selected image
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // making sure the photo gallery or camera view is dismissed
        dismissViewControllerAnimated(true, completion: nil)
    }


    @IBAction func pickAnImage(sender: AnyObject) {
        // Action to launch the image gallery
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func takeAnImageWithCamera(sender: AnyObject) {
        // Action to launch the camera module and allow the user to take their own photo
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
//    Cancel behaves more intuitively. 
//    Canceling while editing a textlabel only cancels the edition not the image and other field
    @IBAction func cancelEditing(sender: AnyObject) {
        shareButton.enabled = false
        
        if activeField?.isFirstResponder() == true {
            activeField!.resignFirstResponder()
        } else {
            imagePickerView.image = nil
            prepTextFields(textFieldTop, text: "TOP")
            prepTextFields(textFieldBottom, text: "BOTTOM")
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    
// MEME CREATION functions
    
    @IBAction func shareMeme(sender: AnyObject) {
//        TODO: After sharing user should be taken back to sent memes view
        let memeToShare = save()
        let objectsToShare = [memeToShare.memedImage as AnyObject]

        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.completionWithItemsHandler = {
            (activity, success, returnedItems, error) in
            print("Activity: \(activity) Success: \(success) Items: \(returnedItems) Error: \(error)")
            
            if success == true {
                // add meme to the memes array
                let object = UIApplication.sharedApplication().delegate
                let appDelegate = object as! AppDelegate
                appDelegate.memes.append(memeToShare)
                print("meme added to memes")
                
                // dismiss the meme editor if sharing happened
                self.dismissViewControllerAnimated(true, completion: nil)
            }

        }
        
        presentViewController(activityVC, animated: true, completion: nil)
    }
    
    
    func save() -> Meme {
        // Create the meme
        let meme = Meme(topText: textFieldTop.text, bottomText: textFieldBottom.text, image: imagePickerView.image, memedImage: generateMemedImage())
        
        return meme
    }
    
    
    func generateMemedImage() -> UIImage {
        // capture the screen within the memeContainer view after hiding the navigation toolbars
        topNavBar.hidden = true
        bottomNavBar.hidden = true
        
        UIGraphicsBeginImageContext(memeContainer.bounds.size)
        memeContainer.drawViewHierarchyInRect(memeContainer.bounds, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        topNavBar.hidden = false
        bottomNavBar.hidden = false
        
        return memedImage
    }
    
    
// KEYBOARD Notifications and controls
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        // Using scrollView as a solution to keyboard overlaying the textfield
        
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = view.convertRect(keyboardFrame, fromView: nil)
        
        var contentInset:UIEdgeInsets = scrollSpace.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollSpace.contentInset = contentInset
        
    }
    

    func keyboardWillHide(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        
        let contentInset:UIEdgeInsets = UIEdgeInsetsZero
        scrollSpace.contentInset = contentInset
        
    }
    

// TEXTFIELD DELEGATE functions
//    TODO: Fix the capitalization not working - solved: it works on an actual iPhone but not on simulator.

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeField = textField
    }
    
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        shareButton.enabled = true
        return true
    }
    
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        activeField = nil
        // make sure that the textField text doesn't clear after user input... only the default text will clear
        // TODO: consider using .attributedPlaceholder property
        
        textField.clearsOnBeginEditing = false
    }
    
// IMAGE GESTURES FUNCTIONS -
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x, y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    @IBAction func handlePinch(recognizer: UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = CGAffineTransformScale(view.transform, recognizer.scale, recognizer.scale)
            recognizer.scale = 1
        }
    }
    
    // when doubletapped return the image to its original size
    @IBAction func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        recognizer.numberOfTapsRequired = 2
        
        imagePickerView.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMidY(view.bounds));
        imagePickerView.transform = CGAffineTransformIdentity;
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}