import SwiftUI
import PhotosUI


struct token: Encodable {

	var token: String
}

struct SettingView: View {

	@StateObject public var settingsManager = SettingsManager()
	@Binding var signInSuccess: Bool

	@State private var showEditAddress = false
	@State private var showEditOpeningHours = false
	@State private var showEditPhoneNumber = false
	@State private var showEditEmail = false
	@State private var showEditOwner = false
	@State private var showPreview = false
	@State private var showEditPassword = false
	@State private var tryAgainBool = false
	@State private var address = Address(street: "", houseNumber: "", zip: "")
	@State private var backgroundPickerItem: PhotosPickerItem?

	@State public var networkManager = NetworkManager()
	@State private var logoPickerItem: PhotosPickerItem?
	@State private var logoImage: Image?

	var body: some View {

		NavigationView{

			if settingsManager.getSettingsFail{

				ConnectionErrorView(tryAgainButtonBool: $tryAgainBool)
					.onChange(of: tryAgainBool) { newValue in
						if newValue{
							tryAgainBool = false
							settingsManager.setFailBool(fail: false)
							settingsManager.loadData()

						}
					}

			}else {

				VStack{

					VStack{

						ZStack{

							if let url = URL(string: settingsManager.settings.backgroundImage) {
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
								.frame(height: 180)
							}



							VStack(alignment: .center){

								HStack{

									VStack{

										AsyncImage(url: URL(string: settingsManager.settings.logo)) { image in
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
									}
									.onTapGesture {


									}
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
											Text(settingsManager.settings.owner)
											Text("\(settingsManager.settings.address.street) \(settingsManager.settings.address.houseNumber)")
											Text(settingsManager.settings.telephone)
											Text(settingsManager.settings.email)
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

					Form {
						Section(header: Text("Geschäftsinformationen")) {

							Button(action: {
								showEditPhoneNumber = true
							}) {
								Text("Telefonnummer bearbeiten")
							}
							.sheet(isPresented: $showEditPhoneNumber) {
								EditPhoneNumberView(phoneNumber: $settingsManager.settings.telephone)
									.environmentObject(settingsManager)
							}

							Button(action: {
								showEditEmail = true
							}) {
								Text("E-Mail ändern")
							}
							.sheet(isPresented: $showEditEmail) {
								EditEmailView(email: $settingsManager.settings.email)
									.environmentObject(settingsManager)
							}
							Button(action: {
								showEditOwner = true
							}) {
								Text("Inhaber ändern")
							}
							.sheet(isPresented: $showEditOwner) {
								EditOwnerView(owner: $settingsManager.settings.owner)
									.environmentObject(settingsManager)
							}
							Button(action: {
								showEditAddress = true
							}) {
								Text("Adresse bearbeiten")
							}
							.sheet(isPresented: $showEditAddress) {
								EditAddressView(address: $settingsManager.settings.address)
									.environmentObject(settingsManager)
							}
							Button(action: {
								showEditPassword = true
							}) {
								Text("Passwort ändern")
							}
							.sheet(isPresented: $showEditPassword) {
								EditPasswordView()
									.environmentObject(settingsManager)
							}
						}
						Section(header: Text("Bilder ändern")) {
							VStack {
								PhotosPicker("Hintergrund ändern", selection: $backgroundPickerItem, matching: .images)
							}
							.onChange(of: backgroundPickerItem) { _ in
								Task {
									if let data = try? await backgroundPickerItem?.loadTransferable(type: Data.self) {
										if let uiImage = UIImage(data: data) {
											settingsManager.setImage(uiImage, parameter: SetSetting.Parameters.backgroundImage)
											return
										}
									}

									print("Failed")
								}
							}

							VStack {
								PhotosPicker("Logo ändern", selection: $logoPickerItem, matching: .images)
							}
							.onChange(of: logoPickerItem) { _ in
								Task {
									if let data = try? await logoPickerItem?.loadTransferable(type: Data.self) {
										if let uiImage = UIImage(data: data) {
											settingsManager.setImage(uiImage, parameter: SetSetting.Parameters.logo)
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
							Button(action: {
								showPreview = true
							}) {
								Text("Vorschau anzeigen")
									.foregroundColor(.green)
							}
							.sheet(isPresented: $showPreview) {
								StoreDetailPreviewView(showPreview: $showPreview, store: settingsManager.settings)
							}
						}
						.navigationBarTitle("Einstellungen")
						.navigationBarTitleDisplayMode(.inline)
						.onAppear{
								settingsManager.loadData()

						}
					}
				}
			}
		}
	}



	private func signOut() {
		UserDefaults.standard.removeObject(forKey: "AuthToken")
		signInSuccess = false
	}

	struct EditEmailView: View {
		@Binding var email: String
		@Environment(\.presentationMode) private var presentationMode
		@EnvironmentObject private var settingsManager: SettingsManager

		var body: some View {
			NavigationView {
				Form {
					TextField("Email", text: $email)
				}
				.navigationBarTitle("Email bearbeiten")
				.navigationBarItems(leading: cancelButton, trailing: saveButton)
			}
			.disabled(email.isEmpty == true)
		}

		private var saveButton: some View {
			Button(action: {
				settingsManager.setSettings(newSettings: SetSetting(parameter: SetSetting.Parameters.email, value: email))
				//settingsManager.loadData()
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
		@EnvironmentObject private var settingsManager: SettingsManager

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
				settingsManager.setSettings(newSettings: SetSetting(parameter: SetSetting.Parameters.owner, value: owner))
				presentationMode.wrappedValue.dismiss()
			}) {
				Text("Speichern")
			}
			.disabled(owner.isEmpty == true)
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
		@EnvironmentObject private var settingsManager: SettingsManager

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
				settingsManager.setAddress(address: address)
				presentationMode.wrappedValue.dismiss()
			}) {
				Text("Speichern")
			}
			.disabled(address.street.isEmpty == true || address.houseNumber.isEmpty == true)
			
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
		@EnvironmentObject private var settingsManager: SettingsManager

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
				settingsManager.setSettings(newSettings: SetSetting(parameter: SetSetting.Parameters.telephone, value: phoneNumber))
				presentationMode.wrappedValue.dismiss()
			}) {
				Text("Speichern")
			}
			.disabled(phoneNumber.isEmpty == true)
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

	struct EditPasswordView: View {
		@Environment(\.presentationMode) private var presentationMode
		@EnvironmentObject private var settingsManager: SettingsManager
		@State var oldPassword = ""
		@State var newPassword = ""

		var body: some View {
			NavigationView {
				Form {
					TextField("Altes Passwort", text: $oldPassword)
					TextField("Neues Passwort", text: $newPassword)
				}
				.navigationBarTitle("Passwort ändern")
				.navigationBarItems(leading: cancelButton, trailing: saveButton)
			}
		}

		private var saveButton: some View {
			Button(action: {
				settingsManager.setPassword(oldPassword: oldPassword, newPassword: newPassword)
				presentationMode.wrappedValue.dismiss()
			}) {
				Text("Speichern")
			}
			.disabled(oldPassword.isEmpty == true)
			.disabled(newPassword.isEmpty == true)
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
}
