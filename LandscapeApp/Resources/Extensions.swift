//
//  Extensions.swift
//  LandscapeApp
//
//  Created by Max Park on 5/16/22.
//

import Foundation
import UIKit



extension UIViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIView {
    var width: CGFloat {
        return frame.size.width
    }
    var height: CGFloat {
        return frame.size.height
    }
    var left: CGFloat {
        return frame.origin.x
    }
    var right: CGFloat {
        return left + width
    }
    var top: CGFloat {
        return frame.origin.y
    }
    var bottom: CGFloat {
        return top + height
    }
}

class PinColors {
    let pinColors = [
        UIColor(named: "Aqua"),
        UIColor(named: "Banana"),
        UIColor(named: "Blueberry"),
        UIColor(named: "Cantaloupe"),
        UIColor(named: "Chestnut"),
        UIColor(named: "Flora"),
        UIColor(named: "Grape"),
        UIColor(named: "Honeydew"),
        UIColor(named: "Ice"),
        UIColor(named: "Lavender"),
        UIColor(named: "Lead"),
        UIColor(named: "Lemon"),
        UIColor(named: "Magenta"),
        UIColor(named: "Maraschino"),
        UIColor(named: "Salmon"),
        UIColor(named: "Spindrift"),
        UIColor(named: "Spring"),
        UIColor(named: "Strawberry"),
        UIColor(named: "Tangerine"),
        UIColor(named: "Tin"),
    ]
}
