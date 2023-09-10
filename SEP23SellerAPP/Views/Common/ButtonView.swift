//
//  ButtonView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 07.09.23.
//

import SwiftUI

struct ButtonView: View {

	var buttonText: String
	var buttonColor: Color

    var body: some View {

		Text(buttonText)
			.padding()
			.foregroundColor(.white)
			.fontWeight(.heavy)
			.background(buttonColor)
			.cornerRadius(16)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
		ButtonView(buttonText: "Abbrechen", buttonColor: .purple)
    }
}
