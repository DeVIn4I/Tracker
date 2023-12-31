//
//  TrackerTitleTextFieldHelper.swift
//  Tracker
//
//  Created by Pavel Razumov on 17.04.2023.
//

import UIKit

protocol TrackerTitleTextFieldHelperProtocol: UITextFieldDelegate {}

final class TrackerTitleTextFieldHelper: NSObject {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
}

// MARK: TrackerTitleTextFieldHelperProtocol
extension TrackerTitleTextFieldHelper: TrackerTitleTextFieldHelperProtocol {}
