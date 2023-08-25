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

	init(settings: Setting = Setting(token: "", storeName: "", owner: "", address: Address(street: "", houseNumber: "", zip: ""),
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

			var changedSettings = newSettings
			changedSettings.token = getSavedToken()!

			NetworkManager.sendPostRequest(to: APIEndpoints.setSettings, with: changedSettings, responseType: Setting.self){ result in
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

			NetworkManager.sendPostRequest(to: APIEndpoints.setSettings, with: SetSetting(token: getSavedToken()!, parameter: parameter, value: imageData.base64EncodedString()), responseType: Setting.self) { result in
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
			NetworkManager.sendPostRequest(to: APIEndpoints.getSettings, with: token(token: getSavedToken()!), responseType: Setting.self) { result in
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

			NetworkManager.sendPostRequest(to: APIEndpoints.setAddress, with: SetAddress(token: getSavedToken()!, address: address), responseType: Setting.self) { result in
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

			var token: String
			var address: Address

		}

	}
