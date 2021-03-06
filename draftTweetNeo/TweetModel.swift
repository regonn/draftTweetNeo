//
//  TweetModel.swift
//  draftTweetNeo
//
//  Created by 田上健太 on 2015/03/13.
//  Copyright (c) 2015年 jp.sonicgarden. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TweetModel{
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    func insert(content: String){
        println("insert: \(content)")
        let managedObjectContext: NSManagedObjectContext  = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Tweet", inManagedObjectContext: managedObjectContext)
        let tweet = Tweet(entity: entity!, insertIntoManagedObjectContext: managedObjectContext)
 
        tweet.content = content
        tweet.updatedAt = NSDate()
        tweet.uId = NSUUID().UUIDString
        
        appDelegate.saveContext()
        println("tweet saved")
    }
    
    func all()-> NSArray{
        println("fetch all")
        var tweets = NSMutableArray()
        let managedObjectContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "Tweet")
        var error: NSError? = nil
        var fetchResults: Array = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)!
        
        for managedObject in fetchResults {
            var tweetObject = TweetObject()
            tweetObject.content = managedObject.valueForKey("content") as String
            tweetObject.updatedAt = managedObject.valueForKey("updatedAt") as NSDate
            tweetObject.uId = managedObject.valueForKey("uId") as String
            tweets.addObject(tweetObject)
        }
        var descriptor: NSSortDescriptor = NSSortDescriptor(key: "updatedAt", ascending: false)
        var sortedResults: NSArray = tweets.sortedArrayUsingDescriptors([descriptor])
        return sortedResults
    }
    
    func deleteAll(){
        let managedObjectContext = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Tweet", inManagedObjectContext: managedObjectContext)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        var error: NSError? = nil
        if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) {
            for managedObject in results {
                managedObjectContext.deleteObject(managedObject as NSManagedObject)
            }
        }
        appDelegate.saveContext()
    }
    
    func update(uId: String, content: String){
        let managedObjectContext = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Tweet", inManagedObjectContext: managedObjectContext)
        appDelegate.saveContext()
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        let predicate = NSPredicate(format: "%K = %@", "uId", uId)
        fetchRequest.predicate = predicate
        
        var error: NSError? = nil
        if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error){
            for managedObject in results {
                let tweet = managedObject as Tweet
                println(tweet.content)
                tweet.content = content
                tweet.updatedAt = NSDate()
                tweet.uId = uId
            }
        }
        appDelegate.saveContext()
    }

    func delete(uId: String){
        let managedObjectContext = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Tweet", inManagedObjectContext: managedObjectContext)
        appDelegate.saveContext()
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        let predicate = NSPredicate(format: "%K = %@", "uId", uId)
        fetchRequest.predicate = predicate

        var error: NSError? = nil
        if var results = managedObjectContext.executeFetchRequest(fetchRequest, error: &error){
            for managedObject in results {
                managedObjectContext.deleteObject(managedObject as NSManagedObject)
            }
        }
        appDelegate.saveContext()
    }
}
