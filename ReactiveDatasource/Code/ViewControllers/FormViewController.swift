//
//  FormViewController.swift
//  ReactiveDatasource
//
//  Created by Michael Heinzl on 05.07.17.
//  Copyright © 2017 aaa - all about apps GmbH. All rights reserved.
//

import UIKit
import DataSource
import Result
import ReactiveSwift
import ReactiveCocoa

// MARK: - View Controller

class FormViewController: UITableViewController {
    
    @IBAction func reloadButtonTapped(_ sender: Any) {
        form.importFieldData(from:
            ["additional": true,
             "middlename": "Franz",
             "email": "test@test.at"
            ])
        
        reloadUI()
    }
    
    lazy var firstNameField: Form.TextField = {
        Form.TextField(id: "firstname", placeholder: "First Name",
            textInputTraits: TextInputTraits.defaultNameTraits,
            bindings: { (field) in
                field.validationState <~ field.text.producer.map { (text) in
                    if let text = text {
                        if text.characters.count > 5 {
                            return .warning(text: "more than 5")
                        } else if text.characters.count > 3 {
                            return .error(text: "more than 3")
                        }
                    }
                    
                    return .success
                }
            
        })
    }()
    
    lazy var middleNameField: Form.TextField = {
        Form.TextField(id: "middlename", placeholder: "Middle Name",
            bindings: { (field) in
                self.firstNameField.text.producer.startWithValues { (text) in
                    field.isHidden.value = text?.isEmpty ?? true
                }
                
                field.validationState <~ field.text.producer.map { (text) in
                    if let text = text {
                        if text.characters.count > 3 {
                            return .warning(text: "more than 3")
                        } else if text.characters.count > 2 {
                            return .error(text: "more than 2")
                        }
                    }
                    
                    return .success
                }
            }
        )
    }()
    
    lazy var lastNameField: Form.TextField = {
        Form.TextField(id: "lastname", placeholder: "Last Name",
            bindings: { (field) in
                field.isHidden <~ self.firstNameField.text.producer.map {
                    $0?.isEmpty ?? true
                }
                
                field.text <~ self.firstNameField.text
            }
        )
    }()
    
    lazy var switchField: Form.SwitchField = {
        Form.SwitchField(id: "additional", title: "Show additional options")
    }()
    
    lazy var emailField: Form.TextField = {
        Form.TextField(id: "email", text: "E-Mail", placeholder: "", textInputTraits: TextInputTraits.create({
            $0.keyboardType = .emailAddress
        }))
    }()
    
    lazy var dataSource: DataSource = {
        DataSource(
            cellDescriptors: [
                TextFieldCell.descriptor
                    .isHidden { (field, indexPath) in
                        return field.isHidden.value
                },
                SwitchCell.descriptor,
                TitleCell.descriptor,
                ValidationCell.descriptor
                    .isHidden { (field, indexPath) in
                        return field.isHidden.value
                }
                ],
            sectionDescriptors: [
                SectionDescriptor<Void>("section-name")
                    .headerHeight { .zero },
                
                SectionDescriptor<Void>("section-additional")
                    .header {
                        .title("Additional Fields")
                    }
                    .footer {
                        .title("Here are some additional fields")
                    }
                    .isHidden {
                        !self.switchField.isOn.value
                }
            ])
    }()
    
    lazy var form: Form = {
        Form(dataSource: self.dataSource)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
        dataSource.sections = [
            Section(items: [
                firstNameField,
                firstNameField.validationField(),
                middleNameField,
                middleNameField.validationField(),
                lastNameField,
                switchField
                ]).with(identifier: "section-name"),
            
            Section(items: [
                emailField,
                "some random text"
                ]).with(identifier: "section-additional")
        ]
    
        form.didChange = {
            self.reloadUI()
        }
        
        switchField.isOn.producer.startWithValues { value in
            self.reloadUI()
        }
        
        form.setup()
        dataSource.reloadData(tableView, animated: false)
        
        print("Exported field data:", form.exportFieldData())
    }
    
    func reloadUI() {
        dataSource.reloadData(tableView, animated: true)
    }
}

