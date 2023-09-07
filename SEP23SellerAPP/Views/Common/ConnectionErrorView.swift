//
//  ConnectionErrorView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 02.09.23.
//

import SwiftUI

struct ConnectionErrorView: View {

	@Binding var tryAgainButtonBool: Bool
	@State private var isLoading = false


	var body: some View {

		VStack{

			Image("error")
				.resizable()
				.frame(height: 240)

			Text("Fehler bei der Kommunikation mit dem Server!")
				.font(.largeTitle)
				.fontWeight(.heavy)
				.padding()
				.multilineTextAlignment(.center)
				.foregroundColor(.red)

			Spacer()
				.frame(height: 20)

			Button(action: {
				isLoading = true
				//tryAgainButtonBool = true

			}) {
				if isLoading{

					ProgressView("Laden...")
								   .onAppear {
									   DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
										   tryAgainButtonBool = true
										   isLoading = false
									   }
								   }
								   .padding()
								   .foregroundColor(.white)
								   .fontWeight(.heavy)
								   .background(Color.blue)
								   .cornerRadius(8)

				} else{
					Text("Erneut Versuchen")
						.padding()
						.foregroundColor(.white)
						.fontWeight(.heavy)
						.background(Color.blue)
						.cornerRadius(8)
				}
			}
			.padding()
			.frame(maxWidth: .infinity, alignment: .center)
		}
	}
}

struct ConnectionErrorView_Previews: PreviewProvider {
    static var previews: some View {
		ConnectionErrorView(tryAgainButtonBool: Binding.constant(false))
    }
}
