//
//  LogINView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 27.06.23.
//
import SwiftUI


struct LogINView: View {

	
	@State private var username = ""
	@State private var password = ""
	@State private var loginFailed = false
	@State private var isActiveLogin = true
	@State private var isActiveCheckout = true
	@State private var selectedDate = Date()
	@State private var extractedExpr: Color = .blue
	@State private var showErrorAlert = false
	@State private var emptyFields = false

	@State private var responseToken = ""
	@Binding var signInSuccess: Bool

	var body: some View {


		NavigationView{

			if isActiveLogin{

				VStack {

					ZStack {

						Image("wallpaper")
							.resizable()
							.ignoresSafeArea(.all)


						Spacer()
							.frame(height: 20)

						VStack {

							Image("logo")
								.resizable()
								.scaledToFit()
								.frame(height: 140)
								.padding(5)


							Spacer()
								.frame(height: 20)


							/*Image(systemName: "checkmark.seal")
							 .font(.system(size: 50))
							 .foregroundColor(extractedExpr)
							 Spacer()
							 .frame(height: 20)
							 */


							VStack {
								TextField("Benutzername", text: $username)
									.padding()
									.background(Color.gray.opacity(0.2))
									.cornerRadius(20)
									.textFieldStyle(CustomTextFieldStyle(systemImageName: "person"))
									.fontWeight(.bold)
									.overlay(RoundedRectangle(cornerRadius: 20)
										.stroke(emptyFields ? Color.red : Color.accentColor, lineWidth: 3)
									)
									.onTapGesture {
										emptyFields = false
									}

								SecureField("Passwort", text: $password)
									.padding()
									.background(Color.gray.opacity(0.2))
									.cornerRadius(20)
									.textFieldStyle(CustomTextFieldStyle(systemImageName: "lock"))
									.fontWeight(.bold)
									.overlay(RoundedRectangle(cornerRadius: 20)
										.stroke(emptyFields ? Color.red : Color.accentColor, lineWidth: 3)
									)
									.onTapGesture {
										emptyFields = false
									}

								Spacer()
									.frame(height: 30)

								Button(action: {

									sendLoginData(loginData: LoginData(username: username, password: password))

								}){
									Text("Anmelden")
								}
								.disabled(username.isEmpty || password.isEmpty)
								.alert(isPresented: $showErrorAlert) {
									Alert(title: Text("Fehler"), message: Text("Falsche Log In Daten"), dismissButton: .cancel())
								}
								.padding(20)
								.background(Color.accentColor)
								.foregroundColor(.white)
								.fontWeight(.bold)
								.cornerRadius(20)
								.onTapGesture {
									if username.isEmpty || password.isEmpty {

										emptyFields = true

									}
								}

							}
							.padding()
							.onAppear {

								if getSavedToken() != nil {

									signInSuccess = true

								}
							}
						}
						.background(.ultraThinMaterial)
						.cornerRadius(20)
						.padding(25)

					}

				}
				
			}

		}
	}

	func saveToken(_ token: String) {
		UserDefaults.standard.set(token, forKey: "AuthToken")
	}

	func getSavedToken() -> String? {
		return UserDefaults.standard.string(forKey: "AuthToken")
	}

	func sendLoginData(loginData: LoginData){

		NetworkManager.sendPostRequest(to: APIEndpoints.login, with: loginData, responseType: ResponseToken.self){ result in
			switch result {
			case .success(let response):
				print("Token: \(response.token)")
				saveToken(response.token)
				extractedExpr = .green
				self.signInSuccess = true
			case .failure(let error):
				extractedExpr = .red
				showErrorAlert = true
				print("Error: \(error)")
			case .successNoAnswer(_):
				print("Success")
			}

		}

	}
}

struct LogINView_Previews: PreviewProvider {
	static var previews: some View {
		LogINView(signInSuccess: .constant(false))
	}
}

