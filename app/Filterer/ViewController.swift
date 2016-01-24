//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imageProcesor: ImageProcessor = ImageProcessor()
    
    var filteredImage: UIImage?
    var originalImage: UIImage?

    var filterSharpen80:Bool = false
    var filterSepia50:Bool = false
    var filterGreyScale50:Bool = false
    var filterInvert50:Bool = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var secondaryMenu: UIView!
    @IBOutlet weak var bottomMenu: UIView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet weak var filtersContainer: UIStackView!
    
    @IBAction func onOverlayDown() {
        imageView.image = originalImage
    }
    
    @IBAction func onOverlayUpIn() {
        imageView.image = filteredImage
    }
    
    
    @IBAction func onOverlayUpOut() {
        imageView.image = filteredImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        compareButton.enabled = false
        
        originalImage = imageView.image
        filteredImage = imageView.image
        
        // Programatically add a filter button
        let invert:UIButton = UIButton(type: .System)
        invert.setTitle("Invert", forState: .Normal)
        invert.contentMode = UIViewContentMode.ScaleAspectFit
        invert.addTarget(self, action: "onInvert:", forControlEvents:.TouchUpInside)
        filtersContainer.addArrangedSubview(invert)
    }
    
    @IBAction func onCompare(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected {
            imageView.image = originalImage
        } else {
            imageView.image = filteredImage
        }
        enableFilterButtons(!sender.selected)
    }
    
    func enableFilterButtons(isEnabled:Bool) {
        for var filterButton:UIView in filtersContainer.subviews {
            if filterButton is UIButton {
                (filterButton as! UIButton).enabled = isEnabled
            }
        }
    }
    
    @IBAction func onSharpen(sender: UIButton) {
        sender.selected = !sender.selected
        filterSharpen80 = sender.selected
        updateImage()
    }
    
    @IBAction func onSepia(sender: UIButton) {
        sender.selected = !sender.selected
        filterSepia50 = sender.selected
        updateImage()
    }
    
    @IBAction func onGreyScale(sender: UIButton) {
        sender.selected = !sender.selected
        filterGreyScale50 = sender.selected
        updateImage()
    }
    
    @IBAction func onInvert(sender: UIButton) {
        sender.selected = !sender.selected
        filterInvert50 = sender.selected
        updateImage()
    }
    
    func updateImage() {
        var filters = [Filter]()
        if (filterSharpen80) {
            filters.append(Filters.SHARPEN_80)
        }
        if(filterSepia50){
            filters.append(Filters.SEPIA_50)
        }
        if(filterGreyScale50){
            filters.append(Filters.GREY_SCALE_50)
        }
        if(filterInvert50){
            filters.append(Filters.INVERT_50)
        }
        
        if filters.count == 0 {
            compareButton.enabled = false
        } else {
            compareButton.enabled = true
        }
        
        filteredImage  = imageProcesor.apply(originalImage!, filters: filters)
        imageView.image = filteredImage
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }
    
    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }

}

