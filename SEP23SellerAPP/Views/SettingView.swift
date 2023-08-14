import SwiftUI
import PhotosUI


struct token: Encodable {

	var token: String
}

struct SettingView: View {

	@AppStorage("isDarkMode") private var isDarkMode = false
	@State private var showEditAddress = false
	@State private var showEditOpeningHours = false
	@State private var showEditPhoneNumber = false
	@State private var showEditEmail = false
	@State private var showEditOwner = false

	@State private var avatarItem: PhotosPickerItem?
	@State private var avatarImage: Image?

	@State var settings = Setting(token: "", storeName: "", owner: "", street: "", houseNumber: "", zip: "", telephone: "", email: "")

	@Binding var signInSuccess: Bool

	@StateObject public var dataManager = DataManager()

	let settingsManager = SettingsManager()

	var body: some View {

		NavigationView{


			VStack{

				VStack(alignment: .center){

					HStack{

						VStack{
							Image(systemName: "person")
								.font(.headline)
							Image(systemName: "house")
								.font(.headline)
							Image(systemName: "phone")
								.font(.headline)
							Image(systemName: "envelope")
								.font(.headline)

						}

						VStack{
							Text(settings.owner)
							Text("\(settings.street) \(settings.houseNumber)")
							Text(settings.telephone)
							Text(settings.email)
						}

					}
					.padding()
					.background()
					.cornerRadius(10)
					.shadow(radius: 6)

				}


				//Spacer(minLength: 10)

				Form {
					Section(header: Text("Geschäftsinformationen")) {
						Button(action: {
							showEditAddress = true
						}) {
							Text("Adresse bearbeiten")
						}
						.sheet(isPresented: $showEditAddress) {
							EditAddressView(address: $settings.street, homeNumber: $settings.houseNumber, zipCode: $settings.zip, newSettings: $settings)
						}


						Button(action: {
							showEditPhoneNumber = true
						}) {
							Text("Telefonnummer bearbeiten")
						}
						.sheet(isPresented: $showEditPhoneNumber) {
							EditPhoneNumberView(phoneNumber: $settings.telephone, newSettings: $settings)
						}

						Button(action: {
							showEditEmail = true
						}) {
							Text("E-Mail ändern")
						}
						.sheet(isPresented: $showEditEmail) {
							EditEmailView(Email: $settings.email, newSettings: $settings)

						}
						Button(action: {
							showEditOwner = true
						}) {
							Text("Inhaber ändern")
						}
						.sheet(isPresented: $showEditOwner) {
							EditOwnerView(Owner: $settings.owner, newSettings: $settings)
						}
						VStack {
							PhotosPicker("Select Picture", selection: $avatarItem, matching: .images)
						}
						.onChange(of: avatarItem) { _ in
							Task {
								if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
									if let uiImage = UIImage(data: data) {
										avatarImage = Image(uiImage: uiImage)
										newStore(uiImage)
										return
									}
								}

								print("Failed")
							}
						}
					}

					Section {
						Button(action: {
							signOut()
						}) {
							Text("Abmelden")
								.foregroundColor(.red)
						}

					}

					Section(header: Text("Einstellungen")) {
						Toggle(isOn: $isDarkMode) {
							Text("Dark Mode")
						}
					}
					.navigationBarTitle("Einstellungen")
					.onAppear{
						//getSettings()
						if(getSavedToken() == nil){
							print("no token")
						}
						settingsManager.getSettings { setting in
							if let setting = setting {
								self.settings = setting
							} else {
								print("Fehler")
							}
						}

					}
				}
			}

			.background(
				AsyncImage(url: URL(string: "https://wallpapers.com/wp-content/themes/wallpapers.com/src/splash-n.jpg")) { image in
					image.resizable()
						.aspectRatio(contentMode: .fill)
						.edgesIgnoringSafeArea(.all)
						.opacity(0.7)
				} placeholder: {
					Color.clear
				})
		}

	}

	func newStore(_ image: UIImage?) {

		struct newStore: Codable{

			var storeName: String
			var username: String
			var password: String
			var owner: String
			var street: String
			var houseNumber: String
			var zip: String
			var telephone: String
			var email: String
			var logo: String

		}

		guard let image = image else {
			print("Kein ausgewähltes Bild")
			return
		}

		guard let imageData = image.jpegData(compressionQuality: 0.8) else {
			print("Fehler beim Konvertieren des Bildes in Data")
			return
		}

		let store = newStore(storeName: "Bild", username: "Test1234561231", password: "BK", owner: "Ronald McDonald", street: "Zum Heidhof", houseNumber: "22", zip: "49809", telephone: "1234098", email: "MCD@BK.de", logo: imageData.base64EncodedString())


		guard let data = try? JSONEncoder().encode(store) else {
			print("Fehler beim JSON-erstellen")
			return
		}
		//print(store)
		guard let url = URL(string: "http://131.173.65.77:8080/auth/register") else {
			return
		}
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = data
		let task = URLSession.shared.dataTask(with: request){ data, response, error in
			if let error = error {
				// Wenn ein Fehler aufgetreten ist, wird er in der Konsole ausgegeben
				print("Fehler beim Senden der Anfrage: \(error.localizedDescription)")
				return
			}
			guard let data = data else {
				// Wenn keine Daten zurückgegeben wurden, wird eine Fehlermeldung ausgegeben
				print("Keine Daten vom Server erhalten.")
				return
			}
			guard let httpResponse = response as? HTTPURLResponse else {
				// Wenn die Antwort keine HTTP-Antwort ist, wird eine Fehlermeldung ausgegeben
				print("Keine HTTP-Antwort vom Server erhalten.")
				return
			}
			if httpResponse.statusCode == 200 {
				// Wenn der Statuscode 200 ist, wird die Antwort des Servers in der Konsole ausgegeben
				if let responseString = String(data: data, encoding: .utf8) {
					print("Antwort des Servers: \(responseString)")
				}
			} else {
				// Wenn der Statuscode nicht 200 ist, wird eine Fehlermeldung ausgegeben
				print("Fehler beim Empfangen der Antwort vom Server. Statuscode: \(httpResponse.statusCode)")
			}
		}
		task.resume()

	}

	private func signOut() {

		signInSuccess = false
		UserDefaults.standard.removeObject(forKey: "AuthToken")
	}

	func getSavedToken() -> String? {
		return UserDefaults.standard.string(forKey: "AuthToken")
	}

}

