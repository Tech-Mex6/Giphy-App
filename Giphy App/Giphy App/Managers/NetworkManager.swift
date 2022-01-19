//
//  NetworkManager.swift
//  Giphy App
//
//  Created by meekam okeke on 1/16/22.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = "zgy45FWXJz5Oyf5aBhPXC3tmO2qDMi53"
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    ///This function is used to request for trending GIF data
    func fetchTrendingData(rating: String, completed: @escaping (Result<TrendingResponse, GAError>) -> Void) {
        let endPoint = "https://api.giphy.com/v1/gifs/trending?" + "api_key=\(apiKey)&limit=25" + "&rating=\(rating)"
        
        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidData))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let trendingResponse = try decoder.decode(TrendingResponse.self, from: data)
                completed(.success(trendingResponse))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    ///This function is used to request for GIF data via a query/keyword
    func fetchSearchData(query: String, completed: @escaping(Result<SearchResponse, GAError>) -> Void) {
        let endPoint = "https://api.giphy.com/v1/gifs/search?" + "api_key=\(apiKey)" + "&q=\(query)" + "&limit=25&offset=0&rating=pg&lang=en"
        
        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidData))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                completed(.success(searchResponse))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    ///This function is used to request for GIF data using an ID String
    func getDataByID(ID: String, completed: @escaping(Result<SearchResult, GAError>) -> Void) {
        let endPoint = "https://api.giphy.com/v1/gifs/" + "\(ID)?" + "api_key=\(apiKey)"
        
        guard let url = URL(string: endPoint) else {
            completed(.failure(.invalidData))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let getByIdResponse = try decoder.decode(SearchResult.self, from: data)
                completed(.success(getByIdResponse))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    ///This function is used to download the GIF Image
    func downloadImage(from urlString: String, completed: @escaping(UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
}
