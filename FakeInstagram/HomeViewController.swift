//
//  HomeViewController.swift
//  FakeInstagram
//
//  Created by ChenMo on 2/20/19.
//  Copyright © 2019 ChenMo. All rights reserved.
//

// *************************
// TO LAUNCH PARSE DASHBOARD:
// parse-dashboard --appId myAppId --masterKey myMasterKey --serverURL "https://boiling-oasis-54624.herokuapp.com/parse"
// *************************


import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts = [PFObject]()
    let postsRefreshControl = UIRefreshControl()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let commentBar = MessageInputBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // loadPosts()
        postsRefreshControl.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        tableView.refreshControl = postsRefreshControl
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPosts()
        print(posts)
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        cell.tag = indexPath.row
        fillInCell(fill: cell, with: post, using: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let comment = PFObject(className: "Comment")
        // comment
    }
    

    
    @ objc func loadPosts() {
        let query = PFQuery(className: "Post")
        query.includeKey("author")
        query.limit = 20
        query.findObjectsInBackground {(posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
                
            }
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func fillInCell(fill cell: PostTableViewCell, with post: PFObject, using tag: Int) -> Void {
        
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        cell.captionLabel.text = post["caption"] as? String
        cell.usernameLabel2.text = user.username! + ":"
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.postImage.af_setImage(withURL: url)
        
        // Try not to use this, this will mess up the ordering of the reused cells
//        DispatchQueue.global(qos: .userInitiated).async {
//            if let imageData = try? Data(contentsOf: url) {
//                DispatchQueue.main.async {
//                    print("cell tag is: ", cell.tag)
//                    print("tag is: ", tag)
//                    if cell.tag == tag {
//                        cell.postImage?.image = UIImage(data: imageData);
//                    }
//                }
//            }
//        }
    }
}
