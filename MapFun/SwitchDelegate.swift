//
//  SwitchDelegate.swift
//  GoApp
//
//  Created by X on 12/9/16.
//  Copyright © 2016 Brenda Kaing. All rights reserved.
//

import Foundation

protocol SwitchDelegate: class{
    func switchChanged(controller: customSideViewCell, selectedCategory category: String)
}
