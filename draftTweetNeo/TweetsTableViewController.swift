//
//  TweetsTableViewController.swift
//  draftTweetNeo
//
//  Created by 田上健太 on 2015/03/13.
//  Copyright (c) 2015年 jp.sonicgarden. All rights reserved.
//

import UIKit

class TweetsTableViewController: UITableViewController {
    
    let tweetModel = TweetModel()
    var tweets = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func syncTweets(){
        self.tweets = tweetModel.all()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        syncTweets()
        return self.tweets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as TweetsTableViewCell
        var tweetObject = tweets.objectAtIndex(indexPath.row) as TweetObject
        cell.contentLabel.text = tweetObject.content
        return cell
    }
    
    

    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        self.tableView.reloadData()
    }

}
