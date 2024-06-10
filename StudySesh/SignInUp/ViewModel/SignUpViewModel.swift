//
//  SignUpViewModel.swift
//  StudySesh
//
//  Created by Tim Kramer on 1/27/24.
//
import SwiftUI
import FirebaseAuth

class SignUpViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    var authenticationManager: AuthenticationManager?
    
    func setAuth(auth: AuthenticationManager){
        self.authenticationManager = auth
    }
    
    func signUp(email: String, password: String, confirmPassword: String, profileImg: UIImage) {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        authenticationManager?.uploadProfileImage(profileImg) {[weak self] imageUrl in
            // Handle the completion here
            DispatchQueue.main.async {
                // 'imageUrl' is the URL string of the uploaded image or 'nil' if the upload failed
                if let imgUrl = imageUrl {
                    // Use 'imgUrl' here
                    self?.authenticationManager?.signUp(email: email, password: password, imgUrl: imgUrl)
                } else {
                    // Update the error message state variable
                    // SwiftUI will automatically update the view to reflect this change
                    self?.errorMessage = "Could not upload profile image"
                    
                }
            }
        }
        
    }
}
