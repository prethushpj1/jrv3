//
//  JackpotRising.swift
//  JackpotRising
//
//  Created by Prethush on 06/07/17.
//  Copyright © 2017 JackpotRising. All rights reserved.
//

import UIKit
import JackpotRising.Private

public class JackpotRising: NSObject {
    
    public static let sharedInstance = JackpotRising()
    internal var appViewController:UIViewController{
        get{
            return UIApplication.shared.keyWindow!.rootViewController!
        }
    }
    internal var sdkRootViewController: JRRootViewController{
        get{
            let storyboard = UIStoryboard (
                name: StoryboardName.main.rawValue,
                bundle: Bundle(for: JRRootViewController.self))
            
            let sdkRootController = storyboard.instantiateInitialViewController() as! JRRootViewController
            sdkRootController.modalPresentationStyle = .overCurrentContext
            return sdkRootController
        }
    }
    
    private override init() {
        super.init()
        CustomFont.load("OpenSans-Regular")
        CustomFont.load("OpenSans-Bold")
        CustomFont.load("OpenSans-Light")
        CustomFont.load("OpenSans-ExtraBold")
    }
}

extension JackpotRising{
    public func showSDK(){
        self.appViewController.present(self.sdkRootViewController, animated: true, completion: nil)
    }
}
