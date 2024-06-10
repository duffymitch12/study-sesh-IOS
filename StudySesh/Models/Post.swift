//
//  Post.swift
//  StudySesh
//
//  Created by Tim Kramer on 1/27/24.
//

import Foundation
import FirebaseFirestore

struct Post: Codable {
    var title: String
    var message: String
    var timestamp: Date?
    var user: DocumentReference?
}
