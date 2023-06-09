//
//  QRCodeScannerView.swift
//  SEP23SellerAPP

import SwiftUI
import CodeScanner

struct QRCodeScannerView: View {
    
    
    
    @State private var isShowingScanner = false
    @State private var repAddress: recipientAddress? = nil
    
    var body: some View {
        
        NavigationView{
            
            
            VStack{
                
                if let address = repAddress {
                    NavigationLink("Next Page", destination: ShippingpView(repAddress: address), isActive: .constant(true)).hidden()
                }
                
                Button{
                    print("hello")
                    isShowingScanner = true
                }label: {
                    
                    ZStack{
                        Capsule()
                            .fill(.red)
                            .frame(width: 330, height: 130)
                            .shadow(radius: 11)
                        
                        HStack{
                            
                            Image(systemName: "qrcode.viewfinder")
                                .foregroundColor(.yellow)
                                .font(.system(size: 80))
                            
                            Text("Scanner starten")
                                .font(.headline)
                        }
                    }
                }
                .foregroundColor(.black)
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], showViewfinder: true, simulatedData: "Test&Test&Test&Testnum.&49808", completion: handleScan)
                }
                
                .navigationTitle("Qr-Code Scanner")
                
                
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
            //AddressControllView(currentRecipientAddress: repAddress)
            //NavigationLink("",destination: FirstStepView(repAddress: repAddress))
            self.repAddress = repAddress
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
        
    }
}

struct QRCodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeScannerView()
    }
}
