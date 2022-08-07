//
//  UnshrimpService.swift
//  unsplashrimp
//
//  Created by HAKKYU KIM on 2022/06/24.
//

import Foundation

class UnshrimpService {
    
    private init() {
    }
    
    static let shared = UnshrimpService()
    
    static let appKey = "LWJQnJMIXhNynX386YcYzWFrJltabRekTOCZ1JvYpvI"
    
    static let secretKey = "186oiBaE53lyWgk1DntAibaQDgjCAT51EjtCdAy10c0"
    
    // Host of Unsplash API Service
    static let baseUrl: String = "https://api.unsplash.com/"
    
    static let headers: [String : String] = [
        "Accept-Version" : "v1",
        "Authorization" : "Client-ID \(appKey)"
    ]
    
    enum HTTPMethod: String {
        case get, post, put, delete
    }
    
    var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func requestTopics(onSuccess: @escaping (([UnTopic]) -> Void),
onFailure: @escaping ((UnError) -> Void)) {
        var urlComponents = URLComponents(string: UnshrimpService.baseUrl)
        urlComponents?.path = "/topics"
        urlComponents?.queryItems = [
            URLQueryItem(name: "order_by", value: "featured")
        ]
        
        guard let url = urlComponents?.url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue.uppercased()
        urlRequest.allHTTPHeaderFields = UnshrimpService.headers
        
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            print("👩‍🌾 Request \(urlRequest.url!)")
            print("🧑‍💻 Response \(httpResponse.statusCode)")
            
            if let data = data {
                if (200...299).contains(httpResponse.statusCode) {
                    print("✅ Success", data)
                    do {
                        let untopic = try JSONDecoder().decode([UnTopic].self, from: data)
                        DispatchQueue.main.async {
                            onSuccess(untopic)
                        }
                        
                    } catch let decodingError {
                        print("🔴 Failure", decodingError)
                        DispatchQueue.main.async {
                            onFailure(.decodingError)
                        }
                    }
                } else {
                    print("❌ Failure", String(data: data, encoding: .utf8)!)
                    let unError = self.decodeError(data)
                    DispatchQueue.main.async {
                        onFailure(unError)
                    }
                    
                }
            }
            
            if let error = error {
                print("❌ Failure (Internal)", error.localizedDescription)
                DispatchQueue.main.async {
                    onFailure(UnError(errors: [error.localizedDescription]))
                }
                return
            }
        }.resume()
    }
    
    private var currentPage: [UnTopic: Int] = [:]
    
    func requestTopicPhoto(from topic: UnTopic, firstPage: Bool = false, onSuccess: @escaping (([UnPhoto]) -> Void), onFailure: @escaping ((UnError) -> Void)) {
        
        if firstPage {
            self.currentPage[topic] = 1
        } else if let currentPage = self.currentPage[topic] {
            self.currentPage[topic] = currentPage + 1
        }
        
        var urlComponents = URLComponents(string: UnshrimpService.baseUrl)
        urlComponents?.path = "/topics/\(topic.id)/photos"
        
        if let targetPage = self.currentPage[topic] {
            urlComponents?.queryItems = [
                URLQueryItem(name: "page", value: String(targetPage))
            ]
        }
        
        guard let url = urlComponents?.url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue.uppercased()
        urlRequest.allHTTPHeaderFields = UnshrimpService.headers
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            print("👩‍🌾 Request \(urlRequest.url!)")
            print("🧑‍💻 Response \(httpResponse.statusCode)")
            
            if let data = data {
                if (200...299).contains(httpResponse.statusCode) {
                    print("✅ Success", data)
                    do {
                        let photos = try JSONDecoder().decode([UnPhoto].self, from: data)
                        DispatchQueue.main.async {
                            onSuccess(photos)
                        }
                    } catch let decodingError {
                        print("🔴 Failure", decodingError)
                        DispatchQueue.main.async {
                            onFailure(.decodingError)
                        }
                    }
                } else {
                    print("❌ Failure", String(data: data, encoding: .utf8)!)
                    DispatchQueue.main.async {
                        onFailure(.decodingError)
                    }
                }
            }
            
            if let error = error {
                print("❌ Failure (Internal)", error.localizedDescription)
                DispatchQueue.main.async {
                    onFailure(UnError(errors: [error.localizedDescription]))
                }
                return
            }
        }.resume()
    }
    
    func requestSearchPhotos(query: String, onSuccess: @escaping (([UnPhoto]) -> Void)) {
        var urlComponents = URLComponents(string: UnshrimpService.baseUrl)
        urlComponents?.path = "/search/photos"
        urlComponents?.queryItems = [.init(name: "query", value: query)]
        
        guard let url = urlComponents?.url else { return }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue.uppercased()
        urlRequest.allHTTPHeaderFields = UnshrimpService.headers
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            print("👩‍🌾 Request \(urlRequest.url!)")
            print("🧑‍💻 Response \(httpResponse.statusCode)")
            
            if let data = data {
                if (200...299).contains(httpResponse.statusCode) {
                    print("✅ Success", data)
                    do {
                        let searchResponse = try self.decoder.decode(UNSearchResponse.self, from: data)
                        DispatchQueue.main.async {
                            onSuccess(searchResponse.results)
                        }
                    } catch let decodingError {
                        print("🔴 Failure", decodingError)
                    }
                } else {
                    print("❌ Failure", String(data: data, encoding: .utf8)!)
                }
            }
            
            if let error = error {
                print("❌ Failure (Internal)", error.localizedDescription)
                return
            }
        }.resume()
    }
    
    func decodeError(_ data: Data) -> UnError {
        do {
            let unError = try JSONDecoder().decode(UnError.self, from: data)
            return unError
        } catch {
            return .decodingError
        }
    }
}


