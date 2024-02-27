//
//  WeatherResponse.swift
//  Weather
//
//  Created by Madhuri Agrawal on 22/02/24.
//

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let cod: String?
    let message: Int?
    let cnt: Int?
    let list: [List]?
    let city: City?

    enum CodingKeys: CodingKey {
        case cod
        case message
        case cnt
        case list
        case city
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cod = try container.decodeIfPresent(String.self, forKey: .cod)
        self.message = try container.decodeIfPresent(Int.self, forKey: .message)
        self.cnt = try container.decodeIfPresent(Int.self, forKey: .cnt)
        self.list = try container.decodeIfPresent([List].self, forKey: .list)
        self.city = try container.decodeIfPresent(City.self, forKey: .city)
    }
}

// MARK: - City
struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population: Int?
    let timezone: Int?
    let sunrise: Double?
    let sunset: Double?

    enum CodingKeys: CodingKey {
        case id
        case name
        case coord
        case country
        case population
        case timezone
        case sunrise
        case sunset
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.coord = try container.decodeIfPresent(Coord.self, forKey: .coord)
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
        self.population = try container.decodeIfPresent(Int.self, forKey: .population)
        self.timezone = try container.decodeIfPresent(Int.self, forKey: .timezone)
        self.sunrise = try container.decodeIfPresent(Double.self, forKey: .sunrise)
        self.sunset = try container.decodeIfPresent(Double.self, forKey: .sunset)
    }

}

// MARK: - Coord
struct Coord: Codable {
    let lat: Double?
    let lon: Double?

    enum CodingKeys: CodingKey {
        case lat
        case lon
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lat = try container.decodeIfPresent(Double.self, forKey: .lat)
        self.lon = try container.decodeIfPresent(Double.self, forKey: .lon)
    }
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let main: Main?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let visibility: Int?
    let pop: Double?
    let snow: Snow?
    let sys: Sys?
    let dtTxt: String?
    let dateObject: Date?
    let dateString: String? // it contains only date String in "yyyy-MM-dd" format

    enum CodingKeys: String, CodingKey {
        case dt
        case main
        case weather
        case clouds
        case wind
        case visibility
        case pop
        case snow
        case sys
        case dtTxt = "dt_txt"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.dt = try container.decodeIfPresent(Int.self, forKey: .dt)
        self.main = try container.decodeIfPresent(Main.self, forKey: .main)
        self.weather = try container.decodeIfPresent([Weather].self, forKey: .weather)
        self.clouds = try container.decodeIfPresent(Clouds.self, forKey: .clouds)
        self.wind = try container.decodeIfPresent(Wind.self, forKey: .wind)
        self.visibility = try container.decodeIfPresent(Int.self, forKey: .visibility)
        self.pop = try container.decodeIfPresent(Double.self, forKey: .pop)
        self.snow = try container.decodeIfPresent(Snow.self, forKey: .snow)
        self.sys = try container.decodeIfPresent(Sys.self, forKey: .sys)
        self.dtTxt = try container.decodeIfPresent(String.self, forKey: .dtTxt)

        if let dtTxt = dtTxt,
           let (date, dateString) = convertdateTextToDateAndDateString(dtTxt: dtTxt) {
            self.dateObject = date
            self.dateString = dateString
        } else {
            self.dateObject = nil
            self.dateString = nil
        }
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?

    enum CodingKeys: CodingKey {
        case all
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.all = try container.decodeIfPresent(Int.self, forKey: .all)
    }
}

// MARK: - Main
struct Main: Codable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let seaLevel: Int?
    let grndLevel: Int?
    let humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.temp = try container.decodeIfPresent(Double.self, forKey: .temp)
        self.feelsLike = try container.decodeIfPresent(Double.self, forKey: .feelsLike)
        self.tempMin = try container.decodeIfPresent(Double.self, forKey: .tempMin)
        self.tempMax = try container.decodeIfPresent(Double.self, forKey: .tempMax)
        self.pressure = try container.decodeIfPresent(Int.self, forKey: .pressure)
        self.seaLevel = try container.decodeIfPresent(Int.self, forKey: .seaLevel)
        self.grndLevel = try container.decodeIfPresent(Int.self, forKey: .grndLevel)
        self.humidity = try container.decodeIfPresent(Int.self, forKey: .humidity)
        self.tempKf = try container.decodeIfPresent(Double.self, forKey: .tempKf)
    }
}

// MARK: - Snow
struct Snow: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.the3H = try container.decodeIfPresent(Double.self, forKey: .the3H)
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: String?

    enum CodingKeys: CodingKey {
        case pod
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pod = try container.decodeIfPresent(String.self, forKey: .pod)
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?

    enum CodingKeys: CodingKey {
        case id
        case main
        case description
        case icon
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.main = try container.decodeIfPresent(String.self, forKey: .main)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.icon = try container.decodeIfPresent(String.self, forKey: .icon)
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?

    enum CodingKeys: CodingKey {
        case speed
        case deg
        case gust
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.speed = try container.decodeIfPresent(Double.self, forKey: .speed)
        self.deg = try container.decodeIfPresent(Int.self, forKey: .deg)
        self.gust = try container.decodeIfPresent(Double.self, forKey: .gust)
    }
}


fileprivate func convertdateTextToDateAndDateString(dtTxt: String) -> (Date, String)? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date =  dateFormatter.date(from: dtTxt)
    if let date = date {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return (date, dateString)
    } else {
        return nil
    }
}

struct WeatherModel {
    let dateText: String
    let displayDateText: String
    let lists: [List]

    let dateObject: Date?

    init(dateText: String, lists: [List]) {
        self.dateText = dateText
        self.lists = lists

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateText)

        if let date = date {
            self.dateObject = date
            dateFormatter.dateStyle = DateFormatter.Style.long
            displayDateText = dateFormatter.string(from: date)
        } else {
            displayDateText = dateText
            self.dateObject = nil
        }
    }
}

struct WeatherHeaderModel {
    let cityText: String
    let latLongText: String
    let sunriseSunsetText: String

    init(cityText: String, latLongText: String, sunriseSunsetText: String) {
        self.cityText = cityText
        self.latLongText = latLongText
        self.sunriseSunsetText = sunriseSunsetText
    }
}
