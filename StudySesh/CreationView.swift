//
//  CreationView.swift
//  StudySesh
//
//  Created by Tim Kramer on 1/27/24.
//

import SwiftUI

struct CreationView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var groupName: String = ""
    @State private var courseName: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    let groupController = GroupController()

    var body: some View {
        VStack {
            TextField("Group Name", text: $groupName)
                .padding()
                .border(Color.gray)
                .padding(.horizontal)

            TextField("Course Name", text: $courseName)
                .padding()
                .border(Color.gray)
                .padding(.horizontal)

            Button("Create Group") {
                createGroup()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            Spacer()
        }
        .background(Color.white)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Group Creation"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func createGroup() {
        // Assuming you have a Group struct that takes name and course
        let newGroup = Group(course: courseName, name: groupName, members: [])

        // Assuming the current user is stored in authManager
        guard let currentUser = authManager.appUser else {
            alertMessage = "No current user found."
            showAlert = true
            return
        }

        groupController.createGroup(currentUser: currentUser, group: newGroup) { result in
            switch result {
            case .success(let documentReference):
                alertMessage = "Group created successfully with ID: \(documentReference.documentID)"
                showAlert = true
            case .failure(let error):
                alertMessage = "Error creating group: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}

// Assume this is your Preview Provider
struct CreationView_Previews: PreviewProvider {
    static var previews: some View {
        CreationView().environmentObject(AuthenticationManager())
    }
}
