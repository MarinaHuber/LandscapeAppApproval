//
//  Issue.swift
//  LandscapeApp
//
//  Created by Max Park on 5/16/22.
//

import Foundation
import UIKit

enum IssueStatus {
    case open
    case close
}

enum IssueType {
    case reports
    case needApproval
    case inspirationBoard
}

struct Issue {
    var id: UUID
    var name: String
    var status: IssueStatus
    var reports: [Note]
    var needApproval: [Note]
    var inspirationBoard: [Note]
}

struct IssueNotes {
    var reports: [Note]
    var needApproval: [Note]
    var inspirationBoard: [Note]
}
