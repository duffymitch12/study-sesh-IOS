//
//  CreationOptionsView.swift
//  StudySesh
//
//  Created by Aaron Elkin on 1/27/24.
//

import SwiftUI

enum NavigationDestination {
    case createGroup
    case createPost
}

struct CreationOptionsView: View {
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                Button("Create a Group") {
                    navigationPath.append(NavigationDestination.createGroup)
                }
                .padding([.top, .bottom])

                Button("Create a Post") {
                    navigationPath.append(NavigationDestination.createPost)
                }
                .padding(.bottom)
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .createGroup:
                    CreationView()
                case .createPost:
                    CreatPostView()
                }
            }
        }
    }
}
