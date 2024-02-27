//
//  WeatherDetailTableViewCell.swift
//  Weather
//
//  Created by Madhuri Agrawal on 22/02/24.
//

import UIKit

class WeatherDetailTableViewCell: UITableViewCell {

    @IBOutlet private weak var backgroundContainerView: UIView!
    @IBOutlet private weak var dateTimeLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var temperatureMinLabel: UILabel!
    @IBOutlet private weak var temperatureMaxLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var seaLevelLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var windSpeedLabel: UILabel!
    @IBOutlet private weak var windGustLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.clipsToBounds = true
        self.backgroundContainerView.layer.cornerRadius = 8.0
        self.backgroundContainerView.clipsToBounds = true
    }

    func configure(data: List) {
        self.dateTimeLabel.text = data.dtTxt ?? ""
        self.temperatureLabel.text = "\(data.main?.temp ?? 0)"
        self.temperatureMinLabel.text = "\(data.main?.tempMin ?? 0)"
        self.temperatureMaxLabel.text = "\(data.main?.tempMax ?? 0)"
        self.pressureLabel.text = "\(data.main?.pressure ?? 0)"
        self.seaLevelLabel.text = "\(data.main?.seaLevel ?? 0)"
        self.humidityLabel.text = "\(data.main?.humidity ?? 0)"
        self.windSpeedLabel.text = "\(data.wind?.speed ?? 0)"
        self.windGustLabel.text = "\(data.wind?.gust ?? 0)"
    }
}
