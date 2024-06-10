//
//  ProfileView.swift
//  StudySesh
//
//  Created by Tim Kramer on 1/27/24.
//

import SwiftUI
import FirebaseFirestore


struct ProfileView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var scale: CGFloat = 1.0
    @State private var userInfo : AppUser?
    @State private var showingCourses = false
    @State private var courses: [Course] = []
    @ObservedObject var courseController: CourseController
    
    var body: some View {
        VStack{
            ZStack{
                HStack {
                    VStack{
                        Text(authManager.appUser!.name)
                            .font(.system(size: 24))
                            .fontWeight(.medium)
                            .padding()
                        Link(authManager.appUser!.email, destination: URL(string:authManager.appUser!.email )!)
                            .font(.subheadline)
                            .foregroundColor(.accentColor)
                        Text("Major: ") .font(.headline) +
                        Text(authManager.appUser?.major ?? "")
                            .foregroundColor(.black)
                    }
                    Spacer()
                    AsyncImageView(url: URL(string: "https://imgs.search.brave.com/I3Z4J_5i46s8kTHkw6TmFTt7zqseAzIO948ubKsLyr0/rs:fit:500:0:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvY29tbW9ucy90/aHVtYi8xLzEwL1Jp/dmVyYS1DYW1wYmVs/bC1zaGFrZV8lMjhj/cm9wcGVkJTI5Lmpw/Zy81MTJweC1SaXZl/cmEtQ2FtcGJlbGwt/c2hha2VfJTI4Y3Jv/cHBlZCUyOS5qcGc")!)
                    
                        .padding()
                }
                .background(Color.bloodOrange)
                
                
            }
            
            
            HStack(alignment: .center){
                Text("Courses: ")
                    .font(.headline)
                    .padding()
                Button("Show Sheet") {
                    showingCourses.toggle()
                }
                .sheet(isPresented: $showingCourses) {
                    SheetView(courseController: courseController)
                        .environmentObject(authManager)
                        .environment(\.colorScheme, .light)
                }
            }
            ScrollView{
                VStack {
                    ForEach((courses).indices, id: \.self) { index in
                        if(!courses[index].isDeleted){
                            HStack{
                                Text(courses[index].name)
                                    .foregroundColor(.black)
                                    .font(.subheadline)
                                    .padding()
                                Button(action: {
                                    courses[index].isDeleted = true
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .frame(width: 8, height: 8)
                                }
                                .padding()
                                .background(Color.red.opacity(0.8))
                                .cornerRadius(8)
                            }
                            .frame(maxWidth: .infinity)
                            .background(.tertiary.opacity(0.8))
                            .cornerRadius(8)
                        }
                        else{
                            Text("You deleted the course")
                                .font(.subheadline)
                        }
                    }
                }
                
            }
        }
        .background(Color.white)
        .onAppear{
            if authManager.appUser != nil {
                self.userInfo = authManager.appUser
                print("appUser defined")
                
                if let appUser = authManager.appUser, courseController.courses.isEmpty {
                    courseController.getCourses(appUser: appUser) { fetchedCourses in
                        courseController.courses = fetchedCourses
                    }
                }
                //                    print("Courses array: " + courses)
            }
            else{
                print("appUser undefined")
            }
        }
    }
}

#Preview {
    ProfileView(courseController: CourseController())
}

