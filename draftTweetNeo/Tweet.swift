//
//  Tweet.swift
//  draftTweetNeo
//
//  Created by 田上健太 on 3/12/15.
//  Copyright (c) 2015 jp.sonicgarden. All rights reserved.
//

import Foundation
import CoreData

class Tweet: NSManagedObject {

    @NSManaged var content: String
    @NSManaged var updatedAt: NSDate

}
