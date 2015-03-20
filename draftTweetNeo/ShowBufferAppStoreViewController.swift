//
//  ShowBufferAppStoreViewController.swift
//  draftTweetNeo
//
//  Created by 田上健太 on 3/20/15.
//  Copyright (c) 2015 jp.sonicgarden. All rights reserved.
//

import UIKit
import StoreKit

class ShowBufferAppStoreController: UIViewController, SKStoreProductViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        showSKStoreViewController()
    }

    func showSKStoreViewController() {
        let productViewController = SKStoreProductViewController()
        productViewController.delegate = self

        presentViewController( productViewController, animated: true, completion: {() -> Void in

            let productID = "490474324" // 調べたアプリのID
            let parameters:Dictionary = [SKStoreProductParameterITunesItemIdentifier: productID]
            productViewController.loadProductWithParameters( parameters, completionBlock: {(Bool, NSError) -> Void in
                println("OK")
            })
        })
    }

    // キャンセルボタンが押された時の処理
    func productViewControllerDidFinish(viewController: SKStoreProductViewController!) {
        UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
