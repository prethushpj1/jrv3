//
//  JRContainerViewController.swift
//  JackpotRising
//
//  Created by tibin on 06/07/17.
//  Copyright © 2017 JackpotRising. All rights reserved.
//

import UIKit

class JRRootViewController: UIViewController {
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NotificationNames.sdkClose.name, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeSDK), name: NotificationNames.sdkClose.name, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func closeSDK(){
        self.dismiss(animated: true, completion: nil)
    }
}
