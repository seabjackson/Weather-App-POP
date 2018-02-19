import Foundation

final class OpenWeatherMapNetworkController: NetworkController {
    public var tempUnit: TemperatureUnit = .imperial
    
    func fetchCurrentWeatherData(city: String, completionHandler: @escaping (WeatherData?, NetworkControllerError?) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil , delegateQueue: OperationQueue.main)
        let endPoint = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&units=\(tempUnit)&appid=\(API.key)"
        
        let safeURLString = endPoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let endpointURL = URL(string: safeURLString!) else {
            completionHandler(nil, NetworkControllerError.invalidURL(safeURLString!))
            return
        }
        
        let dataTask = session.dataTask(with: endpointURL) { (data, response, error) in
            guard error == nil else {
                completionHandler(nil, NetworkControllerError.forwarded(error!))
                return
            }
            
            guard let jsonData = data else {
                completionHandler(nil, NetworkControllerError.invalidPayLoad(endpointURL))
                return
            }
            
            self.decode(jsonData: jsonData, endpointURL: endpointURL, completionHandler: completionHandler)
            
        }
        dataTask.resume()
        
    }
    
    
    private func decode(jsonData: Data, endpointURL: URL, completionHandler: @escaping (WeatherData?, NetworkControllerError?) -> Void) {
        let decoder = JSONDecoder()
        do {
            let weatherInfo = try decoder.decode(OpenMapWeatherData.self, from: jsonData)
            
            let weatherData = WeatherData(temperature: weatherInfo.main.temp, condition: (weatherInfo.weather.first?.main ?? "?"), unit: self.tempUnit)
            completionHandler(weatherData, nil)
        } catch let error {
            completionHandler(nil, NetworkControllerError.forwarded(error))
        }
    }
}


private enum API {
    static let key = "a93b80c1bdffdcd3f0346ea3d36691ea"
}
