//
//  LogINView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 27.06.23.
//
import SwiftUI

struct LogInData: Codable {

	let username: String
	let password: String

	}
struct ResponseToken: Codable {

	let token: String
}

struct LogINView: View {

	
	@State private var username = ""
	@State private var password = ""
	@State private var loginFailed = false
	@State private var isActiveLogin = true
	@State private var isActiveCheckout = true
	@State private var selectedDate = Date()
	@State private var extractedExpr: Color = .blue
	@State private var showErrorAlert = false

	@State private var responseToken = ""

	@Binding var signInSuccess: Bool

	var body: some View {


		NavigationView{

			if isActiveLogin{

				VStack
				{
					Image(systemName: "checkmark.seal")
						.font(.system(size: 50))
						.foregroundColor(extractedExpr)
					Spacer()
						.frame(height: 20)

					VStack {
						TextField("Benutzername", text: $username)
							.padding()
							.background(Color.gray.opacity(0.2))
							.cornerRadius(10)

						SecureField("Passwort", text: $password)
							.padding()
							.background(Color.gray.opacity(0.2))
							.cornerRadius(10)

						Spacer()
							.frame(height: 30)

						Button(action: {

							if (self.username == "User1" && self.password == "pass1"){

								self.signInSuccess = true
								print("Login erfolgreich")

                            }
								let test = LogInData(username: username, password: password)
								guard let data = try? JSONEncoder().encode(test) else {
									print("Fehler beim JSON-erstellen")
									return
								}
								print(test)
								guard let url = URL(string: "http://131.173.65.77:8080/auth/login") else {
									return
								}
								var request = URLRequest(url: url)
								request.httpMethod = "POST"
								request.setValue("application/json", forHTTPHeaderField: "Content-Type")
								request.httpBody = data
								let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
									guard let data = data else {
										print("Keine Daten vom Server erhalten.")
										extractedExpr = .red
										return
									}
									do {
										let responseData = try JSONDecoder().decode(ResponseToken.self, from: data)
										let jwtToken = responseData.token
										extractedExpr = .green
										self.signInSuccess = true
										saveToken(jwtToken)

										print("new token: " + getSavedToken()!)

									} catch let error {
										extractedExpr = .red
										responseToken = ""
										print("Fehler beim Parsen des JSON: \(error.localizedDescription)")
										showErrorAlert = true
										self.username = ""
										self.password = ""
									}
								}
								task.resume()

						}){
							Text("Anmelden")
						}
						.alert(isPresented: $showErrorAlert) {
									Alert(title: Text("Fehler"), message: Text("Falsche Log In Daten"), dismissButton: .cancel())
								}
						.padding(20)
						.background(Color.blue)
						.foregroundColor(.white)
						.cornerRadius(40)


						Text(responseToken)
					}
					.padding()
					.onAppear {
									responseToken = getSavedToken() ?? ""
								}
				}
			}

		}
	}
	func decodeToken(test: String){


		let test = ResponseToken(token: test)
		guard let data = try? JSONEncoder().encode(test) else {
			print("Fehler beim JSON-erstellen")
			return
		}
		print(test)
		guard let url = URL(string: "http://131.173.65.77:3000/token-decoder") else {
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
						responseToken = responseString

					}
				} else {
					// Wenn der Statuscode nicht 200 ist, wird eine Fehlermeldung ausgegeben
					print("Fehler beim Empfangen der Antwort vom Server. Statuscode: \(httpResponse.statusCode)")
				}
			}
		task.resume()


	}

	func saveToken(_ token: String) {
		UserDefaults.standard.set(token, forKey: "AuthToken")
	}

	func getSavedToken() -> String? {
		return UserDefaults.standard.string(forKey: "AuthToken")
	}
}

struct LogINView_Previews: PreviewProvider {
	static var previews: some View {
		LogINView(signInSuccess: .constant(false))
	}
}

