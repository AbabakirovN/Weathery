//
//  CurrentWeatherViewController.swift
//  Weathery
//
//  Created by Nurzhan Ababakirov on 11/18/19.
//  Copyright © 2019 Nurzhan Ababakirov. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController
{
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureScaleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var cityTextLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureMinLabel: UILabel!
    @IBOutlet weak var temperatureMaxLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
        
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=42.874722&lon=74.612222&APPID=3331e666239ea2e7435b26c22893307c")else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data , error == nil
            {
                do
                {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else { return }
                    guard let weatherDetails = json["weather"] as? [[String: Any]], let weatherMain = json["main"] as? [String: Any] else { return }
                    let temp = Int(weatherMain["temp"] as? Double ?? 0)
                    let tempMin = Int(weatherMain["temp_min"] as? Double ?? 0)
                    let tempMax = Int(weatherMain["temp_max"] as? Double ?? 0)
                    let humidity = Int(weatherMain["humidity"] as? Double ?? 0)
                    
                    let description = (weatherDetails.first?["description"] as? String)?.capitalizingFirstLetter()
                    DispatchQueue.main.async {
                        self.setWeather(weather: weatherDetails.first?["main"] as? String, description: description, temp: temp, tempMin: tempMin, tempMax: tempMax, humidity: humidity)
                    }
                } catch{
                    print("We had an error retriving the weather...")
                }
            }
            
        }
        task.resume()
                
    }
    
    func setWeather(weather: String?, description: String?, temp: Int, tempMin: Int, tempMax: Int, humidity: Int)
    {
       
        let tempInCelcium = (temp) - 273
        temperatureLabel.text = "\(tempInCelcium)"
        
        let tempMinInCelcium = (tempMin)-273
        temperatureMinLabel.text = "\(tempMinInCelcium)"
        
        let tempMaxInCelcium = (tempMax)-273
        temperatureMaxLabel.text = "\(tempMaxInCelcium)"
        
        humidityLabel.text = "\(humidity) %"
        
        switch weather {
        case "Clear":
            weatherImageView.image = UIImage(named: "sunny")
        case "Rain":
            weatherImageView.image = UIImage(named: "rain")
        case "Snow":
            weatherImageView.image = UIImage(named: "snow")
        case "Smoke":
            weatherImageView.image = UIImage(named: "cloudy")
        case "Mist":
            weatherImageView.image = UIImage(named: "hazy")
        default:
            weatherImageView.image = UIImage(named: "cloudy")
            
        }
    }

}

extension String
{
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

extension UIViewController{
    @objc func swipeAction(swipe:UISwipeGestureRecognizer)
    {
        switch swipe.direction.rawValue{
        case 1:
            performSegue(withIdentifier: "goLeft", sender: self)
        case 2:
            performSegue(withIdentifier: "goRight", sender: self)
        default:
            break
        }
    }
}


