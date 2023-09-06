//
//  CustomTextFieldStyleView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 24.08.23.
//

import SwiftUI

struct CustomTextFieldStyleView: TextFieldStyle {
	var systemImageName: String

	func _body(configuration: TextField<Self._Label>) -> some View {
		HStack {
			Image(systemName: systemImageName)
				.foregroundColor(.secondary)
			configuration
				.padding(.horizontal, 20)

		}
	}
}

struct CustomTextFieldStyl_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			TextField("Name", text: .constant(""))
				.textFieldStyle(CustomTextFieldStyleView(systemImageName: "person"))

			TextField("Passwort", text: .constant(""))
				.textFieldStyle(CustomTextFieldStyleView(systemImageName: "lock"))

			TextField("Passwort", text: .constant(""))
				.textFieldStyle(CustomTextFieldStyleView(systemImageName: "qrcode"))
		}
		.padding()
		.previewLayout(.sizeThatFits)
	}
}
