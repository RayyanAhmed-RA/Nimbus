import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didWeatherUpdate(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=568f88270e4d139606e28bfe9099e303"
    
    var delegate: WeatherManagerDelegate?
    
    
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(cityName)
        print(urlString)
        performRequest(with:  urlString)
        
    }
    func fetchWeather(lat: CLLocationDegrees, long: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(long)"
        print(lat)
        print(long)
        performRequest(with: urlString)
        
    }
    
    func performRequest(with urlString: String){
        //        1. Create URL string
        
        if let url = URL(string: urlString){
            //            2. Create a URL session
            
            let session = URLSession(configuration: .default)
            //            3. Give the session a task
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error! )
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON( safeData){
                        let weatherVC = WeatherViewController()
                        self.delegate?.didWeatherUpdate(self,  weather: weather)
                        
                    }
                }
            }
            //            4. Start the task
            
            task.resume()
            
        }
    }
        
        func parseJSON(_ weatherData: Data) -> WeatherModel? {
            let decoder = JSONDecoder()
            do{
               let decodedData =  try decoder.decode(WeatherData.self, from: weatherData)
                print(decodedData.main.temp)
                let id = decodedData.weather[0].id
                let name = decodedData.name
                let temp = decodedData.main.temp
                
                let weather = WeatherModel(cityName: name, temperature: temp, conditionId: id)
                print(weather.conditionName)
                return weather
            }
            catch {
                self.delegate?.didFailWithError(error: error)
                return nil
            }
    }
    
    
}
