//
//  FinalScoreScreenViewController.swift
//  Bubble Pop
//
//  Created by Melvin Philip on 29/4/18.
//  Copyright © 2018 Melvin Philip. All rights reserved.
//

import UIKit
import CoreData

class FinalScoreScreenViewController: UIViewController, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var finalScaoreLabel: UILabel!
    var finalScore: String!
    var playerName: String!
    var scores: [NSManagedObject] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        save()
        finalScaoreLabel.text = finalScore
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Error: App Delegate not found.")
            return
        }
        
        //Fetching High Score Data
        let context = appDelegate.persistentContainer.viewContext
        let dataRequest =  NSFetchRequest<NSManagedObject>(entityName: "HighScore")
        let sortByScore = NSSortDescriptor(key: "score", ascending: false)
        dataRequest.sortDescriptors = [sortByScore]
        
        do {
            scores = try context.fetch(dataRequest)
            self.tableView.reloadData()
        } catch {
            print("Could not retrieve data.")
        }
    }

    
    //Saves score to user scores database and reloads table data.
    func save(){
        self.saveScore(score: finalScore, name: playerName )
        self.tableView.reloadData()
    }
    
    //Saves scores to user score persistance database
    func saveScore(score: String, name: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Error: App Delegate not found.")
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "HighScore", in: context)!
        let highScore = NSManagedObject(entity: entity, insertInto: context)
        
        highScore.setValue(Int(score), forKeyPath:"score")
        highScore.setValue(name, forKeyPath: "name")
        
        do {
            try context.save()
            scores.append(highScore)
        } catch {
            print("Could not save score.")
        }
        
    }

    
    /*
     *  Table View Set Up
     *
     */

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        
        let score = scores[indexPath.row]
       
        let value = score.value(forKeyPath: "score")!
        let valueToDisplay = String(describing: value)
        
        let nameValue = score.value(forKey: "name")!
        let nameToDisplay = String(describing: nameValue)
       
        cell?.textLabel?.text = nameToDisplay
        cell?.detailTextLabel?.text = valueToDisplay
        cell?.backgroundColor = UIColor.clear
        cell?.textLabel?.textColor = UIColor.white
        
        return cell!
    }

}
