//
//  ViewController.swift
//  T_Mobile_Work
//
//  Created by Anand Nanavaty on 24/06/20.
//  Copyright © 2020 Anand Nanavaty. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var toDoListTitleLabel: UILabel!
    @IBOutlet weak var searchToDoTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchToDoView: UIView!
    
    //MARK: Objects
    var todoListItemArray:[ToDoList]?
    var todoListAllItemArray:[ToDoList]?
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    //MARK: Utility Methods
    func setUpUI(){
        self.searchToDoView.layer.cornerRadius = 4.0
        self.searchToDoView.backgroundColor = .white
        self.searchToDoTextField.placeholder = "Search for Todo Items"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        self.searchToDoTextField.delegate = self
        self.loadData()
    }
    func move(from: IndexPath, to: IndexPath, aCell: ToDoListItemTVCell) {
        UIView.animate(withDuration: 1, animations: {
            self.tableView.moveRow(at: from, to: to)
        }) { (true) in
            aCell.backgroundColor = .lightGray
            let aDict = self.todoListItemArray?[from.row]
            self.todoListItemArray?.remove(at: from.row)
            self.todoListItemArray?.insert(aDict!, at: to.row)
            let aDictAll = self.todoListAllItemArray?[from.row]
            self.todoListAllItemArray?.remove(at: from.row)
            self.todoListAllItemArray?.insert(aDictAll!, at: to.row)
        }
    }
    //MARK: Button click actions
    @IBAction func addButtonAction(_ sender: UIButton) {
        let objNewToDoItemVC = self.storyboard?.instantiateViewController(identifier: "NewToDoItemViewController") as! NewToDoItemViewController
        objNewToDoItemVC.delegate = self
        self.navigationController?.pushViewController(objNewToDoItemVC, animated: true)
    }
    
    //MARK: Load Core data
    func loadData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoList")
            do {
                todoListItemArray = try (context.fetch(fetchRequest)) as? [ToDoList]
                todoListAllItemArray = try (context.fetch(fetchRequest)) as? [ToDoList]
                if todoListItemArray?.count ?? 0 > 0 {
                    self.tableView.reloadData()
                }else {
                    self.popupAlert(title: "T-Mobile", message: "Sorry, no record were found.", actionTitles: ["OK"], actions:[{action1 in}])
                }
                //print("\(todoListItemArray?.count)")
            } catch let err {
                print(err)
                self.popupAlert(title: "T-Mobile", message: "Sorry, no record were found.", actionTitles: ["OK"], actions:[{action1 in}])
            }
        }
    }
}

//MARK: UITableView delegate and datasource methods
extension ViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListItemArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: "ToDoListItemTVCell") as! ToDoListItemTVCell
        if let aDict = todoListItemArray?[indexPath.row] {
            if let aTitle = aDict.title {
                aCell.toDoTitleLabel.text = aTitle
            }
            if let aSubTitle = aDict.subTitle {
                aCell.toDoSubTitleLabel.text = aSubTitle
            }
            if let profileData = aDict.imageData {
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        let profileImage = UIImage(data: profileData)
                        aCell.profileImageView.image = profileImage
                    }
                }
            }
        }
        return aCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aCell = tableView.cellForRow(at: indexPath) as! ToDoListItemTVCell
        if let aDict = todoListItemArray?[indexPath.row] {
            var image = UIImage(named: "check_ic")
            if aDict.isSelect == "1" {
                aDict.isSelect = "0"
                let fromIndexPath = indexPath
                let toIndexPath = IndexPath(row: (todoListItemArray?.count ?? 0) - 1, section: 0)
                move(from: fromIndexPath, to: toIndexPath, aCell: aCell)
                
            }else {
                image = UIImage(named: "un_check_ic")
                aDict.isSelect = "1"
                aCell.backgroundColor = .white
            }
            aCell.checkMarkImageView.image = image
        }
    }
}

//MARK: UITextField delegate methods
extension ViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if updatedText.count > 0 {
                let aArray = todoListAllItemArray?.filter {($0.title?.lowercased().contains(updatedText.lowercased()))!}
                if aArray?.count ?? 0 > 0 {
                    todoListItemArray = aArray
                }else {
                    todoListItemArray = todoListAllItemArray
                }
            }else {
                todoListItemArray = todoListAllItemArray
            }
            self.tableView.reloadData()
        }
        return true
    }
}

//MARK: ToDo List Data Load delegate method
extension ViewController : ToDoListLoadDataDelegate {
    
    func toDoListData() {
        self.loadData()
    }
}
