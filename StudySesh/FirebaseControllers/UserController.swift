//
//  UserController.swift
//  StudySesh
//
//  Created by Tim Kramer on 1/27/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct UserController {
    
    private var db = Firestore.firestore()
    
    func addUser(_ user: AppUser) {
        do {
            // Convert user to dictionary using Codable
            let userData = try user.toDictionary()
            
            // Add a new document to the "appUsers" collection with the user's UID as the document ID
            print("attempting to write data")
            db.collection("appUser").document(user.id).setData(userData) { error in
                if let error = error {
                    // Handle any errors
                    print("Error writing document: \(error)")
                } else {
                    // Document successfully written
                    print("Document successfully written!")
                }
            }
            print("data has been written")

        } catch let error {
            print("Error converting user to dictionary: \(error)")
        }
    }
    
    
    // Converts the AppUser object to a dictionary for Firestore.
    func signUp(uid: String, email: String, displayName: String, major: String, imgUrl: String) {
        // User successfully created, now create AppUser model and add it to Firestore
        let appUser = AppUser(id: uid,
                              name: displayName,
                              displayName: displayName,
                              email: email,
                              major: major,
                              profilePhoto: imgUrl,
                              groups: [],
                              course: [],
                              post: [])
        self.addUser(appUser)
    }
    
    
    
}

extension AppUser {
    // Helper function to convert AppUser to dictionary
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        return dictionary ?? [:]
    }
}
