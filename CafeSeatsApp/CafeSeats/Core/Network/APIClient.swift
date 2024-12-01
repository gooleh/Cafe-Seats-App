// Network/APIClient.swift

import Foundation

class APIClient {
    static let shared = APIClient()
    private init() {}
    
    func fetchCafes(completion: @escaping (Result<[Cafe], Error>) -> Void) {
        guard let url = URL(string: "http://15.165.161.251/api/cafes") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let decodedCafes = try JSONDecoder().decode([Cafe].self, from: data)
                completion(.success(decodedCafes))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

enum APIError: Error {
    case invalidURL
    case noData
}
