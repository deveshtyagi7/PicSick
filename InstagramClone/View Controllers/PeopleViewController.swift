//
//  PeopleViewController.swift
//  PicSick
//
//  Created by Devesh Tyagi on 12/07/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    var users: [Users] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      loadUsers()
    }
    
    func loadUsers(){
        Api.User.observeUsers { (user) in
            self.isFollowing(userId: user.id!,completed: {
                (value) in
                user.isFollowing = value
                self.users.append(user)
                self.tableView.reloadData()
            })
            
        }
    }
    
    func isFollowing(userId : String , completed : @escaping(Bool)-> Void ){
        Api.Follow.isFollowing(userID: userId, completed: completed)
    }
   
   

}

extension PeopleViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return users.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeopleTableViewCell", for: indexPath) as! PeopleTableViewCell
        let user = users[indexPath.row]
        cell.user = user
    
        
        return cell
        
    }
}
