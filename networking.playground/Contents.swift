import UIKit
import PlaygroundSupport

var components = URLComponents()

components.scheme = "https"
components.host = "api.github.com"
components.path = "/users/phucledien"

guard let url = components.url else {
    preconditionFailure("Failed to construct URL")
}

let label = UILabel()
label.textColor = .white
label.numberOfLines = 0
label.frame.size = CGSize(width: 300, height: 300)
PlaygroundPage.current.liveView = label

let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        DispatchQueue.main.async {
        if let data = data {
            label.text = String(decoding: data, as: UTF8.self)
        } else {
            label.text = error?.localizedDescription
        }
    }
}

task.resume()
