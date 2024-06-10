//
//  CreatPostView.swift
//  StudySesh
//
//  Created by Aaron Elkin on 1/27/24.
//

import SwiftUI

struct CreatPostView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    let postController = PostController()

    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .padding()
                .border(Color.gray)
                .padding(.horizontal)

            TextField("Description", text: $description)
                .padding()
                .border(Color.gray)
                .padding(.horizontal)

            Button("Create Post") {
                createPost()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Create Post"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func createPost() {
        // Assuming you have a Group struct that takes name and course
        let newPost = Post(title: title, message: description, timestamp: Date())

        // Assuming the current user is stored in authManager
        guard let currentUser = authManager.appUser else {
            alertMessage = "No current user found."
            showAlert = true
            return
        }

        postController.createPost(currentUser: currentUser, post: newPost ) { result in
            switch result {
            case .success(let documentReference):
                alertMessage = "Post created successfully"
                showAlert = true
            case .failure(let error):
                alertMessage = "Error creating group: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}

// Assume this is your Preview Provider
struct CreatPostView_Previews: PreviewProvider {
    static var previews: some View {
        CreationView().environmentObject(AuthenticationManager())
    }
}

