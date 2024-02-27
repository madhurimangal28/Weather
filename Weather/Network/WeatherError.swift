//
//  WeatherError.swift
//  Weather
//
//  Created by Madhuri Agrawal on 22/02/24.
//

import Foundation

enum WeatherError: LocalizedError {

    case invalidHttpResponse
    case invalidStatusCode(code: Int)
    case noResponse
    case decodingError(error: Error)
    case apiError(code: Int, message: String)
    case noNetwork
    case invalidInput(message: String)

    var title: String {
        switch self {
        case .noNetwork:
            return "No Internet Connection"
        case .invalidStatusCode:
            return "Sorry!"
        default:
            return "Oops!"
        }
    }

    var errorDescription: String {
        switch self {
        case let .apiError(_, message):
            if message.isEmpty {
                return "The service is unavailable. Please try after sometime."
            }
            return "\(message)"
        case .noNetwork:
            return "Could not connect to internet. Please check your network and try again."
        case .invalidStatusCode:
            return "Unfortunately our server is down at the moment, please try again after sometime."
        case .invalidInput(let message):
            return message
        default:
            return "The service is unavailable. Please try after sometime."
        }
    }
}
