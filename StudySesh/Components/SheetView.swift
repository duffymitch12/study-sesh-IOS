//
//  SheetView.swift
//  StudySesh
//
//  Created by Tim Kramer on 1/27/24.
//


import SwiftUI
struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var selectedCourses: Set<Int> = []
    @ObservedObject var courseController: CourseController
    
    var body: some View {
        VStack {
            Button("Save Selection") {
                dismiss()
            }
            .padding()
            
            List {
                ForEach(courseController.allCourses.indices, id: \.self) { index in
                    HStack {
                        Text("CSE \(courseController.allCourses[index])")
                            .foregroundColor(selectedCourses.contains(index) ? .blue : .primary)
                        
                        Spacer()
                        
                        if selectedCourses.contains(index) {
                            Image(systemName: "checkmark.square.fill") // Indicate selection
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "square") // Unselected state
                                .foregroundColor(.gray)
                        }
                    }
                    //                    .background(Color.white)
                    .onTapGesture {
                        if selectedCourses.contains(index) {
                            selectedCourses.remove(index) // Deselect
                        } else {
                            selectedCourses.insert(index) // Select
                        }
                    }
                    .padding(.vertical, 4)
                }
                .background(Color.white)
            }
            .background(Color.white)
        }
        .font(.title)
        .padding()
        .background(Color.white)
        .onAppear {
            courseController.getMajorCourses(major: authManager.appUser!.major) { fetchedAllCourseNames in
                DispatchQueue.main.async {
                    courseController.allCourses = fetchedAllCourseNames
                    
                    self.selectedCourses = Set(courseController.courses.compactMap { course in
                        courseController.allCourses.firstIndex(of: course.name)
                    })
                }
            }
        }
    }
}
