//
//  ViewController.swift
//  Project4
//
//  Created by Oluwabusayo Olorunnipa on 7/6/21.
//

import UIKit
import WebKit

class ViewController: UITableViewController {

    var websites = ["apple.com", "busayoolorunnipa.com", "busayoolorunnipa.medium.com", "hackingwithswift.com"]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sites to Visit"
   
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Site", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if let vc = storyboard?.instantiateViewController(identifier: "Browser") as? WebViewController {
            vc.website = websites[indexPath.row]
            vc.siteList = websites
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
    
