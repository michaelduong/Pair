//
//  MainTableViewController.swift
//  Pair Randomizer
//
//  Created by Michael Duong on 2/23/18.
//  Copyright © 2018 Turnt Labs. All rights reserved.
//

/* LOGIC:
 1. Use AlertController to get input from user (add entity)
 2. Programmatically created button randomizes the entities
 3. Make sure there's an even number of entitiies! (entities % 2 == 0)! Otherwise require there to be +1 or -1 entity
 4. Display section headers to group off the entities once randomized
 */

import UIKit

class MainTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createShuffleButton()
    }
    
    @IBAction func addEntity(_ sender: UIBarButtonItem) {
        let addEntityController = UIAlertController(title: "Add New Entity", message: nil, preferredStyle: .alert)
        
        var entityText = UITextField()
        
        addEntityController.addTextField { (textField) in
            textField.placeholder = "New Entity"
            entityText = textField
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let text = entityText.text, !text.isEmpty else { return }
            
            let newEntity = text
            EntityController.shared.createEntity(newEntity: newEntity)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        addEntityController.addAction(addAction)
        addEntityController.addAction(cancelAction)
        
        self.present(addEntityController, animated: true, completion: nil)
    }
    
    func createShuffleButton() {
        
        let image = UIImage(named: "ShuffleButton")
        let button = UIButton(frame: CGRect(origin: CGPoint(x: self.view.frame.width / 2 - 35, y: self.view.frame.size.height - 100), size: CGSize(width: 70, height: 70)))
        button.setBackgroundImage(image, for: .normal)
        self.navigationController?.view.addSubview(button)
        button.addTarget(self, action: #selector(shuffleButtonPressed), for: .touchUpInside)
    }
    
    @IBAction func shuffleButtonPressed() {
        let count = EntityController.shared.entities.count
        if count % 2 == 0 {
            EntityController.shared.randomize()
            tableView.reloadData()
        } else {
            let alert = UIAlertController(title: "Not Even!", message: "Please add another entity or remove an entity.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func indexForEntity(indexPath: IndexPath) -> Int {
        return (indexPath.section * 2) + (indexPath.row)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return EntityController.shared.entities.count % 2 == 0 ? (EntityController.shared.entities.count/2) : (EntityController.shared.entities.count/2) + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if EntityController.shared.entities.count % 2 == 0 {
            return 2
        } else {
            if section == (tableView.numberOfSections - 1) {
                return 1
            } else {
                return 2
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group #\(section + 1)"
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let entity = EntityController.shared.entities[indexForEntity(indexPath: indexPath)]
        cell.textLabel?.text = entity
        
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let entity = EntityController.shared.entities[indexForEntity(indexPath: indexPath)]
            
            EntityController.shared.removeEntity(entity: entity)
            
            tableView.reloadData()
        }
    }
}
