//
//  HomeViewModel.swift
//  Weather
//
//  Created by Madhuri Agrawal on 20/02/24.
//

import Foundation

class HomeViewModel {

    private let networkService: NetworkService = NetworkLayer()
    private let apiKey: String = "f8796487cad799b250c745dd2306acc4"

    let defaultCity = "DELHI"
    private(set) var weatherModelList: [WeatherModel] = []
    private(set) var weatherHeaderModel: WeatherHeaderModel?

    enum State {
        case getWeatherData
    }

    // MARK: - View state
    var viewState: ViewState<State> = .empty {
        didSet {
            DispatchQueue.main.async {
                self.onViewStateChange?(self.viewState)
            }
        }
    }

    var onViewStateChange: ((_ viewState: ViewState<State>) -> Void)?

    func getWeather(cityName: String) {
        guard !cityName.isEmpty else {
            viewState = .error(
                WeatherError.invalidInput(message: "City name can not be empty.")
            )
            return
        }
        guard let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=\(apiKey)"
            .addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { return }
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        viewState = .loading
        networkService.executeRequest(
            request: urlRequest
        ) { [weak self] (result: Result<WeatherResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.parseWeatherResponse(data: response)
                self.parseWeatherHeader(data: response.city)
                self.viewState = .ready(.getWeatherData)
            case .failure(let error):
                self.viewState = .error(error)
            }
        }
    }

    private func convertUnixDateInLocal(unix: Double) -> String {
        let date = Date(timeIntervalSince1970: unix)
        let dateformatter = DateFormatter()
        dateformatter.timeStyle = DateFormatter.Style.medium
        dateformatter.timeZone = .current
        let localDate = dateformatter.string(from: date)
        return localDate
    }

    private func parseWeatherResponse(data: WeatherResponse) {
        var dateWiseWeatherDataList: [String: [List]] = [:]
        if let weatherList = data.list, !weatherList.isEmpty {
            for weatherObject in weatherList {
                if let dateString = weatherObject.dateString {
                    if let _ = dateWiseWeatherDataList[dateString] {
                        // uncomment this line if wanna show different times weather on single date
                        // dateWiseWeatherDataList[dateString]?.append(weatherObject)
                    } else {
                        dateWiseWeatherDataList[dateString] = [weatherObject]
                    }
                }
            }
        }
        self.weatherModelList = []
        for (key, value) in dateWiseWeatherDataList {
            let weatherModelObject = WeatherModel(dateText: key, lists: value)
            self.weatherModelList.append(weatherModelObject)
        }
        self.weatherModelList = self.weatherModelList.sorted(by: {
            if let firstDateObject = $0.dateObject,
               let secondDateObject = $1.dateObject {
                return firstDateObject < secondDateObject
            } else {
                return false
            }
        })
    }

    private func parseWeatherHeader(data: City?) {
        guard let data = data else { return }
        let cityText = "\(data.name ?? ""), \(data.country ?? "")"
        let latLongText = "Lat: \(data.coord?.lat ?? 0.0)  |  Long: \(data.coord?.lon ?? 0.0)"
        let sunriseSunsetText: String
        if let sunriseUnix = data.sunrise,
           let sunsetUnix = data.sunset {
            let sunriseTime = convertUnixDateInLocal(unix: sunriseUnix)
            let sunsetTime = convertUnixDateInLocal(unix: sunsetUnix)
            sunriseSunsetText = "Sunrise: \(sunriseTime)  |  Sunset: \(sunsetTime)"
        } else {
            sunriseSunsetText = ""
        }
        self.weatherHeaderModel = WeatherHeaderModel(
            cityText: cityText,
            latLongText: latLongText,
            sunriseSunsetText: sunriseSunsetText
        )
    }
}
