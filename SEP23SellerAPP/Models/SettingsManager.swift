//
//  SettingsManager.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 22.08.23.
//

import Foundation
import SwiftUI


class SettingsManager: ObservableObject {

	@Published var settings: StoreDetails
	@Published var getSettingsFail = false

	init(settings: StoreDetails = StoreDetails(id: "1", storeName: "", owner: "", address: Address(street: "", houseNumber: "", zip: ""),
											   telephone: "", email: "", logo: "", backgroundImage: "", coordinates: Coordinates(latitude: 1.0, longitude: 1.0))) {
		self.settings = settings
		self.getSettingsFail = getSettingsFail
	}

	func loadData() {

		getSettings { setting in
			DispatchQueue.main.async {
				if let setting = setting {
					self.settings = setting

				} else {

				}
			}
		}

	}

	func setSettings(newSettings: SetSetting){

		NetworkManager.sendPostRequest(to: APIEndpoints.settings, with: newSettings, responseType: ResponseToken.self){ result in
			switch result {
			case .success(let response):
				print("Response: \(response)")
				self.loadData()
				NetworkManager.saveToken(response.token)
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

		NetworkManager.sendPostRequest(to: APIEndpoints.settings, with: SetSetting(parameter: parameter, value: imageData.base64EncodedString()), responseType: StoreDetails.self) { result in
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


	func getSettings(completion: @escaping (StoreDetails?) -> Void) {
		NetworkManager.sendGetRequest(to: APIEndpoints.settings, responseType: StoreDetails.self) { [self] result in
			switch result {
			case .success(let response):
				print("StoreDetails: \(response)")
				completion(response)
			case .failure(let error):
				print("Error: \(error)")
				setFailBool(fail: true)
				completion(nil)
			case .successNoAnswer(_):
				print("Success")
			}
		}
	}

	func setAddress(address: Address){

		NetworkManager.sendPostRequest(to: APIEndpoints.setAddress, with: SetAddress(address: address), responseType: StoreDetails.self) { result in
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

	func setPassword(oldPassword: String, newPassword: String, completion: @escaping (Bool) -> Void) {

		NetworkManager.sendPostRequest(to: APIEndpoints.setPassword, with: SetPassword(token: getSavedToken()!, oldPassword: oldPassword, newPassword: newPassword), responseType: StoreDetails.self) { result in

			var success = false

			switch result {
			case .success(let response):
				print("Response: \(response)")
				success = true

			case .failure(let error):
				print("Error: \(error)")
				success = false

			case .successNoAnswer(true):
				print("Success")
				success = true

			case .successNoAnswer(false):
				print("Fail - Server")
				success = false
			}

			completion(success)
		}
	}


	func setFailBool(fail: Bool){
		self.getSettingsFail = fail
		print("setFailBool \(fail)")
	}

	func getFailBool() -> Bool{
		return getSettingsFail
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

