//
//  ContentFieldSettings.swift
//  
//
//  Created by Gunter Hager on 07/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import Foundation

public extension Form {
    
    /// Settings that define various aspects of a content field, like e.g. the input traits of a text field.
    public class FieldSettings: NSObject {
        
        public var isFocusable: Bool { return false }
        public var isExportable: Bool { return false }
        
    }
    
}


