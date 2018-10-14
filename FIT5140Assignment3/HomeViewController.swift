//
//  HomeViewController.swift
//  FIT5140Assignment3
//
//  Created by 隋晓婷 on 2018/10/14.
//  Copyright © 2018 Maya. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var roadLabel: UILabel!
    @IBOutlet weak var suburbLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var direction1Label: UILabel!
    @IBOutlet weak var direction2Label: UILabel!
    @IBOutlet weak var distance1Label: UILabel!
    
    @IBOutlet weak var speed1Label: UILabel!
    @IBOutlet weak var distance2Label: UILabel!
    @IBOutlet weak var speed2Label: UILabel!
    @IBOutlet weak var safeImageView: UIImageView!
    
    
    var storageRef = Storage.storage()
    let rootRef = Database.database().reference()
    let user = Auth.auth().currentUser!.uid
    var userRefHandle: DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func logoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