struct SettingsManager{

	func setSettings(newSettings: Setting){

		var changedSettings = newSettings
		changedSettings.token = getSavedToken()!

		NetworkManager.sendPostRequest(to: APIEndpoints.setSettings, with: changedSettings, responseType: Setting.self){ result in
			switch result {
			case .success(let response):
				print("Token: \(response)")

			case .failure(let error):
				print("Error: \(error)")

			case .successNoAnswer(_):
				print("Success")
			}
		}
	}

	func getSettings(completion: @escaping (Setting?) -> Void) {
		NetworkManager.sendPostRequest(to: APIEndpoints.getSettings, with: token(token: getSavedToken()!), responseType: Setting.self) { result in
			switch result {
			case .success(let response):
				print("Token: \(response)")
				completion(response) // Die Antwort übergeben
			case .failure(let error):
				print("Error: \(error)")
				completion(nil) // Bei einem Fehler nil zurückgeben
			case .successNoAnswer(_):
				print("Success")
			}
		}
	}


	func getSavedToken() -> String? {
		return UserDefaults.standard.string(forKey: "AuthToken")
	}

}


struct EditEmailView: View {
	@Binding var Email: String
	@Binding var newSettings: Setting
	@Environment(\.presentationMode) private var presentationMode

	var body: some View {
		NavigationView {
			Form {
				TextField("Email", text: $Email)
			}
			.navigationBarTitle("Email bearbeiten")
			.navigationBarItems(leading: cancelButton, trailing: saveButton)
		}
	}

