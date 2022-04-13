//
//  UIViewController + Extension.swift
//  Invitation List
//
//  Created by Imam MohammadUvesh on 16/12/21.
//

import Foundation
import UIKit

extension UIViewController{
    
    func hideKeyboardWhenTapped(){
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(viewTap)
    }
    
    @objc
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
}
