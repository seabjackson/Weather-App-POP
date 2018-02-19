//
//  NetworkController.swift
//  WeatherApp
//
//  Created by Seab Jackson on 2/18/18.
//  Copyright © 2018 Nyisztor, Karoly. All rights reserved.
//

import Foundation

public protocol NetworkController {
    func fetchCurrentWeatherData(city: String, completionHandler: @escaping (WeatherData?, NetworkControllerError?) -> Void)
}

public struct WeatherData {
    var temperature: Float
    var condition: String
    var unit: TemperatureUnit
}

public enum TemperatureUnit: String {
    case scientific = "K"
    case metric = "C"
    case imperial = "F"
}

public enum NetworkControllerError: Error {
    case invalidURL(String)
    case invalidPayLoad(URL)
    case forwarded(Error)
}

