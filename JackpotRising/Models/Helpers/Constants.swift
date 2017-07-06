//
//  Constants.swift
//  JackpotRising
//
//  Created by Prethush on 06/07/17.
//  Copyright © 2017 JackpotRising. All rights reserved.
//

import Foundation

/**
 Enum for directions
 
 - Left:
 - Right:
 - Top:
 - Bottom:
 */
enum Directions: String {
    case Left
    case Right
    case Top
    case Bottom
}

enum SegueId: String{
    case register   = "JRRegisterSegue"
    case login      = "JRLoginSegue"
}

enum StoryboardName: String{
    case main       = "JRMain"
}
