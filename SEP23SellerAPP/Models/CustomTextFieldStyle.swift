//
//  CustomTextFieldStyle.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 10.08.23.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
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

struct CustomTextFieldStyle_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			TextField("Name", text: .constant(""))
				.textFieldStyle(CustomTextFieldStyle(systemImageName: "person"))

			TextField("Passwort", text: .constant(""))
				.textFieldStyle(CustomTextFieldStyle(systemImageName: "lock"))

			TextField("Passwort", text: .constant(""))
				.textFieldStyle(CustomTextFieldStyle(systemImageName: "qrcode"))
		}
		.padding()
		.previewLayout(.sizeThatFits)
	}
}
