//
//  ValidationCell.swift
//  ReactiveDatasource
//
//  Created by Michael Heinzl on 06.07.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import DataSource
import ReactiveForm

class ValidationCell: UITableViewCell {

    @IBOutlet weak var stateLabel: UILabel!
    
    var field: Form.ValidationField!
    
    var disposable = CompositeDisposable()
    
    func configure(field: Form.ValidationField) {

        disposable += field.displayedState.producer.startWithValues { [unowned self] state in
            switch state {
            case let .warning(text: text):
                self.stateLabel.text = text
                self.stateLabel.textColor = .orange
            case let .error(text: text):
                self.stateLabel.text = text
                self.stateLabel.textColor = .red
            case let .info(text: text):
                self.stateLabel.text = text
                self.stateLabel.textColor = .blue
            default:
                self.stateLabel.text = ""
                self.stateLabel.textColor = .clear
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Need to reset bindings on configure (cell reuse)
        disposable.dispose()
        disposable = CompositeDisposable()
    }
}

extension ValidationCell {
    
    static var descriptor: CellDescriptor<Form.ValidationField, ValidationCell> {
        return CellDescriptor()
            .configure { (field, cell, indexPath) in
                cell.configure(field: field)
        }
    }
}
