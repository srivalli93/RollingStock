//
//  MyTableViewController.swift
//  MW02_Srivalli_Kanchibotla
//
//  Created by KANCHIBOTLA SRIVALLI  on 10/27/16.
//  Copyright © 2016 KANCHIBOTLA SRIVALLI . All rights reserved.
//

import UIKit
import WebKit
import Foundation


class MyTableViewController: UITableViewController, URLSessionDataDelegate {
    let dbUserName = "srivall"
    let dbPassword = "sri@2728"
    let dbname = "srivall"
    var values: NSArray = [] // = [String: AnyObject]()
    let urlPath = "https://cs.okstate.edu/~srivall/cs4153_test.php"
    let deleteUrlPath = "https://cs.okstate.edu/~srivall/cs4153_delete.php"
    override func viewDidLoad() {
        
        super.viewDidLoad()
        get()
        self.navigationItem.hidesBackButton = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func get(){
        let url = NSURL(string: urlPath)
        let data = NSData(contentsOf: url! as URL)
        print(url)
        do{
            values = try! JSONSerialization.jsonObject(with: (data as? Data)!, options: .allowFragments) as! NSArray
        }
        catch{
            print("Error serializing json data: \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return values.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let maindata = values[indexPath.row] as! NSDictionary
        let appendText = maindata["roadnameAbbr"] as? String
        let appendText1 = appendText?.appending(" ")
        cell.textLabel?.text = appendText1?.appending((maindata["number"] as? String)!)
        cell.detailTextLabel?.text = maindata["date"] as? String

        return cell
    }
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let deletedRow = values[indexPath.row] as! NSDictionary
            let id = deletedRow["id"]!
            
            
            let request = NSMutableURLRequest(url: NSURL(string: deleteUrlPath) as! URL)
            request.httpMethod = "POST"
            let postString = "dbusername=\(dbUserName)&dbpassword=\(dbPassword)&dbname=\(dbname)&id=\(id)"
            request.httpBody = postString.data(using: String.Encoding.utf8)
            let task = URLSession.shared.dataTask(with: request as URLRequest){data, response, error in
                
                guard error == nil else {
                    print("error=\(error)")
                    return
                }
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)//NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString= \(responseString)")
                print(response)
            }
            task.resume()
            
            
            let temp: NSMutableArray = []
            for i in 0..<values.count{
                temp[i] = values[i]
                }
            temp.removeObject(at: indexPath.row)
            values = temp
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
