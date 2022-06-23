//
//  Note.swift
//  LandscapeApp
//
//  Created by Max Park on 5/16/22.
//

import Foundation
import UIKit

protocol NoteType {
    var date: Date { get set }
    var text: String? { get set }
    var images: [UIImage]? { get set }
}

struct TextNote: NoteType {
    var date: Date
    var text: String?
    var images: [UIImage]?
}

struct ImageNote: NoteType {
    var date: Date
    var text: String?
    var images: [UIImage]?
}

struct Note {
    var date: Date
    var entries: [NoteType]
    var isOpened: Bool = true
}


