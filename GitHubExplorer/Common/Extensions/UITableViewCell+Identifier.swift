//
//  UITableViewCell+Identifier.swift
//  GitHubExplorer
//
//  Created by Maciej Piechoczek on 25/12/2017.
//  Copyright © 2017 McPie. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    static var identifier: String {
        
        return String(describing: self)
    }
}
