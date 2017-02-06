//
//  customSideViewCell.swift
//  GoApp
//
//  Created by X on 12/9/16.
//  Copyright © 2016 Brenda Kaing. All rights reserved.
//

import Foundation
import UIKit

class customSideViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var `switch`: UISwitch!
   
    private var _model: String = ""
    
    public internal (set) var model: String {
        get {
            return self._model
        }
        set {
            self._model = newValue
            self.categoryLabel.text = self._model
        }
    }

    //******************* MARK: Switch control
    
    weak var delegate: SwitchDelegate?
    
    @IBAction func switchSwitched(_ sender: Any) {
        let category = self._model
        delegate?.switchChanged(controller: self, selectedCategory: category)
    }
    
}
