//
//  SignInView.swift
//  StudySesh
//
//  Created by Tim Kramer on 1/27/24.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?

    var body: some View {
        
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .border(Color.gray)

            SecureField("Password", text: $password)
                .padding()
                .border(Color.gray)

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button("Sign In") {
                authenticationManager.signIn(email: email, password: password)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            // Add a sign up navigation link or button here if needed
        }
        .padding()
    }
}


#Preview {
    SignInView()
        .environmentObject(AuthenticationManager())
}
