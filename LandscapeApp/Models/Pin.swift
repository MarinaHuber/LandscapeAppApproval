//
//  Pin.swift
//  LandscapeApp
//
//  Created by Max Park on 5/16/22.
//

import Foundation
import UIKit

struct Pin {
    var id: UUID
    var color: UIColor
    var issues: [Issue]
    var marker: Marker
}
