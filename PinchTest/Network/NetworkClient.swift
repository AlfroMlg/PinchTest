//
//  NetworkClient.swift
//  PinchTest
//
//  Created by Alfredo Martin-Hinojal Acebal on 8/2/22.
//

import Foundation
protocol EndPointType {
    var baseUrl: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task : HTTPTask { get }
}

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask : URLSessionDataTaskProtocol{
}

extension URLSession : URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return (dataTask(with: request as URLRequest, completionHandler: completionHandler as URLSessionProtocol.DataTaskResult) as URLSessionDataTask)
    }
}

protocol Networkable : AnyObject {
    associatedtype EndPoint: EndPointType
    func request<K: Codable>(route: EndPoint, completion: @escaping (Result<[K], Error>) -> Void)
    
}
enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}
public typealias HTTPHeaders = [String:String]
public typealias Parameters = [String:Any]
public enum HTTPTask {
    case request
}
public protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
public enum DataType {
    case albums(page: Int)
    case photos(userId: Int)
}
extension DataType : EndPointType {
    
    var task: HTTPTask {
        switch self {
        case .albums:
            return .request
        case .photos:
            return .request
        }
    }
    
    var baseUrl: String {
        return "http://testapi.pinch.nl:3000"
    }
    
    var path: String {
        switch self {
        case .albums(let page):
            return "/albums?_page=" + "\(page)"
        case .photos(let userId):
            return "/photos?albumId=" + "\(userId)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
}

class NetworkManager<EndPoint: EndPointType>: Networkable {
    
    lazy var session : URLSessionProtocol = URLSession.shared
    
    /**
     Network request to get array
     */
    func request<K: Codable>(route: EndPoint, completion: @escaping (Result<[K], Error>) -> Void) {
        
        let request = self.buildRequest(from: route)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let jsonData = data {
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode([K].self, from: jsonData)
                    let result : Result<[K],Error> = Result.success(response)
                    completion(result)
                } catch {
                    completion(.failure(error))
                }
            } else {
                let error = NSError(domain: "Empty data", code: 404, userInfo: nil)
                completion(.failure(error))
            }
        })
        task.resume()
    }
    
    
    fileprivate func buildRequest(from route: EndPointType) -> URLRequest {
        
        var request = URLRequest.init(url: URL.init(string: route.baseUrl + route.path)!)
        request.httpMethod = route.httpMethod.rawValue
        switch route.task {
        case .request:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return request
    }
}
