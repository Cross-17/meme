//
//  TableViewController.swift
//  meme
//
//  Created by 政达 何 on 2017/1/11.
//  Copyright © 2017年 政达 何. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var memes: [Meme]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // this block of code are repetitive because I don't know how to handle action selector in function
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add meme",
            style: .plain,
            target: self,
            action: #selector(addMeme))
    }
    
    func addMeme() {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewController(withIdentifier: "EditViewController")as! EditViewController
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        tableView!.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell")!
        let meme = memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.textLabel?.text = (meme.topText.appending(" "+meme.bottomText))
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let meme = memes[(indexPath as NSIndexPath).row]
        detailController.memed = meme
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}



