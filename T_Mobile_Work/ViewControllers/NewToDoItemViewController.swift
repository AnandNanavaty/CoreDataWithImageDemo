//
//  NewToDoItemViewController.swift
//  T_Mobile_Work
//
//  Created by Anand Nanavaty on 24/06/20.
//  Copyright © 2020 Anand Nanavaty. All rights reserved.
//

import UIKit
import CoreData

protocol ToDoListLoadDataDelegate {
    func toDoListData()
}

class NewToDoItemViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var itemTitleView: UIView!
    @IBOutlet weak var itemTitleTextField: UITextField!
    @IBOutlet weak var itemDetailTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var profileImageUIView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    //MARK: Objects
    var delegate : ToDoListLoadDataDelegate?
    var profileImageViewData : Data?
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    //MARK: Utility Method
    func setUpUI(){
        itemTitleTextField.placeholder = "Title"
        itemTitleView.layer.cornerRadius = 4.0
        itemTitleView.layer.borderColor = UIColor.lightGray.cgColor
        itemTitleView.layer.borderWidth = 1.0
        itemDetailTextView.delegate = self
        itemDetailTextView.text = "description"
        itemDetailTextView.textColor = UIColor.lightGray
        itemDetailTextView.layer.borderColor = UIColor.lightGray.cgColor
        itemDetailTextView.layer.borderWidth = 1.0
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.masksToBounds = true
    }    
    
    //MARK: // Open Camera and Image picker methods
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            self.popupAlert(title: "T-Mobile", message: "You don't have camera access", actionTitles: ["OK"], actions:[{action1 in}])
        }
    }
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            self.popupAlert(title: "T-Mobile", message: "You don't have permission to access gallery.", actionTitles: ["OK"], actions:[{action1 in}])
        }
    }
    //MARK: Button click action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doneButtonAction(_ sender: UIButton) {
        guard let itemTitle = itemTitleTextField.text , !itemTitle.isEmpty else {
            self.popupAlert(title: "T-Mobile", message: "Please enter item title", actionTitles: ["OK"], actions:[{action1 in}])
            return
        }
        guard let itemDetail = itemDetailTextView.text , !itemDetail.isEmpty, itemDetailTextView?.text != "description" else {
            self.popupAlert(title: "T-Mobile", message: "Please enter item detail", actionTitles: ["OK"], actions:[{action1 in}])
            return
        }
        guard (profileImageViewData != nil) else {
            self.popupAlert(title: "T-Mobile", message: "Please upload an image", actionTitles: ["OK"], actions:[{action1 in}])
            return
        }
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let list = NSEntityDescription.insertNewObject(forEntityName: "ToDoList", into: context) as! ToDoList
            list.title = itemTitle
            list.subTitle = itemDetail
            list.isSelect = "1"
            list.imageData = profileImageViewData
            do {
                try (context.save())            
                self.popupAlert(title: "T-Mobile", message: "New item successfully added.", actionTitles: ["OK"], actions:[{action1 in
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.toDoListData()
                }])
            } catch let err {
                print(err)
            }
        }
    }
    @IBAction func profileImageButtonAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: UITextField delegate methods
extension NewToDoItemViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "description"
            textView.textColor = UIColor.lightGray
        }
    }
}

//MARK: Image Picker delegate method
extension NewToDoItemViewController : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            self.profileImageView.image = pickedImage
            guard let imageData = pickedImage.jpegData(compressionQuality: 1) else {
                print("jpg error")
                return
            }
            self.profileImageViewData = imageData
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
