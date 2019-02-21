//
//  PostViewController.swift
//  FakeInstagram
//
//  Created by ChenMo on 2/20/19.
//  Copyright © 2019 ChenMo. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var captionField: UITextField!
    
    @IBAction func onPost(_ sender: Any) {
        let post = PFObject(className: "Post")
        
        post["caption"] = captionField.text!
        post["author"] = PFUser.current()
        
        let imageData = imageView.image!.jpegData(compressionQuality: 1.0)
        post["image"] = PFFileObject(data: imageData!)
        post.saveInBackground {(success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("post saved")
            } else {
                print("cannot save post")
            }
        }
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width:200, height:200)
        let scaledImage = image.af_imageAspectScaled(toFit: size)
        
        imageView.image = scaledImage
        
        // the picker won't dismiss and will be stuck without this line
        dismiss(animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
