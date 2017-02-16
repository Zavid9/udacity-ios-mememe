//
//  MemesSentTableViewController.swift
//  MemeMe
//
//  Created by Zhang, David on 12/19/16.
//  Copyright © 2016 Zhang, David. All rights reserved.
//

import UIKit

class MemesSentTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var memes: [Meme]!
    @IBOutlet weak var sentMemesTableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        sentMemesTableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sentMemesTableCell", for: indexPath)
        let savedMeme = self.memes[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = savedMeme.topText + " ... " + savedMeme.bottomText
        cell.imageView?.image = savedMeme.memedImage
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        // Populate view controller with data from the selected item
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)
    }

}
