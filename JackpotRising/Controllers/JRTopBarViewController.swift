//
//  JRTopBarViewController.swift
//  JackpotRising
//
//  Created by tibin on 06/07/17.
//  Copyright © 2017 JackpotRising. All rights reserved.
//

import UIKit

class JRTopBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        NotificationCenter.default.post(name: NotificationNames.sdkClose.name, object: nil)
    }
    
}
