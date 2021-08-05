//
//  AddNewStudentViewController.swift
//  SqlPractice
//
//  Created by Pradnya M. S. Suryavanshi on 23/07/21.
//

import UIKit

class AddNewStudentViewController: UIViewController {
    
//    MARK : OUTLETS
    @IBOutlet weak var label:UILabel!
    @IBOutlet weak var nameText:UITextField!
    @IBOutlet weak var ageText:UITextField!
    @IBOutlet weak var phoneText:UITextField!
    @IBOutlet weak var saveButton:UIButton!
    
//    MARK : GLOBAL VARIABLES
    var dbManager=DBManager()
    var id = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addToolbar()
        if id != 0 {
            label.text="UPDATE \(id) DATA"
            saveButton.setTitle("UPDATE", for: .normal)
        }
        
        saveButton.addTarget(self, action: #selector(saveNewInfo), for: .touchUpInside)

    }
    
//    MARK : INSERT AND NAVIGATION
    
    @objc func saveNewInfo(){
        guard let name=nameText.text, let age = ageText.text, let phone=phoneText.text else {
            return
        }
        
        if id==0 {
            dbManager.insert(nName: name, nAge: Int(age) ?? 0 , nPhoneno: phone)
            
        }else{
            dbManager.update(Uid: id, Uname: name, Uage: Int(age) ?? 0, Uphone: phone)
        }

        navigationController?.popViewController(animated: true)
    }
    
    
    func addToolbar(){
        var toolbar=UIToolbar(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Hide Keyboard", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        toolbar.items = items
        toolbar.sizeToFit()

        nameText.inputAccessoryView = toolbar
        ageText.inputAccessoryView=toolbar
        phoneText.inputAccessoryView=toolbar
    }
    
    @objc func doneButtonAction() {
        nameText.resignFirstResponder()
        ageText.resignFirstResponder()
        phoneText.resignFirstResponder()
    }
    
}



