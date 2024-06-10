//
//  Group.swift
//  StudySesh
//
//  Created by Tim Kramer on 1/27/24.
//

import Foundation
import FirebaseFirestore
struct Group: Codable{
    var course: String
    var name: String
    var members: [DocumentReference]?
}
