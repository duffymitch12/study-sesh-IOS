//
//  dbCourseController.swift
//  StudySesh
//
//  Created by Mitch Duffy on 1/27/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class CourseController : ObservableObject{
    
    private var db = Firestore.firestore()
    @Published var courses: [Course] = []
    @Published var allCourses: [String] = []

    
    func queryMajor(major: String, completion: @escaping ([Major]) -> Void) {
        let db = Firestore.firestore()
        db.collection("majors").whereField("major", isEqualTo: major).getDocuments { (querySnapshot, err) in
            let majorsArray = [Major]()

            if let err = err {
                print("Error getting documents: \(err)")
                completion([])
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    print(data)
//                    majorsArray.append(/*data*/)
                }
                completion(majorsArray)
            }
        }
    }

    func addCourse(courseName: String, toUser userId: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)

        // Start by fetching the user document
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var userCourses = [Course]()
//                if let existingCourses = document.data()?["courses"] as? [[String: Any]] {
//                    // Convert existing courses data to [Course]
//                    userCourses = existingCourses.compactMap { Course(dictionary: $0) }
//                }

                // Add the new course
                let newCourse = Course(name: courseName)
                userCourses.append(newCourse)

                // Update the user document
                userRef.updateData(["courses": userCourses.map { $0 }]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getCourses(appUser: AppUser, completion: @escaping ([Course]) -> Void) {
        var courseArray = [Course]()

        // Check if there are course references
        guard let courseRefs = appUser.course, !courseRefs.isEmpty else {
            completion([])
            return
        }

        // Track the number of completed requests
        let dispatchGroup = DispatchGroup()

        for ref in courseRefs {
            dispatchGroup.enter()
            ref.getDocument { (document, error) in
                defer { dispatchGroup.leave() }

                if let error = error {
                    print("Error getting course: \(error.localizedDescription)")
                    return
                }

                if let document = document, document.exists {
                    do {
                        let course = try document.data(as: Course.self)
                        courseArray.append(course)
                    } catch let error {
                        print("Error decoding course: \(error)")
                    }

                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(courseArray)
        }
    }
    
    func getMajorCourses(major: String, completion: @escaping ([String]) -> Void) {
        let docRef = db.collection("majors").document(major)
        
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting courses: \(error.localizedDescription)")
                completion([]) // Call completion with an empty array in case of error
            } else if let document = document, document.exists, let courses = document.data()?["courses"] as? [String] {
                completion(courses) // Use the retrieved courses here
            } else {
                print("Document does not exist or courses field is missing")
                completion([]) // Call completion with an empty array if the document or field doesn't exist
            }
        }
    }
//}
//    func addUser(_ user: AppUser) {
//        do {
//            // Convert user to dictionary using Codable
//            let userData = try user.toDictionary()
//
//            // Add a new document to the "appUsers" collection with the user's UID as the document ID
//            print("attempting to write data")
//            db.collection("appUser").document(user.id).setData(userData) { error in
//                if let error = error {
//                    // Handle any errors
//                    print("Error writing document: \(error)")
//                } else {
//                    // Document successfully written
//                    print("Document successfully written!")
//                }
//            }
//            print("data has been written")
//
//        } catch let error {
//            print("Error converting user to dictionary: \(error)")
//        }
//    }
//
//    // Converts the AppUser object to a dictionary for Firestore.
//    func signUp(uid: String, email: String, displayName: String, major: String) {
//        // User successfully created, now create AppUser model and add it to Firestore
//        let appUser = AppUser(id: uid,
//                              name: displayName,
//                              displayName: displayName,
//                              email: email,
//                              major: major,
//                              profilePhoto: "",
//                              groups: [],
//                              course: [],
//                              post: [])
//        self.addUser(appUser)
//    }
//}
//
//extension AppUser {
//    // Helper function to convert AppUser to dictionary
//    func toDictionary() throws -> [String: Any] {
//        let data = try JSONEncoder().encode(self)
//        let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
//        return dictionary ?? [:]
//    }
}
