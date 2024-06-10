//
//  HomeView.swift
//  StudySesh
//
//  Created by Tim Kramer on 1/27/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @ObservedObject private var groupControl = GroupController()
    @ObservedObject private var courseControl = CourseController()
    

    @State private var groups: [Group]?
    @State private var showingCreationOptions = false
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Text("Study Sesh")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                    // Circle profile image placeholder
                    NavigationLink(destination: ProfileView(courseController: courseControl)
                        .environment(\.colorScheme, .light)
                        .environmentObject(authManager)){
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .background(Color.bloodOrange)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(courseControl.courses.indices, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(courseControl.courses[index].isSelected ? Color.bloodOrange : Color.gray)
                            .frame(width: 100, height: 40)
                            .overlay(
                                Text(courseControl.courses[index].name)
                                    .foregroundColor(.white)
                            )
                            .onTapGesture {
                                // Toggle the isSelected property of the course at this index
                                courseControl.courses[index].isSelected.toggle()
                            }
                    }
                }
            }
            
            ScrollView(showsIndicators: false) {
                ForEach(groupControl.groups , id: \.name){ group in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.bloodOrange)
                        .frame(width: UIScreen.main.bounds.width - 40, height: 100)
                        .overlay(
                            VStack {
                                Text(group.name)
                                Text(group.course)
                            }
                        )
                }
            }
            Spacer()

            Button(action: {
                        self.showingCreationOptions.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .blendMode(.multiply)
                            .foregroundColor(Color.bloodOrange)

                    }
                    .sheet(isPresented: $showingCreationOptions) {
                        CreationOptionsView()
                            .environment(\.colorScheme, .light)
                            .presentationDetents([.fraction(3/8)])
                    }
        }
        .background(Color.white)
        .onAppear {
            if authManager.appUser != nil && groupControl.groups.isEmpty {
                groupControl.getGroups(appUser: authManager.appUser!) { fetchedGroups in
                    groupControl.groups = fetchedGroups
                }
            }
            if let appUser = authManager.appUser, courseControl.courses.isEmpty {
                courseControl.getCourses(appUser: appUser) { fetchedCourses in
                    courseControl.courses = fetchedCourses
                }
            }
        }
    }
}

// Example of Category model
struct Category: Identifiable {
    var id = UUID()
    var name: String
    var isSelected: Bool
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AuthenticationManager())
    }
}
