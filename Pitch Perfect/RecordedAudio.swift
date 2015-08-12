//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Christopher on 28/7/15.
//  Copyright (c) 2015 Nox. All rights reserved.
//

import Foundation

class RecordedAudio {
    
    var filePath : NSURL!
    var title : String!
    
    init(filePath : NSURL, title : String){
        self.filePath = filePath
        self.title = title
    }
    
}