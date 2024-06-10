//
//  SignUpView.swift
//  StudySesh
//
//  Created by Tim Kramer on 1/27/24.
//

import SwiftUI

//ADDED-------------------------------------------------------------------------
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.isShown = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isShown = false
        }
    }
}


//ADDED-------------------------------------------------------------------------

struct SignUpView: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @StateObject var viewModel = SignUpViewModel()
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    //ADDED--------------------------------------------------------------------
    @State private var emailInvalid = false
    @State private var passwordInvalid = false
    @State private var confirmPasswordInvalid = false
    @State private var showAlert = false
    @State private var alertMessage = "ERROR: "

    //ADDED--------------------------------------------------------------------

    @State private var shouldNavigateToSignIn = false  // Add this line
    //ADDED 
    @State private var showImagePicker = false
    @State private var profileImage: UIImage?

    
    var body: some View {
        
        VStack(spacing: 20) {
//            if(emailInvalid){
//                TextField("Enter Email", text:$email)
//                    .keyboardType(.emailAddress)
//                    .autocapitalization(.none)
//                    .border(Color.red)
//                    .foregroundColor(.red)
//                    .padding()
//            }
//            else{
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .border(Color.gray)
//            }
            
//            if(passwordInvalid){
//                SecureField("Password", text: $password)
//                    .padding()
//                    .border(Color.gray)
//                    .border(Color.red)
//                    .foregroundColor(.red)
//            }
//            else{
                SecureField("Password", text: $password)
                    .padding()
                    .border(Color.gray)
//            }
            
//            if(confirmPasswordInvalid){
//                SecureField("Confirm Password", text: $confirmPassword)
//                    .padding()
//                    .border(Color.gray)
//                    .border(Color.red)
//                    .foregroundColor(.red)
//            }
//            else{
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .border(Color.gray)
//            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            //ADDED---------------------------------------------------------------
            Button("Upload Profile Image") {
                            self.showImagePicker = true
                        }
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
            
            Button("Sign Up") {
                // Validate fields
                emailInvalid = email.isEmpty
                passwordInvalid = password.isEmpty
                confirmPasswordInvalid = confirmPassword.isEmpty
//ADDED---------------------------------------------------------------
                var errorMessage = ""
                    if email.isEmpty {
                        errorMessage += "Email is required.\n"
                    }
                    if password.isEmpty {
                        errorMessage += "Password is required.\n"
                    }
                    if confirmPassword.isEmpty {
                        errorMessage += "Confirm Password is required.\n"
                    }

                    if errorMessage.isEmpty {
                        viewModel.signUp(email: email, password: password, confirmPassword: confirmPassword, profileImg: profileImage ?? UIImage())
                    } else {
                        alertMessage = errorMessage
                        showAlert = true
                    }
//ADDED---------------------------------------------------------------

//                viewModel.signUp(email: email, password: password, confirmPassword: confirmPassword)
            }.sheet(isPresented: $showImagePicker) {
                ImagePicker(isShown: $showImagePicker, image: $profileImage)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Sign Up Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }

            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
                        
            NavigationLink(destination: SignInView().environmentObject(authenticationManager)){
                Text("Already have an account? Sign In")
            }
            .padding()
            .foregroundColor(Color.blue)
                    
        }
        .padding()
        .onAppear{
            self.viewModel.setAuth(auth: self.authenticationManager)
        }
        
    }
}


#Preview {
    SignUpView()
        .environmentObject(AuthenticationManager())
}
