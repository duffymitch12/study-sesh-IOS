//
//  GroupController.swift
//  StudySesh
//
//  Created by Aaron Elkin on 1/27/24.
//

import Foundation
import Firebase

class GroupController: ObservableObject{
    let db = Firestore.firestore()
    @Published var groups: [Group] = []
    
    func createGroup(currentUser: AppUser, group: Group, completion: @escaping (Result<DocumentReference, Error>) -> Void) {
        var ref: DocumentReference? = nil
        ref = db.collection("Group").addDocument(data: [
            "course": group.course,
            "name": group.name,
            "members": [db.collection("appUser").document(currentUser.id)]
        ]) { err in
            if let err = err {
                completion(.failure(err))
            } else if let ref = ref {
                // Update currentUser only after the group has been successfully created
                self.db.collection("appUser").document(currentUser.id).updateData([
                    "groups": FieldValue.arrayUnion([ref])
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
    func editGroup(groupId: String, updatedGroup: Group, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("Group").document(groupId).updateData([
            "course": updatedGroup.course,
            "name": updatedGroup.name,
        ]) { err in
            if let err = err {
                completion(.failure(err))
            } else {
                completion(.success(()))
            }
        }
    }
    func getGroups(appUser: AppUser, completion: @escaping ([Group]) -> Void) {
        var groupsArray = [Group]()

        // Check if there are group references
        guard let groupRefs = appUser.groups, !groupRefs.isEmpty else {
            completion([])
            return
        }

        // Track the number of completed requests
        let dispatchGroup = DispatchGroup()

        for ref in groupRefs {
            dispatchGroup.enter()
            ref.getDocument { (document, error) in
                defer { dispatchGroup.leave() }

                if let error = error {
                    print("Error getting group: \(error.localizedDescription)")
                    return
                }

                if let document = document, document.exists {
                    do {
                        let group = try document.data(as: Group.self)
                        groupsArray.append(group)
                    } catch let error {
                        print("Error decoding group: \(error)")
                    }

                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(groupsArray)
        }
    }

}
