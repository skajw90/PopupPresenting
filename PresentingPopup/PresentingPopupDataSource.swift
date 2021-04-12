//
//  PopupDataSource.swift
//
//  Created by Jiwon Nam on 2020/12/08.
//

import UIKit

@objc enum PresentingButtonActionType: Int {
    case next
    case skip
    case none
}

enum PresentingStyle {
    case none
    // etc ...
    var view: UIView {
        switch self {
        case .none: return PopupSampleView()
        }
    }
    
    var isForceQuitValid: Bool {
        return true
    }
    
    var constantData: Any? {
        switch self {
        case .none: return "NONE"
        }
    }
}
