//
//  AppUser.swift
//  StudySesh
//
//  Created by Tim Kramer on 1/27/24.
//

import Foundation
import FirebaseFirestore


struct AppUser: Codable, Identifiable {
    var id: String
    var name: String
    var displayName: String
    var email: String
    var major: String
    var profilePhoto: String
    var groups: [DocumentReference]?
    var course: [DocumentReference]?
    var post: [DocumentReference]?
}
