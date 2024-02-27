//
//  NetworkLayer.swift
//  Weather
//
//  Created by Madhuri Agrawal on 22/02/24.
//

import Foundation

class NetworkLayer: NetworkService {

    func executeRequest<Response: Decodable>(
        request: URLRequest,
        acceptableStatusCodes: [Int],
        completion: @escaping (Result<Response, Error>) -> Void
    ) {
        let dataTask = URLSession.shared.dataTask(
            with: request
        ) { [weak self] (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                print("Error:: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                completion(.failure(WeatherError.invalidHttpResponse))
                print("Error:: invalidHttpResponse")
                return
            }
            let statusCode = httpResponse.statusCode
            let json = try? JSONSerialization.jsonObject(
                with: data,
                options: .mutableContainers
            ) as? [String: AnyObject]
            let message = json?["message"] as? String ?? ""

            guard acceptableStatusCodes.contains(statusCode) else {
                completion(.failure(WeatherError.apiError(code: statusCode, message: message)))
                print("Error:: \(statusCode)")
                return
            }

            let response: Response
            do {
                let dataResponse = try JSONDecoder().decode(Response.self, from: data)
                response = dataResponse
                completion(.success(response))
            } catch {
                DispatchQueue.main.async {
                    print("Error:: \(error.localizedDescription)")
                    completion(.failure(WeatherError.decodingError(error: error)))
                }
                return
            }
        }
        dataTask.resume()
    }
}
