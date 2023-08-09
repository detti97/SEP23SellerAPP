//
//  QRCodeScannerView.swift
//  SEP23SellerAPP

import SwiftUI
import CodeScanner

struct QRCodeScannerView: View {
    
    @State private var isShowingScanner = false
	@Binding var showShippingView: Bool
	@Binding var repAddress: recipientAddress
    
    var body: some View {
        
        NavigationView{
            
            VStack{

                Button{
                    print("hello there")
                    isShowingScanner = true
                }label: {
                    
                    ZStack{
                        Capsule()
                            .fill(.blue)
                            .frame(width: 330, height: 130)
                            .shadow(radius: 11)
                        
                        HStack{
                            
                            Image(systemName: "qrcode.viewfinder")
                                .foregroundColor(.white)
                                .font(.system(size: 80))
                            
                            Text("Scanner starten")
                                .font(.headline)
                        }
                    }
                }
                .foregroundColor(.white)
				.fontWeight(.heavy)
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], showViewfinder: true, simulatedData: "Steve&Jobs&Bernd-Rosemeyer-Straße&40&49808", completion: handleScan)
                }
                
                .navigationTitle("New Order")
                
                
            }
        }
        
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result{
        case .success(let result):
            let details = result.string.components(separatedBy: "&")
            guard details.count == 5 else { return }
            
            let repAddress = recipientAddress(name: details[1],
                                              surName: details[0],
                                              street: details[2],
                                              streetNr: details[3],
                                              zip: details[4])
            print(repAddress.toString())
            self.repAddress = repAddress
			showShippingView = true
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
        
    }
}

struct QRCodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
		let repAdress = recipientAddress(name: "Dettler", surName: "Jan", street: "Kaiserstraße", streetNr: "12", zip: "49809")
		let showShippingView = Binding.constant(false)

		QRCodeScannerView(showShippingView: showShippingView, repAddress: Binding.constant(repAdress))
    }
}
