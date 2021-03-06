//
//  ProfileUserViewController.swift
//  PicSick
//
//  Created by Devesh Tyagi on 29/08/20.
//  Copyright © 2020 Devesh Tyagi. All rights reserved.
//

import UIKit

class ProfileUserViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var user :Users!
    var posts : [Post] = []
    var userId = ""
    var delegate : HeaderProfileCollectionReusableViewViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchUser()
        fetchMyPosts()
    }
    
    func fetchMyPosts(){
        Api.MyPosts.fetchMyPosts(userId: userId) { (key) in
            Api.Post.observePost(withId: key) { (post) in
                self.posts.append(post)
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchUser(){
        Api.User.observeUsers(withId: userId) { (user) in
            self.isFollowing(userId: user.id!,completed: {
                (value) in
                user.isFollowing = value
                self.user = user
                self.navigationItem.title = user.userName
                self.collectionView.reloadData()
            })
            
        }
    }
    
    func isFollowing(userId : String , completed : @escaping(Bool)-> Void ){
        Api.Follow.isFollowing(userID: userId, completed: completed)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserProfileToDetail"{
            let detailViewController = segue.destination as! DetailViewController
            let postId = sender as! String
            detailViewController.postId = postId
        }
        if segue.identifier == "UserProfileToDetail"{
            let detailViewController = segue.destination as! DetailViewController
            let postId = sender as! String
            detailViewController.postId = postId
        }
       
    }
    
    
}

extension ProfileUserViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPostsCollectionViewCell", for: indexPath) as! MyPostsCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderProfileCollectionReusableView", for:indexPath) as! HeaderProfileCollectionReusableView
        if let user = self.user{
            headerViewCell.user = user
            headerViewCell.delegate = self.delegate
            headerViewCell.delegate2 = self
        }
        
        return headerViewCell
    }
    
}
extension ProfileUserViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 1, height: collectionView.frame.size.width / 3 - 1)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension ProfileUserViewController : HeaderProfileCollectionReusableViewViewDelegateSwitchSettingVC {
    func goToSettingVC() {
        performSegue(withIdentifier: "UserProfileSettingSegue", sender: nil)
    }
}
extension ProfileUserViewController : MyPostsCollectionViewCellDelegate {
    
 
    func goToDetailVC(postId: String) {
        performSegue(withIdentifier: "UserProfileToDetail", sender: postId)
    }
    
}
