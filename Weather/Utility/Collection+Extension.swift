//
//  Collection+Extension.swift
//  Weather
//
//  Created by Madhuri Agrawal on 22/02/24.
//

import Foundation

//  MARK: - To get safe index
public extension Swift.Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

