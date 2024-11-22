//
//  ContentView.swift
//  BeerAdvisor
//
//  Created by Fritz Boyle on 11/21/24.
//

import SwiftUI
import UIKit

struct ContentView: View {
    // MARK: - State Variables
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var recommendations: String = ""
    @State private var isLoading = false

    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                // Image Display
                if let image = inputImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(10)
                        .padding()
                } else {
                    Rectangle()
                        .fill(Color.secondary)
                        .frame(height: 300)
                        .overlay(
                            Text("Tap the button to take a picture")
                                .foregroundColor(.white)
                                .font(.headline)
                        )
                        .cornerRadius(10)
                        .padding()
                }
                
                // Take Picture Button
                Button(action: {
                    self.showImagePicker = true
                }) {
                    Text("Take a Picture")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Loading Indicator
                if isLoading {
                    ProgressView("Fetching recommendations...")
                        .padding()
                }
                
                // Recommendations Text
                ScrollView {
                    Text(recommendations)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Beer Advisor")
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
    }
    
    // MARK: - Functions
    func loadImage() {
        guard let image = inputImage else { return }
        
        isLoading = true
        recommendations = ""
        
        NetworkManager.shared.sendImageForRecommendation(image: image) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let recommendation):
                    self.recommendations = recommendation
                case .failure(let error):
                    self.recommendations = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