	private var saveButton: some View {
		Button(action: {
			let settingsManager = SettingsManager()
			settingsManager.setSettings(newSettings: newSettings)
			presentationMode.wrappedValue.dismiss()
		}) {
			Text("Speichern")
		}
	}

	private var cancelButton: some View {
		Button(action: {
			// Schließe die Ansicht und kehre zum Einstellungsmenü zurück
			presentationMode.wrappedValue.dismiss()
		}) {
			Text("Zurück")
		}
	}
}

struct EditOwnerView: View {
	@Binding var Owner: String
	@Binding var newSettings: Setting
	@Environment(\.presentationMode) private var presentationMode

	var body: some View {
		NavigationView {
			Form {
				TextField("Verantwortliche", text: $Owner)
			}
			.navigationBarTitle("Verantwortliche bearbeiten")
			.navigationBarItems(leading: cancelButton, trailing: saveButton)
		}
	}

	private var saveButton: some View {
		Button(action: {
			let settingsManager = SettingsManager()
			settingsManager.setSettings(newSettings: newSettings)
			presentationMode.wrappedValue.dismiss()
		}) {
			Text("Speichern")
		}
	}

	private var cancelButton: some View {
		Button(action: {
			// Schließe die Ansicht und kehre zum Einstellungsmenü zurück
			presentationMode.wrappedValue.dismiss()
		}) {
			Text("Zurück")
		}
	}
}

struct EditAddressView: View {

	let zipCodes = ["49808", "49809" , "49811"]

	@Binding var address: String
	@Binding var homeNumber: String
	@Binding var zipCode: String
	@Binding var newSettings: Setting
	@Environment(\.presentationMode) private var presentationMode

	var body: some View {
		NavigationView {
			Form {
				TextField("Adresse", text: $address)
				TextField("Hausnummer", text: $homeNumber)
				TextField("PLZ", text: $zipCode)
				Picker("Postleitzahl", selection: $zipCode) {
					ForEach(zipCodes, id: \.self) { plz in
						Text(plz)
					}
				}
				.pickerStyle(SegmentedPickerStyle())
			}
			.navigationBarTitle("Adresse bearbeiten")
			.navigationBarItems(leading: cancelButton, trailing: saveButton)
		}
	}

	private var saveButton: some View {
		Button(action: {
			let settingsManager = SettingsManager()
			settingsManager.setSettings(newSettings: newSettings)
			presentationMode.wrappedValue.dismiss()
		}) {
			Text("Speichern")
		}
	}

	private var cancelButton: some View {
		Button(action: {
			// Schließe die Ansicht und kehre zum Einstellungsmenü zurück
			presentationMode.wrappedValue.dismiss()
		}) {
			Text("Zurück")
		}
	}
}

struct EditPhoneNumberView: View {
	@Binding var phoneNumber: String
	@Binding var newSettings: Setting
	@Environment(\.presentationMode) private var presentationMode

	var body: some View {
		NavigationView {
			Form {
				TextField("Telefonnummer", text: $phoneNumber)
			}
			.navigationBarTitle("Telefonnummer bearbeiten")
			.navigationBarItems(leading: cancelButton, trailing: saveButton)
		}
	}

	private var saveButton: some View {
		Button(action: {
			let settingsManager = SettingsManager()
			settingsManager.setSettings(newSettings: newSettings)
			presentationMode.wrappedValue.dismiss()
		}) {
			Text("Speichern")
		}
	}

	private var cancelButton: some View {
		Button(action: {
			// Schließe die Ansicht und kehre zum Einstellungsmenü zurück
			presentationMode.wrappedValue.dismiss()
		}) {
			Text("Zurück")
		}
	}

}

struct SettingView_Previews: PreviewProvider {
	static var previews: some View {
		SettingView(signInSuccess: .constant(true))
	}
}
