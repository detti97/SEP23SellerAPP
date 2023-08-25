//
//  SettingsManager.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 22.08.23.
//

import Foundation
import SwiftUI


class SettingsManager: ObservableObject {

	@Published var settings: Setting

	init(settings: Setting = Setting(storeName: "", owner: "", address: Address(street: "", houseNumber: "", zip: ""),
									 telephone: "", email: "", logo: "", backgroundImage: "")) {
			self.settings = settings
		}

	func loadData() {
		getSettings { setting in
			DispatchQueue.main.async {
				if let setting = setting {
					self.settings = setting
				} else {
					print("Fehler")
				}
			}
		}
	}

		func setSettings(newSettings: SetSetting){

			NetworkManager.sendPostRequest(to: APIEndpoints.settings, with: newSettings, responseType: Setting.self){ result in
				switch result {
				case .success(let response):
					print("Response: \(response)")
					self.loadData()

				case .failure(let error):
					print("Error: \(error)")

				case .successNoAnswer(_):
					print("Success")
				}
			}
		}

		func setImage(_ image: UIImage?, parameter: String){

			guard let image = image else {
				print("Kein ausgewähltes Bild")
				return
			}

			guard let imageData = image.jpegData(compressionQuality: 0.8) else {
				print("Fehler beim Konvertieren des Bildes in Data")
				return
			}

			NetworkManager.sendPostRequest(to: APIEndpoints.settings, with: SetSetting(parameter: parameter, value: imageData.base64EncodedString()), responseType: Setting.self) { result in
				switch result {
				case .success(let response):
					print("Response: \(response)")

				case .failure(let error):
					print("Error: \(error)")

				case .successNoAnswer(true):
					print("Success")
					self.loadData()

				case .successNoAnswer(false):
					print("Fail - Server")
				}
			}

		}


		func getSettings(completion: @escaping (Setting?) -> Void) {
			NetworkManager.sendGetRequest(to: APIEndpoints.settings, responseType: Setting.self) { result in
				switch result {
				case .success(let response):
					print("Setting: \(response)")
					completion(response)
				case .failure(let error):
					print("Error: \(error)")
					completion(nil)
				case .successNoAnswer(_):
					print("Success")
				}
			}
		}

		func setAddress(address: Address){

			NetworkManager.sendPostRequest(to: APIEndpoints.setAddress, with: SetAddress(address: address), responseType: Setting.self) { result in
				switch result {
				case .success(let response):
					print("Response :\(response)")
					self.loadData()

				case .failure(let error):
					print("Error: \(error)")

				case .successNoAnswer(true):
					print("Success")

				case .successNoAnswer(false):
					print("Fail - Server")
				}
			}
/*
			let apiUrl = URL(string: APIEndpoints.setAddress)!

			// Token
			let token = getSavedToken()!

			// Dein Objekt erstellen
			let yourObject = SetAddress(address: address)

			// URLRequest erstellen
			var request = URLRequest(url: apiUrl)
			request.httpMethod = "POST"
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")

			// Dein Objekt in JSON kodieren
			let encoder = JSONEncoder()
			do {
				let jsonData = try encoder.encode(yourObject)
				request.httpBody = jsonData
			} catch {
				print("Error encoding JSON: \(error)")
				return
			}

			// URLSession-Konfiguration
			let config = URLSessionConfiguration.default
			let session = URLSession(configuration: config)

			// Datenaufgabe
			let task = session.dataTask(with: request) { data, response, error in
				if let error = error {
					print("Error: \(error)")
					return
				}

				guard let data = data else {
					print("No data received")
					return
				}

				do {
					// JSON-Daten in ein Swift-Objekt (z.B. Dictionary) konvertieren
					if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
						// JSON in der Konsole ausgeben
						print(json)
					}
				} catch {
					print("JSON parsing error: \(error)")
				}
			}

			// Anfrage starten
			task.resume()
 */
		}

		func setPassword(oldPassword: String, newPassword: String){

			NetworkManager.sendPostRequest(to: APIEndpoints.setPassword, with: SetPassword(token: getSavedToken()!, oldPassword: oldPassword, newPassword: newPassword), responseType: Setting.self) { result in
				switch result {
				case .success(let response):
					print("Response: \(response)")

				case .failure(let error):
					print("Error: \(error)")

				case .successNoAnswer(true):
					print("Success")

				case .successNoAnswer(false):
					print("Fail - Server")
				}
			}
		}



		func getSavedToken() -> String? {
			return UserDefaults.standard.string(forKey: "AuthToken")
		}

		struct SetPassword: Encodable{

			var token: String
			var oldPassword: String
			var newPassword: String

		}

		struct SetAddress: Encodable{

			//var token: String
			var address: Address

		}

	}

