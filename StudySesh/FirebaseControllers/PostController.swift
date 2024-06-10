//
//  PostController.swift
//  StudySesh
//
//  Created by Aaron Elkin on 1/27/24.
//

import Foundation
import Firebase

class PostController {
    let db = Firestore.firestore()

    func createPost(currentUser: AppUser, post: Post, completion: @escaping (Result<DocumentReference, Error>) -> Void) {
            var ref: DocumentReference? = nil
            ref = db.collection("Post").addDocument(data: [
                "message": post.message,
                "timestamp": Date(),
                "title": post.title,
                "user": db.collection("appUser").document(currentUser.id)
            ]) { err in
                if let err = err {
                    completion(.failure(err))
                } else if let ref = ref {
                    self.db.collection("appUser").document(currentUser.id).updateData([
                        "posts": FieldValue.arrayUnion([ref])
                    ]) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(ref))
                        }
                    }
                }
            }
        }

}

//Button("Test Function") {
//    postController.createPost(title: "Test Title", content: "Test content") { result in
//        switch result {
//        case .success(let documentReference):
//            print("Document added with ID: \(documentReference.documentID)")
//        case .failure(let error):
//            print("Error adding document: \(error)")
//        }
//    }
//}
//            .padding()
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .cornerRadius(8)
