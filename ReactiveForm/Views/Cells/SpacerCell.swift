//
//  SpacerCell.swift
//  
//
//  Created by Gunter Hager on 11/09/2017.
//  Copyright © 2017 Hagleitner. All rights reserved.
//

import UIKit
import DataSource

class SpacerCell: FormFieldCell {
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    func configure(field: FormField<CGFloat>) {
        super.configure(field: field)
        guard field.type == .spacer else { return }
        heightConstraint.constant = field.content.value ?? 0
    }
    
}

extension SpacerCell {
    
    static var descriptor: CellDescriptor<FormField<CGFloat>, SpacerCell> {
        return CellDescriptor("SpacerCell")
            .configure { (field, cell, _) in
                cell.configure(field: field)
        }
            .isHidden { (field, indexPath) in
                return field.isHidden.value
        }
    }
    
}
