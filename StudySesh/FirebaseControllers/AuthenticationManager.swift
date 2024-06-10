//
//  AuthenticationManager.swift
//  StudySesh
//
//  Created by Tim Kramer on 1/27/24.
//

import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class AuthenticationManager: ObservableObject {
    @Published var appUser: AppUser?
    @Published var isAuthenticated = false
    var userControl = UserController()
    
    private var db = Firestore.firestore()
    
    @Published var isLoadingUser = false // New loading state

    
    init() {
        // Automatically try to sign in the user on app launch
        autoSignIn()
    }
    
    func autoSignIn() {
        isLoadingUser = true
        let currentUser = Auth.auth().currentUser
        if currentUser != nil {
            fetchUserInfo(uid: currentUser!.uid)
        } else {
            isLoadingUser = false // Stop loading if no user
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user {
                self.fetchUserInfo(uid: user.uid)
            } else {
                // Handle errors such as incorrect credentials
                self.isAuthenticated = false
                print(error?.localizedDescription ?? "Unknown error")
            }
        }
    }
    
    func signUp(email: String, password: String, imgUrl: String){
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print(error)
            } else if let user = authResult?.user {
                // User successfully created
                self?.userControl.signUp(uid: (authResult?.user.uid)! ,  email: email, displayName: "Tim", major: "CSE", imgUrl: imgUrl)
                self?.signIn(email: email, password: password)
            }
        }
    }
//ADDED---------------------------------------------------------------
    func uploadProfileImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        // Convert UIImage to Data
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            completion(nil)
            return
        }

        // Define path in storage
        let storageRef = Storage.storage().reference().child("profile_images/\(UUID().uuidString)")

        // Upload image data
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard error == nil else {
                completion(nil)
                return
            }

            // Retrieve download URL
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(nil)
                    return
                }

                completion(downloadURL.absoluteString)
            }
        }
    }
//ADDED---------------------------------------------------------------

    func fetchUserInfo(uid: String) {
        let docRef = db.collection("appUser").document(uid)        
        
        docRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                do {
                    let user = try document.data(as: AppUser.self)
                    // Successfully decoded `AppUser`, now update the published `user` property
                    DispatchQueue.main.async {
                        self?.appUser = user
                        self?.isAuthenticated = true
                        self?.isLoadingUser = false
                    }
                    
                    
                } catch {
                    // Handle the decoding error
                    print("Error decoding user: \(error)")
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isAuthenticated = false
            self.appUser = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
