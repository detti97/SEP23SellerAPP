//
//  Statistic2View.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 10.08.23.
//

import SwiftUI

import SwiftUI

struct OrderHistoryListView: View {

	@StateObject public var dataManager = DataManager()
	@State private var showErrorAlert = false
	@State private var searchText = ""
	@State private var tryAgainBool = false


	var body: some View {
		NavigationView {

			if dataManager.errorLoading {

				ConnectionErrorView(tryAgainButtonBool: $tryAgainBool)
					.onChange(of: tryAgainBool) { newValue in
						if newValue{
							tryAgainBool = false
							dataManager.setErrorLoading(fail: false)
							dataManager.loadData()

						}
					}

			} else{

				VStack {

					Image("delivery_truck")
						.resizable()
						.scaledToFit()
						.frame(width: 300)

					SearchBar(text: $searchText) // Füge die SearchBar hier hinzu

					List(dataManager.allOrders.filter { order in
						if searchText.isEmpty {
							return true
						} else {
							let searchTextLowercased = searchText.lowercased()
							return order.recipient.firstName.localizedCaseInsensitiveContains(searchTextLowercased) ||
							order.recipient.lastName.localizedCaseInsensitiveContains(searchTextLowercased) ||
							String(order.orderID!).localizedCaseInsensitiveContains(searchTextLowercased)
						}
					}, id: \.orderID) { order in
						NavigationLink(destination: OrderDetailHistoryView(order: order)) {

							HStack{

								Spacer(minLength: 5)
								VStack{
									Image(systemName: "shippingbox.fill")
									Image(systemName: "person")
									Image(systemName: "calendar")

								}
								Spacer(minLength: 5)
								VStack(alignment: .trailing){

									Text("Bestellnummer: \(order.orderID!)")
									Text("Empfänger: \(order.recipient.firstName) \(order.recipient.lastName)")
									Text("Bestelldatum: \(timeStampFormatter(timeStamp:order.timestamp))")

								}
								Spacer(minLength: 5)
								VStack{


								}
								Spacer(minLength: 5)


							}
							.frame(height: 80)

						}
					}
				}
				.onAppear{
					dataManager.loadData()
				}
				.navigationTitle("Alle Bestellungen")
				.navigationBarTitleDisplayMode(.large)

			}
		}
	}
}
private func timeStampFormatter(timeStamp: String) -> String{

	var formattetString = timeStamp.components(separatedBy: ":").first ?? ""

	formattetString = formattetString.replacingOccurrences(of: "-", with: ".")

	return formattetString

}

struct SearchBar: View {
	@Binding var text: String

	var body: some View {
		HStack {
			Image(systemName: "magnifyingglass")
				.foregroundColor(.gray)
			TextField("Suchen", text: $text)
				.textFieldStyle(RoundedBorderTextFieldStyle())
		}
		.padding(.horizontal)
		.padding(.top, 10)
	}
}

struct Statistic2View_Previews: PreviewProvider {
	static var previews: some View {
		OrderHistoryListView()
	}
}
