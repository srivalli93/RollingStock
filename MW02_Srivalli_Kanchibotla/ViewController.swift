//
//  ViewController.swift
//  MW02_Srivalli_Kanchibotla
//
//  Created by KANCHIBOTLA SRIVALLI  on 10/26/16.
//  Copyright © 2016 KANCHIBOTLA SRIVALLI . All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    let dbUserName = "srivall"
    let dbPassword = "sri@2728"
    let dbname = "srivall"
    @IBOutlet var roadName: UITextField!
    @IBOutlet var number: UITextField!
    
    @IBOutlet var date: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Add Rolling Stock"
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ field: UITextField) -> Bool
    {
        field.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func popAlert(text: String) -> Void
    {
        let noSave = UIAlertController(title: "Cannot Save", message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (result: UIAlertAction) in
            
        }
        noSave.addAction(action)
        
        self.present(noSave, animated: true, completion: nil)
    }
    @IBAction func saveButton(_ sender: AnyObject) {
        let roadname = roadName.text
        let no = number.text
        let datePick = date.date
        var alertText = ""
        if (roadname?.isEmpty)! {
            alertText += "Road name is empty "
        }
        if (no?.isEmpty)! {
            alertText += "Number is empty"
        }
      
        
        if !alertText.isEmpty {
            popAlert(text: alertText)
        }
        else{
        let request = NSMutableURLRequest(url: NSURL(string: "https://cs.okstate.edu/~srivall/cs4153_insert.php") as! URL)
        request.httpMethod = "POST"
        let postString = "dbusername=\(dbUserName)&dbpassword=\(dbPassword)&dbname=\(dbname)&name=\(roadName.text!)&num=\(number.text!)&date=\(datePick)"
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
            self.performSegue(withIdentifier: "showTableSegue", sender: self)
           
            /*roadName.text?.removeAll()
            number.text?.removeAll()
            */
        }
       
    }
}

