//
//  ImageCache.swift
//  FinancialHouse
//
//  Created by Olgu on 17.10.2020.
//

import Foundation
import UIKit

typealias JSON = [String: Any]
private let imageCache = NSCache<NSString, UIImage>()
extension NSError {
    static func generalParsingError(domain: String) -> Error {
        return NSError(domain: domain, code: 400, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Error retrieving data", comment: "General Parsing Error Description")])
    }
}

final fileprivate class ImageManager {
    // MARK: - Public

    func downloadImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) -> URLSessionDataTask? {
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage, nil)
            return nil
        } else {
            return ImageManager.downloadData(url: url) { data, _, error in
                if let error = error {
                    completion(nil, error)
                } else if let data = data, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image, nil)
                } else {
                    completion(nil, NSError.generalParsingError(domain: url.absoluteString))
                }
            }
        }
    }

    // MARK: - Private

    fileprivate static func downloadData(url: URL, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) -> URLSessionDataTask {
        
        let task = URLSession(configuration: .ephemeral)
            .dataTask(with: URLRequest(url: url)) { data, response, error in
                completion(data, response, error)
            }
            
        task.resume()
        return task
    }

    fileprivate static func convertToJSON(with data: Data) -> JSON? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON
        } catch {
            return nil
        }
    }
}

var ImageManagerTaskAssociatedObjectHandle: UInt8 = 0

extension UIImageView {
    
    var task: URLSessionDataTask? {
        get {
            return objc_getAssociatedObject(self, &ImageManagerTaskAssociatedObjectHandle) as? URLSessionDataTask
        }
        set {
            objc_setAssociatedObject(self, &ImageManagerTaskAssociatedObjectHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setImage(urlString: String?) {
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }
        task = ImageManager().downloadImage(url: url) { (image, error) in
            
            guard let image = image,
                  error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
            }
            
        }
    }
    
    func cancelDownloadTask() {
        task?.cancel()
    }
    
}
