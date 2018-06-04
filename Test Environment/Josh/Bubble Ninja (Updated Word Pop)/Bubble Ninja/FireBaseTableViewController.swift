//
//  FireBaseTableViewController.swift
//  Bubble Ninja
//
//  Created by J on 28/5/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

var UniversalTitle: String!

class FireBaseTableViewController2: UITableViewController {
    
    @IBOutlet weak var tableViewArtists: UITableView!
    
    var refArtists: DatabaseReference!
    let blogSegueIdentifier = "ShowBlogSegue"
    var databaseHandle: DatabaseHandle?
    var artistList = [ArtistModel]()
    var postData = [String]()
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return artistList.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        //the artist object
        let artist: ArtistModel
        
        //getting the artist of selected position
        artist = artistList[indexPath.row]
        //adding values to labels
        cell.FirstWord.text = artist.name
        //returning cell
        return cell
        
        
    }
    
    
    override func viewDidLoad() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        super.viewDidLoad()
        //  ButtonToBeHidden.isHidden = true
        // textFieldName.isHidden = true
        //textFieldGenre.isHidden = true
        
        // self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        refArtists = Database.database().reference().child("Posts");
        print("Above after database load")
        //observing the data changes
        refArtists.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.artistList.removeAll()
                //// image retrieval
                
                
                /// im retrvieval done
                
                
                
                //iterating through all the values
                for artists in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let artistObject = artists.value as? [String: AnyObject]
                    let artistName  = artistObject?["Word1"]
                    // new code
                    
                    //creating artist object with model and fetched values
                    let artist = ArtistModel(name: artistName as! String?)
                    self.tableView.dataSource = self;
                    //appending it to list
                    self.artistList.append(artist)
                    
                }
                self.tableView.reloadData()
                //reloading the tableview
                //  self.tableViewArtists.reloadData()
                // self.tableView.reloadData()
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
