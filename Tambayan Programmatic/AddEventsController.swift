//
//  AddEventsController.swift
//  Tambayan Programmatic
//
//  Created by Rey Cerio on 2017-01-26.
//  Copyright © 2017 CeriOS. All rights reserved.
//

import UIKit
import Firebase

class AddEventsController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var eventImageStringUrl: String?
    
    var placeholderLabel: UILabel?
    
    let eventsCategory = ["Sports", "Music", "Food", "Tech", "Education", "Business", "Outdoors", "Lazy Sunday", "Misc"]
    
    var category: String?   //used for pickerView
    
    let eventTitleTextField: UITextField = {
        
        let titleTextField = UITextField()
        titleTextField.borderStyle = .roundedRect
        titleTextField.placeholder = "Event title..."
        return titleTextField
    }()
    
    var descriptionTextView: UITextView!
    
    let eventLocation: UITextField = {
        let locationTextField = UITextField()
        locationTextField.borderStyle = .roundedRect
        locationTextField.placeholder = "Exact address please..."
        return locationTextField
    }()
    
    let eventImage: UIImageView = {
        let eventImage = UIImageView()
        eventImage.contentMode = .scaleAspectFill
        eventImage.layer.cornerRadius = 5
        eventImage.layer.masksToBounds = true
        eventImage.image = UIImage(named: "ringo")
        eventImage.isUserInteractionEnabled = true
        return eventImage
        
    }()
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        return dp
    }()
    
    lazy var categoryPicker: UIPickerView = {
        let cp = UIPickerView()
        cp.delegate = self
        cp.dataSource = self
        cp.showsSelectionIndicator = true
        return cp
    }()
    
    func setupViews() {
        
        //textView with a floating placeholder labell
        descriptionTextView = UITextView()
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.masksToBounds = true
        descriptionTextView.font = UIFont.systemFont(ofSize: 13)
        descriptionTextView.delegate = self
        
        
        placeholderLabel = UILabel()
        placeholderLabel?.text = "Enter some text..."
        placeholderLabel?.font = UIFont.italicSystemFont(ofSize: (descriptionTextView.font?.pointSize)!)
        placeholderLabel?.sizeToFit()
        descriptionTextView.addSubview(placeholderLabel!)
        placeholderLabel?.frame.origin = CGPoint(x: 5, y: (descriptionTextView.font?.pointSize)! / 2)
        placeholderLabel?.textColor = UIColor.lightGray
        placeholderLabel?.isHidden = !descriptionTextView.text.isEmpty
        
        view.addSubview(eventTitleTextField)
        view.addSubview(descriptionTextView)
        view.addSubview(eventLocation)
        view.addSubview(eventImage)
        view.addSubview(datePicker)
        view.addSubview(categoryPicker)
        
        view.addConstraintsWithFormat(format: "V:|-70-[v0(35)]-5-[v1(90)]-5-[v2(35)]-5-[v3(200)]-5-[v4(50)]-5-[v5(50)]", views: eventTitleTextField, descriptionTextView, eventLocation, eventImage, datePicker, categoryPicker)
        
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: eventTitleTextField)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: descriptionTextView)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: eventLocation)
        view.addConstraintsWithFormat(format: "H:|-110-[v0(150)]", views: eventImage)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: datePicker)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: categoryPicker)
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(handleSubmitEventImageToStorage))
        eventImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectEventImage)))
        
        category = eventsCategory[0]
        
        setupViews()

    }
    
    //alert Popup (gonna be used for when not admin and missing a field)
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    
    func handleSubmit(values: [String: AnyObject]) {
        
        //handle the submit button here...
        //guard let eCategory = category else {return}
        let ref = FIRDatabase.database().reference().child("events")
        let childref = ref.childByAutoId()
        childref.updateChildValues(values) { (error, reference) in
            if let err = error {
                self.createAlert(title: "Could not submit event!", message: err as! String)
                return
            }
            guard let eCategory = self.category else {return}
            let eventId = childref.key
            FIRDatabase.database().reference().child("categories").child(eCategory).updateChildValues([eventId: 1])
            
            self.createAlert(title: "Event submitted!", message: "Check out you newly posted event!")
            self.descriptionTextView.text = nil
            self.eventLocation.text = nil
            self.eventTitleTextField.text = nil
            self.datePicker.setDate(Date(), animated: false)
            self.categoryPicker.selectRow(0, inComponent: 0, animated: true)
            self.category = self.eventsCategory[0]
        }
        
    }
    
    func handleSubmitEventImageToStorage() {
        
        let eventImageName = NSUUID().uuidString
        
        let storageRef = FIRStorage.storage().reference().child("eventImage").child("\(eventImageName)")
        
        if let image = eventImage.image, let uploadImage = UIImageJPEGRepresentation(image, 0.1) {
            
            storageRef.put(uploadImage, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    
                    print("Could not save image: ", error ?? "")
                    return
                }
                
                if let eventUrl = metadata?.downloadURL()?.absoluteString {
                    self.eventImageStringUrl = eventUrl
                    self.assigningValuesToBeStoredToDatabase()
                    
                }
                
            })
            
        }
        
    }
    
    func assigningValuesToBeStoredToDatabase() {
        
        
        guard let title = eventTitleTextField.text else {return}
        guard let desc = descriptionTextView.text else {return}
        guard let location = eventLocation.text else {return}
        guard let image = eventImageStringUrl as String? else {return}
        guard let myTimeStamp = datePicker.date as Date? else {return}
        guard let eventCategory = category as String? else {return}
        
        let eventDate =   myTimeStamp.timeIntervalSince1970
        let dateString = String(describing: eventDate)

        let values = ["title": title, "desc": desc, "location": location, "image": image, "category": eventCategory, "date": dateString]
        
        print([values])
        
        handleSubmit(values: values as [String : AnyObject])
        
    }
    
    
    
    func textViewDidChange(_ textView: UITextView) {
        //when textView is empty, display floating placeholder label
        placeholderLabel?.isHidden = !descriptionTextView.text.isEmpty
    }
    
    //PICKERVIEW!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eventsCategory.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return eventsCategory[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return category = eventsCategory[row]
    }
    
    //image picker
    func handleSelectEventImage () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker = UIImage()
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker as UIImage?{
            eventImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
}
