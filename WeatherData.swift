import Foundation

struct WeatherData: Decodable{
    
    let name: String
    let main: Main
    let weather: [Weather]
    let timezone: Double
    
    
}

struct Main: Decodable{
    let temp: Double

}
struct Weather: Decodable{
    let description: String
    let id: Int
}
