//  NetworkManager.swift
//  BeerAdvisor
//
//  Created by Fritz Boyle on 11/21/24.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    let apiKey = "YOUR_API_KEY_HERE" // Replace with your actual API key
    let apiURL = "https://api.openai.com/v1/your-custom-endpoint" // Replace with your API endpoint
    
    func sendImageForRecommendation(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: apiURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // Convert image to base64
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NetworkError.invalidImage))
            return
        }
        let base64Image = imageData.base64EncodedString()
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the JSON payload
        let json: [String: Any] = [
            "image": base64Image,
            "other_parameters": "value" // Add other parameters as required by your API
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json, options: [])
        } catch {
            completion(.failure(NetworkError.invalidJSON))
            return
        }
        
        // Perform the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Ensure we have data
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            // Parse the response
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let recommendation = jsonResponse["recommendation"] as? String {
                    completion(.success(recommendation))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidImage
    case invalidJSON
    case noData
    case invalidResponse
}
