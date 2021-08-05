//
//  ViewController.swift
//  SqlPractice
//
//  Created by Pradnya M. S. Suryavanshi on 21/07/21.
//

import UIKit

struct Student {
    var Sid:Int
    var Sname:String
    var Sage:Int
    var SphoneNo:String
}

class tableViewCell:UITableViewCell{
    
    @IBOutlet weak var idLabel:UILabel!
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var ageLabel:UILabel!
    @IBOutlet weak var phoneLabel:UILabel!
    
}

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
   
    var dbManager = DBManager()
    
    @IBOutlet weak var tableView : UITableView!

    var students = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate=self
        tableView.dataSource=self
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=self.tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as? tableViewCell
        cell?.idLabel.text=String(students[indexPath.row].Sid)
        cell?.nameLabel.text=students[indexPath.row].Sname
        cell?.ageLabel.text=String(students[indexPath.row].Sage)
        cell?.phoneLabel.text=students[indexPath.row].SphoneNo
        return cell ?? tableViewCell()
    }
    
    @IBAction func goToAddNew(){
        if let vc=storyboard?.instantiateViewController(identifier: "AddNewStudentViewController") as? AddNewStudentViewController{
            vc.id=0
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc=storyboard?.instantiateViewController(identifier: "AddNewStudentViewController") as? AddNewStudentViewController{
            vc.id = students[indexPath.row].Sid
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func updateTable(){
        if let studentproto=dbManager.readStudentValues(){
            students=studentproto
            tableView.reloadData()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateTable()
    }
    
    
    
    
}



