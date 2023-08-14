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
	
	@State private var responseToken = ""
	@State private var loginData = LoginData(username: "", password: "")
	
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
							
							loginData.username = username
							loginData.password = password
							
							NetworkManager.sendPostRequest(to: APIEndpoints.login, with: loginData, responseType: ResponseToken.self){ result in
								switch result {
								case .success(let response):
									print("Token: \(response.token)")
									saveToken(response.token)
								case .failure(let error):
									print("Error: \(error)")
								}
							}
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
	
	func saveToken(_ token: String) {
		UserDefaults.standard.set(token, forKey: "AuthToken")
	}
	
	func getSavedToken() -> String? {
		return UserDefaults.standard.string(forKey: "AuthToken")
	}
	
	func sendLoginData(){
		
		let test = LoginData(username: username, password: password)
		
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
		
	}
}

struct LogINView_Previews: PreviewProvider {
	static var previews: some View {
		LogINView(signInSuccess: .constant(false))
	}
}

