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

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIApplicationDelegate, MessageInputBarDelegate {
    
    var posts = [PFObject]()
    let postsRefreshControl = UIRefreshControl()
    var showCommentsBar = false
    var selectedPost: PFObject!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onLogoutButton(_ sender: Any) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "loginViewController")
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = loginViewController
    }
    let commentBar = MessageInputBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        commentBar.delegate = self
        // loadPosts()
        postsRefreshControl.addTarget(self, action: #selector(loadPosts), for: .valueChanged)
        tableView.refreshControl = postsRefreshControl
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 500
        // Do any additional setup after loading the view.
        
        tableView.keyboardDismissMode = .interactive
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPosts()
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showCommentsBar
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
            cell.tag = indexPath.row
            
            fillInCell(fill: cell, with: post, using: indexPath.row)
            return cell

        } else if indexPath.row <= comments.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
            
            fillInCommentCell(fill: cell, with: comments, using: indexPath.row)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell", for: indexPath)
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        if indexPath.row == comments.count + 1 {
            showCommentsBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            selectedPost = post
        }
    }
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let comment = PFObject(className: "Comment")
        // comment
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()
        selectedPost.add(comment, forKey: "comments")

        selectedPost.saveInBackground{ (success, error) in
            if success {
                print("success")
            } else {
                print("fail")
            }
        }
        tableView.reloadData()
        commentBar.inputTextView.text = nil
        showCommentsBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let post = posts[indexPath.row]
//        let comment = PFObject(className: "Comment")
//        // comment
//        comment["text"] = "I like this photo!"
//        comment["post"] = post
//        comment["author"] = PFUser.current()
//        post.add(comment, forKey: "comments")
//
//        post.saveInBackground{ (success, error) in
//            if success {
//                print("success")
//            } else {
//                print("fail")
//            }
//        }
//    }
    

    
    @ objc func loadPosts() {
        let query = PFQuery(className: "Post")
        query.includeKeys(["author", "comments", "comments.author"])
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
    }
    
    func fillInCommentCell(fill cell: CommentTableViewCell, with comments: [PFObject], using commentNum: Int) -> Void {
        let comment = comments[commentNum - 1]

        cell.commentTextLabel.text = comment["text"] as! String
        let user = comment["author"] as! PFUser
        cell.commentPosterLabel.text = user.username as! String  + ":"
        
    }
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
