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
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate.editingTweetObject = nil
        self.tableView.estimatedRowHeight = 130
        self.tableView.rowHeight = UITableViewAutomaticDimension
        if !self.canOpenBuffer() {
            self.showSuggestAlert(nil)
        }

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
        appDelegate.editingTweetObject = nil
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath) as TweetsTableViewCell
        appDelegate.editingTweetObject = tweets.objectAtIndex(indexPath.row) as? TweetObject
    }

    // 空だけど editActionsForRowAtIndexPathの起動に必要
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }

    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var tweetObject = tweets.objectAtIndex(indexPath.row) as TweetObject
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler: {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
            self.showConfirmAlert(nil, indexPath: indexPath)
            return
        })
        var bufferAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Buffer", handler: {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) in
            var bufferURL = "bufferapp://?t=\(tweetObject.content)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            println(bufferURL)
            if self.canOpenBuffer() {
                UIApplication.sharedApplication().openURL(NSURL(string: bufferURL!)!)
            } else{
                self.showSuggestAlert(nil)
            }
            return

        })
        return [deleteAction, bufferAction]
    }

    func canOpenBuffer() -> Bool{
       var bufferURL = "bufferapp://?t=sample"
       return UIApplication.sharedApplication().canOpenURL(NSURL(string: bufferURL)!)
    }

    func showSuggestAlert(sender:UIButton!){
        let alert = UIAlertController(title: "", message: "This app use Buffer app. Do you open AppStore?", preferredStyle: UIAlertControllerStyle.Alert)

        let defaultAction = UIAlertAction(title: "Open AppStore",
            style: .Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                var vc: AnyObject! = self.storyboard!.instantiateViewControllerWithIdentifier("BufferAppStore")
                vc.setModalPresentationStyle
                self.presentViewController(vc as UIViewController, animated: true, completion: nil)
                return
        })

        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
                println("Cancel")
        })

        alert.addAction(defaultAction)
        alert.addAction(cancelAction)

        self.presentViewController(alert, animated: true, completion: nil)
    }

    func showConfirmAlert(sender:UIButton!, indexPath: NSIndexPath){
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this tweet?", preferredStyle: UIAlertControllerStyle.Alert)

        let defaultAction = UIAlertAction(title: "OK",
            style: .Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                var tweetObject = self.tweets.objectAtIndex(indexPath.row) as TweetObject
                self.tweetModel.delete(tweetObject.uId)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        })

        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
                println("Cancel")
        })

        alert.addAction(defaultAction)
        alert.addAction(cancelAction)

        self.presentViewController(alert, animated: true, completion: nil)
    }

}
