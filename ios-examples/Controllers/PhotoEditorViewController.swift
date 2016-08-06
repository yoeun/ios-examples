//
//  PhotoEditorViewController.swift
//  ios-examples
//
//  Created by Yoeun Pen on 8/6/16.
//  Copyright © 2016 Yoeun Pen. All rights reserved.
//

import UIKit
import GPUImage

class PhotoEditorViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
}

extension PhotoEditorViewController: UINavigationControllerDelegate {
    
}

extension PhotoEditorViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        let imageSource = GPUImagePicture(image: image)
        let filter = GPUImageSepiaFilter()
        
        imageSource.addTarget(filter)
        filter.useNextFrameForImageCapture()
        imageSource.processImage()
        
        imageView.image = filter.imageFromCurrentFramebuffer()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}