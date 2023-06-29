//
//  SEP23SellerAPPApp.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 07.04.23.
//

import SwiftUI

@main
struct SEP23SellerAPPApp: App {

	@AppStorage("isDarkMode") private var isDarkMode = false

    var body: some Scene {
        WindowGroup {
            ContentView()
				.preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
