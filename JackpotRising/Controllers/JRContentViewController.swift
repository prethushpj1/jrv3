//
//  JRContentViewController.swift
//  JackpotRising
//
//  Created by tibin on 06/07/17.
//  Copyright © 2017 JackpotRising. All rights reserved.
//

import UIKit

class JRContentViewController: UIViewController {

    var currentChild: UIViewController?
    var defaulFrame: CGRect{
        get{
            return CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
    }
    
    var defaultMask: UIViewAutoresizing{
        get{
            return [.flexibleWidth, .flexibleHeight]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.performSegue(withIdentifier: SegueId.register.rawValue, sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func swap(SourceController source: UIViewController, withDestination destination: UIViewController){
        destination.view.frame = self.defaulFrame
        destination.view.autoresizingMask = self.defaultMask
        
        source.willMove(toParentViewController: nil)
        self.addChildViewController(destination)
        self.currentChild = destination
        
        self.transition(from: source, to: destination, duration: 0.5, options: .transitionFlipFromLeft, animations: nil) { (status) in
            source.removeFromParentViewController()
            destination.didMove(toParentViewController: self)
        }
    }
    
    func addChld(ViewController destination: UIViewController){
        self.addChildViewController(destination)
        self.currentChild = destination
        
        let destView = destination.view
        destView?.autoresizingMask = self.defaultMask
        destView?.frame = self.defaulFrame
        self.view.addSubview(destView!)
        
        destination.didMove(toParentViewController: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueId.register.rawValue {
            if let child = self.currentChild{
                self.swap(SourceController: child, withDestination: segue.destination)
            }
            else{
                self.addChld(ViewController: segue.destination)
            }
        }
        else{
            if let child = self.currentChild, child.isKind(of: segue.destination.classForCoder) == false{
                self.swap(SourceController: self.currentChild!, withDestination: segue.destination)
            }
        }
    }
}
