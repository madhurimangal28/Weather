//
//  ViewState.swift
//  Weather
//
//  Created by Madhuri Agrawal on 22/02/24.
//

import Foundation

enum ViewState<T> {
    case empty
    case loading
    case ready(T)
    case error(Error)

    var isLoading: Bool {
        switch self {
        case .loading : return true
        default: return false
        }
    }
}
