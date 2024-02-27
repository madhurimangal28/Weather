//
//  WeatherTableHeaderView.swift
//  Weather
//
//  Created by Madhuri Agrawal on 22/02/24.
//

import UIKit

class WeatherTableHeaderView: UITableViewHeaderFooterView {

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    func configure(data: WeatherModel) {
        dateLabel.text = data.displayDateText
        descriptionLabel.text = data.lists.first?.weather?.first?.description?.capitalized ?? ""
    }
}
