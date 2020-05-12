//
//  ViewController.swift
//  Final
//
//  Created by student on 4/13/20.
//  Copyright © 2020 bgonzalez526@students.mchenry.edu. All rights reserved.
import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet weak var todoTableView: UITableView!
    
    var todoManager : NSManagedObjectContext!
    var todos: [NSManagedObject] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.rowHeight = 80
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
        do{
            todos = try managedContext.fetch(fetchRequest)
        } catch let err as NSError {
            print("Failed to fetch todos", err)
        }
    }
    @IBAction func addTodo(_ sender: Any) {
        let todoAlert = UIAlertController(title: "Add To do", message: "New To do", preferredStyle: .alert)
        
        todoAlert.addTextField()
        
        let addTodoAction = UIAlertAction(title: "Add", style: .default) { [unowned self] (action) in
            guard let textField = todoAlert.textFields?.first, let todoAdd = textField.text else {return}
//            let newTodo = todoAlert.textFields![0]
            self.save(todoName: todoAdd)
            self.todoTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        todoAlert.addAction(addTodoAction)
        todoAlert.addAction(cancelAction)
        
        present(todoAlert, animated: true, completion: nil)
    }
    func save( todoName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)!
        let todo = NSManagedObject(entity: entity, insertInto: managedContext)
        todo.setValue(todoName, forKey: "todoName")
        
        do {
            try managedContext.save()
            todos.append(todo)
        } catch let err as NSError {
            print("Failed to save a To Do!", err)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoCell
        let todo = todos[indexPath.row]
        cell.todoLabel?.text = todo.value(forKeyPath: "todoName") as? String
        return cell
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TodoCell
        
        if cell.isChecked == false {
            cell.checkMarkImage.image = UIImage(named: "checkmark.png")
            cell.isChecked = true
        } else{
            cell.checkMarkImage.image = nil
            cell.isChecked = false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     
        for item in todos {
            if editingStyle == .delete {
                
                    self.todoTableView.delete(delete)
                }
              
            do {
                try self.todoManager.save()
            } catch {
                print("Error deleting a todo")
            }
            todos.removeAll()
    }
            
            }
}
