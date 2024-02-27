//
//  NetworkService.swift
//  Weather
//
//  Created by Madhuri Agrawal on 20/02/24.
//

import Foundation

protocol NetworkService {

    func executeRequest<Response: Decodable>(
        request: URLRequest,
        acceptableStatusCodes: [Int],
        completion: @escaping (Result<Response, Error>) -> Void
    )
}

extension NetworkService {

    func executeRequest<Response: Decodable>(
        request: URLRequest,
        completion: @escaping (Result<Response, Error>) -> Void
    ) {
        self.executeRequest(
            request: request,
            acceptableStatusCodes: Array(200 ..< 299),
            completion: completion
        )
    }
}
