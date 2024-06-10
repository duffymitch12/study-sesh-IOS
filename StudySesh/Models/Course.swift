//
//  Course.swift
//  StudySesh
//
//  Created by Tim Kramer on 1/27/24.
//

import Foundation
import FirebaseFirestore

struct Course: Codable {
    var name: String
    var posts: [DocumentReference]?
    var groups: [DocumentReference]?
    
    var isSelected: Bool = false
    var isDeleted: Bool = false

    enum CodingKeys: String, CodingKey {
        case name, posts, groups
        // 'isSelected' is not included in CodingKeys, so it won't be serialized
    }
}
extension Course: Equatable {
    static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.name == rhs.name // Add other property comparisons if needed
    }
}

