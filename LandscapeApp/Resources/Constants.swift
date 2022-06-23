//
//  Constants.swift
//  LandscapeApp
//
//  Created by Max Park on 6/20/22.
//

import UIKit

enum Color {
    static let NavigationGray = UIColor(named: "NavigationGray")
    static let SelectedCellColor = UIColor(named: "IssueCellSelected")
}

enum SFSymbol {
    static let filter = UIImage(systemName: "line.3.horizontal.decrease.circle")
    static let downArrow = UIImage(systemName: "chevron.down")
}

struct Alphabet {
    let letters = UInt32("A") ... UInt32("Z")
    let singleLetters: [Character]
    init() {
        let singleLettersString = String(String.UnicodeScalarView(letters.compactMap(UnicodeScalar.init)))
        singleLetters = Array(singleLettersString)
        print(singleLetters)
    }
}
