//
//  TweetFormViewController.swift
//  draftTweetNeo
//
//  Created by 田上健太 on 2015/03/13.
//  Copyright (c) 2015年 jp.sonicgarden. All rights reserved.
//

import UIKit
import CoreData

class TweetFormViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var inputTextForm: UITextView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var countButton: UIButton!
    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    let tweetModel = TweetModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextForm.delegate = self
        if appDelegate.editingTweetObject != nil {
            self.inputTextForm.text = appDelegate.editingTweetObject!.content
            self.changeCounterValue(self.inputTextForm.text)
        }
        self.inputTextForm.becomeFirstResponder()
    }
    
    func changeCounterValue(counterValue: String){
        self.countButton.setTitle("\(140 - countElements(counterValue))", forState: .Normal)
    }
    
    func textViewDidChange(textView: UITextView!){
        self.changeCounterValue(self.inputTextForm.text)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender as? UIBarButtonItem == self.saveButton {
            if countElements(self.inputTextForm.text) > 0 {
                if appDelegate.editingTweetObject == nil {
                    tweetModel.insert(self.inputTextForm.text)
                }else{
                    tweetModel.update(appDelegate.editingTweetObject!.uId, content: self.inputTextForm.text)
                }
            }
        }
    }
    

}
