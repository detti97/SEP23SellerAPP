//
//  CodeScannerSheetView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 02.09.23.
//

import SwiftUI
import CodeScanner

struct CodeScannerSheetView: View {

	@Binding var isShowingScanner: Bool
	@Binding var showShippingView: Bool
	@Binding var order: Order
	@State var scanFail = false


    var body: some View {
		ZStack(alignment: .bottom) {
			CodeScannerView(codeTypes: [.qr], showViewfinder: true, simulatedData: "Steve&Jobs&Bernd-Rosemeyer-Straße&40&49808", completion: handleScan)
				.ignoresSafeArea(.all)

			Button(action: {
				order = Order.defaultOrder()
				isShowingScanner = false
			}) {
				ButtonView(buttonText: "Abbrechen", buttonColor: .red)
			}
			.alert(isPresented: $scanFail) {
				Alert(
					title: Text("Fehler beim Scannen"),
					message: Text("Falsches QR-Code-Format"),
					dismissButton: .default(Text("OK"), action: {
						isShowingScanner = false
					}))
			}
		}
		.interactiveDismissDisabled()

    }


	func handleScan(result: Result<ScanResult, ScanError>) {
		switch result{
		case .success(let result):
			let details = result.string.components(separatedBy: "&")
			guard details.count == 6 || details.count == 5 else {

				scanFail = true
				return

			}

			let decodedString = Recipient(firstName: details[0],
										  lastName: details[1],
										  address: Address(street: details[2],
										  houseNumber: details[3],
										  zip: details[4]))

			self.order.recipient = decodedString
			print(decodedString)
			print(self.order)
			showShippingView = true

		case .failure(let error):
			print("Scanning failed: \(error.localizedDescription)")
			scanFail = true
			return
		}
	}
}

struct CodeScannerSheetView_Previews: PreviewProvider {
    static var previews: some View {

		let order = Order.defaultOrder()

		CodeScannerSheetView(isShowingScanner: Binding.constant(false), showShippingView: Binding.constant(false), order: Binding.constant(order))
    }
}
