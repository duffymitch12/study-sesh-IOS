//
//  AsyncImage.swift
//  StudySesh
//
//  Created by Tim Kramer on 1/27/24.
//

import SwiftUI

struct AsyncImageView: View {
    @State private var uiImage: UIImage?
    

    let url: URL

    var body: some View {
        VStack(alignment: .trailing) { 
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
            } else {
                Text("Loading...")  // Placeholder for loading state
            }
        }
        .onAppear {  // Apply .onAppear to the VStack
            downloadImageData(from: url) { image in
                DispatchQueue.main.async {
                    self.uiImage = image
                }
            }
        }
    }
    
    func downloadImageData(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
