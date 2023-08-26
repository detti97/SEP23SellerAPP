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
	static let settings = "http://131.173.65.77:8080/api/settings"
	static let setAddress = "http://131.173.65.77:8080/api/setAddress"
	static let setPassword = "http://131.173.65.77:8080/auth/updatePassword"
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

		print("Send data:", String(data: requestData, encoding: .utf8) ?? "")
		var request = URLRequest(url: url)
		request.httpMethod = "POST"

		if endpoint != APIEndpoints.login{

			guard let token = getSavedToken() else {
				completion(.failure(NSError(domain: "No Token", code: -1, userInfo: nil)))
				return
			}

			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = requestData

		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let error = error {
				completion(.failure(error))
				return
			}

			if let httpResponse = response as? HTTPURLResponse {

				if endpoint == APIEndpoints.setAddress || endpoint == APIEndpoints.setPassword {

					let responseCode = httpResponse.statusCode

					if responseCode == 200{

						print("server response: \(responseCode)")
						completion(.successNoAnswer(true))

					}else {
						print("server response: \(responseCode)")
						completion(.successNoAnswer(false))

					}

				} else {
					guard let responseData = data else {
						completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
						return
					}
					print("Response data:", String(data: responseData, encoding: .utf8) ?? "")

					do {
						let decodedResponse = try JSONDecoder().decode(U.self, from: responseData)
						completion(.success(decodedResponse))
					} catch {
						completion(.failure(error))
					}
				}
			} else {
				completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
			}
		}

		task.resume()

	}

	static func sendGetRequest<T: Decodable>(to endpoint: String, responseType: T.Type, completion: @escaping (RequestResult<T>) -> Void) {

			guard let token = getSavedToken() else {
				completion(.failure(NSError(domain: "No Token", code: -1, userInfo: nil)))
				return
			}

			guard let url = URL(string: endpoint) else {
				completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
				return
			}

			var request = URLRequest(url: url)
			request.httpMethod = "GET"
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

			let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
				if let error = error {
					completion(.failure(error))
					return
				}

				if response is HTTPURLResponse {
					guard let responseData = data else {
						completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
						return
					}
					print("Response JSON:", String(data: responseData, encoding: .utf8) ?? "")
					do {
						let decodedResponse = try JSONDecoder().decode(T.self, from: responseData)
						completion(.success(decodedResponse))
					} catch {
						completion(.failure(error))
					}
				} else {
					completion(.failure(NSError(domain: "Invalid response", code: -1, userInfo: nil)))
				}
			}

			task.resume()
		}

	static func getSavedToken() -> String? {
		return UserDefaults.standard.string(forKey: "AuthToken")
	}

	static func saveToken(_ token: String) {
		UserDefaults.standard.set(token, forKey: "AuthToken")
	}

	static func sendPostRequest<T: Encodable, U: Decodable>(to endpoint: String, with data: T, responseType: U.Type, completion: @escaping (RequestResult<U>) -> Void) {
		sendPostRequestInternal(to: endpoint, with: data, responseType: responseType, completion: completion)
	}

	static func sendPostRequestWithArrayResponse<T: Encodable, U: Decodable>(to endpoint: String, with data: T, responseType: [U].Type, completion: @escaping (RequestResult<[U]>) -> Void) {
		sendPostRequestInternal(to: endpoint, with: data, responseType: responseType, completion: completion)
	}

	static func sendGetRequestWithArrayResponse<U: Decodable>(to endpoint: String, responseType: [U].Type, completion: @escaping (RequestResult<[U]>) -> Void) {
		sendGetRequest(to: endpoint, responseType: responseType, completion: completion)
	}
}

