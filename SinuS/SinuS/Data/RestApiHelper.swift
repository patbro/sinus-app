//
//  RestApiHelper.swift
//  SinuS
//
//  Created by Loe Hendriks on 06/01/2023.
//

import Foundation

public class RestApiHelper {
    public static func perfomRestCall(request: URLRequest) -> Data? {
        let semaphore = DispatchSemaphore.init(value: 0)
        let session = URLSession.shared
        var returnObject: Data?

        let task = session.dataTask(with: request, completionHandler: { data, response, _ -> Void in
            defer { semaphore.signal() }

            if let httpResponse = response as? HTTPURLResponse {
                ContentView.Cookie = httpResponse.value(forHTTPHeaderField: "Set-Cookie") ?? ""
            }

            returnObject = data!
        })

        task.resume()
        semaphore.wait()
        return returnObject
    }

    public static func createRequest(type: String, url: String, setCookie: Bool = true) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = type
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if setCookie {
            request.addValue(ContentView.Cookie, forHTTPHeaderField: "Cookie")
        }

        return request
    }
}
