//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by John Clema on 18/11/2015.
//  Copyright © 2015 JohnClema. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }

    var segueMeme: Meme!
    var deleteIndex: IndexPath!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if memes.count == 0 {
            performSegue(withIdentifier: "presentMemeEditor", sender: self)
        }
        tableView.reloadData()
    }
    
    //MARK: Tableview delegate/datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell") as! MemeTableViewCell
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.editedImage
        cell.memeLabel.text = "\(meme.topText) ... \(meme.bottomText)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow;
        segueMeme = memes[indexPath!.row]
            
        
        performSegue(withIdentifier: "showDetailFromTable", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "showDetailFromTable") {
            let vc = segue.destination as! MemeDetailViewController
            vc.meme = segueMeme
        }
        
    }
    
    //MARK: Navigation Buttons
    @IBAction func editButtonPressed(_ sender: AnyObject) {
        isEditing = tableView.isEditing ? false : true
        tableView.setEditing(isEditing, animated: true)
    }

    @IBAction func addButtonPressed(_ sender: AnyObject) {
        performSegue(withIdentifier: "presentMemeEditor", sender: self)
    }
    
    

}
