//
//  API.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 13.08.23.
//

import Foundation

enum RequestResult<T> {
	case success(T)
	case failure(Error)
	case successNoAnswer(Bool)
}

enum APIEndpoints {
	static let login = "http://131.173.65.77:8080/auth/login"
	static let order = "http://131.173.65.77:8080/api/order"
	static let placedOrders = "http://131.173.65.77:8080/api/allOrders"
	static let getSettings = "http://131.173.65.77:8080/api/getSettings"
	static let setSettings = "http://131.173.65.77:8080/api/setSettings"
}

class NetworkManager {
	private static func sendPostRequestInternal<T: Encodable, U: Decodable>(to endpoint: String, with data: T, responseType: U.Type, completion: @escaping (RequestResult<U>) -> Void) {
		guard let url = URL(string: endpoint) else {
			completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
			return
		}

		guard let requestData = try? JSONEncoder().encode(data) else {
			completion(.failure(NSError(domain: "JSON encoding error", code: -1, userInfo: nil)))
			return
		}

		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = requestData

		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let error = error {
				completion(.failure(error))
				return
			}

			if endpoint == APIEndpoints.setSettings {

				completion(.successNoAnswer(true))

			}else{

				guard let responseData = data else {
					completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
					return
				}
				print(responseData)

				do {
					let decodedResponse = try JSONDecoder().decode(U.self, from: responseData)
					completion(.success(decodedResponse))
				} catch {
					completion(.failure(error))
				}

			}


		}

		task.resume()
	}

	static func sendPostRequest<T: Encodable, U: Decodable>(to endpoint: String, with data: T, responseType: U.Type, completion: @escaping (RequestResult<U>) -> Void) {
		sendPostRequestInternal(to: endpoint, with: data, responseType: responseType, completion: completion)
	}

	static func sendPostRequestWithArrayResponse<T: Encodable, U: Decodable>(to endpoint: String, with data: T, responseType: [U].Type, completion: @escaping (RequestResult<[U]>) -> Void) {
		sendPostRequestInternal(to: endpoint, with: data, responseType: responseType, completion: completion)
	}
}

