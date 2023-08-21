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
	@State private var showPreview = false
	@State private var address = Address(street: "", houseNumber: "", zip: "")
	@State private var avatarItem: PhotosPickerItem?
	@State private var avatarImage: Image?

	@State var settings = Setting(token: "", storeName: "", owner: "", street: "", houseNumber: "", zip: "", telephone: "", email: "", logo: "", backgroundImage: "https://images.ctfassets.net/uaddx06iwzdz/23fraOkNA2L2nYsNhqQePb/72d26aa66f33cca8b639f4ca4c344474/porsche-911-gt3-touring-front.jpg")
	@Binding var signInSuccess: Bool

	@StateObject public var dataManager = DataManager()

	

	let settingsManager = SettingsManager()

	var body: some View {

		NavigationView{


			VStack{

				VStack{

					ZStack{

						if let url = URL(string: settings.backgroundImage) {
							AsyncImage(url: url) { phase in
								switch phase {
								case .success(let image):
									image.resizable()
										.scaledToFill()
										.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
										.opacity(0.7)
								default:
									Color.clear
								}
							}
							.edgesIgnoringSafeArea(.all)
							.frame(height: 200)
						}

						VStack(alignment: .center){

							HStack{

								AsyncImage(url: URL(string: settings.logo)) { image in
									image.resizable()
								} placeholder: {
									ProgressView()
								}
								.frame(width: 100, height: 100)
								.clipShape(Circle())
								.overlay {
									Circle().stroke(Color.white, lineWidth: 4)
								}
								.shadow(radius: 6)
								.accessibility(identifier: "storeLogo")

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

						}


					}

				}



				//Spacer(minLength: 10)

				Form {
					Section(header: Text("Geschäftsinformationen")) {
						Button(action: {
							showEditAddress = true
							address = Address(street: settings.street, houseNumber: settings.houseNumber, zip: settings.zip)

						}) {
							Text("Adresse bearbeiten")
						}
						.sheet(isPresented: $showEditAddress) {
							EditAddressView(address: $address)
						}


						Button(action: {
							showEditPhoneNumber = true
						}) {
							Text("Telefonnummer bearbeiten")
						}
						.sheet(isPresented: $showEditPhoneNumber) {
							EditPhoneNumberView(phoneNumber: $settings.telephone)
						}

						Button(action: {
							showEditEmail = true
						}) {
							Text("E-Mail ändern")
						}
						.sheet(isPresented: $showEditEmail) {
							EditEmailView(email: $settings.email)

						}
						Button(action: {
							showEditOwner = true
						}) {
							Text("Inhaber ändern")
						}
						.sheet(isPresented: $showEditOwner) {
							EditOwnerView(owner: $settings.owner)
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

					Section {
						Button(action: {
							showPreview = true
						}) {
							Text("Vorschau anzeigen")
								.foregroundColor(.green)
						}
						.sheet(isPresented: $showPreview) {
							StoreDetailPreviewView(showPreview: $showPreview, store: settings)
						}

					}
					.navigationBarTitle("Einstellungen")
					.navigationBarTitleDisplayMode(.inline)
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

		}

	}

func newStore(_ image: UIImage?) {

	struct sendImage: Codable{

		var token: String
		var parameter: String
		var value: String

	}

	guard let image = image else {
		print("Kein ausgewähltes Bild")
		return
	}

	guard let imageData = image.jpegData(compressionQuality: 0.8) else {
		print("Fehler beim Konvertieren des Bildes in Data")
		return
	}

	let sendNewImage = sendImage(token: getSavedToken()!, parameter: "backgroundImage", value: imageData.base64EncodedString())


	guard let data = try? JSONEncoder().encode(sendNewImage) else {
		print("Fehler beim JSON-erstellen")
		return
	}
	//print(store)
	guard let url = URL(string: "http://131.173.65.77:8080/api/setSettings") else {
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
		print("Response data:", String(data: data! , encoding: .utf8) ?? "")
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

	func setSettings(newSettings: SetSetting){

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
				completion(response)
			case .failure(let error):
				print("Error: \(error)")
				completion(nil)
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
	@Binding var email: String
	@Environment(\.presentationMode) private var presentationMode

	var body: some View {
		NavigationView {
			Form {
				TextField("Email", text: $email)
			}
			.navigationBarTitle("Email bearbeiten")
			.navigationBarItems(leading: cancelButton, trailing: saveButton)
		}
	}

	private var saveButton: some View {
		Button(action: {
			let settingsManager = SettingsManager()
			settingsManager.setSettings(newSettings: SetSetting(token: "", parameter: SetSetting.Parameters.email, value: email))
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
	@Binding var owner: String
	@Environment(\.presentationMode) private var presentationMode

	var body: some View {
		NavigationView {
			Form {
				TextField("Verantwortliche", text: $owner)
			}
			.navigationBarTitle("Verantwortliche bearbeiten")
			.navigationBarItems(leading: cancelButton, trailing: saveButton)
		}
	}

	private var saveButton: some View {
		Button(action: {
			let settingsManager = SettingsManager()
			settingsManager.setSettings(newSettings: SetSetting(token: "", parameter: SetSetting.Parameters.owner, value: owner))
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

	@Binding var address: Address
	@Environment(\.presentationMode) private var presentationMode

	var body: some View {
		NavigationView {
			Form {
				TextField("Adresse", text: $address.street)
				TextField("Hausnummer", text: $address.houseNumber)
				Picker("Postleitzahl", selection: $address.zip) {
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
			settingsManager.setSettings(newSettings: SetSetting(token: "", parameter: SetSetting.Parameters.street, value: address.street))
			settingsManager.setSettings(newSettings: SetSetting(token: "", parameter: SetSetting.Parameters.houseNumber, value: address.houseNumber))
			settingsManager.setSettings(newSettings: SetSetting(token: "", parameter: SetSetting.Parameters.zip, value: address.zip))
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
			settingsManager.setSettings(newSettings: SetSetting(token: "", parameter: SetSetting.Parameters.telephone, value: phoneNumber))
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
