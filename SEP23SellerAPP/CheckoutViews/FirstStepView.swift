//
//  FirstStepView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 08.04.23.
//

import SwiftUI

struct FirstStepView: View {
    
    let packageSizes = ["S", "M", "L" ]
    @State private var packetCount = 1
    @State private var employeSign = ""
    @State private var choosenPackage: Int? = nil
    @State var repAddress: recipientAddress
    @State private var handInfo = [ HandlingInfo(name: "Gebrechlich", isMarked: false), HandlingInfo(name: "Glas", isMarked: false), HandlingInfo(name: "Flüßigkeiten", isMarked: false), HandlingInfo(name: "Schwer", isMarked: false)]
    @State private var isActive = false
    
    var body: some View {
        
        /*var currentOrder: Order = Order(token: "", timestamp: "", employeID: "", firstName: "", lastName: "", street: "", houseNumber: "", zip: "", city: "", numberPackage: "", packageSize: "", handlingInfo: "")*/
        
        NavigationView{
            VStack{
                List($handInfo) { $HandlingInfo in
                    HStack{
                        Text(HandlingInfo.name)
                            .font(.headline)
                        Spacer()
                        Image(systemName: HandlingInfo.isMarked ? "checkmark.square": "square")
                            .font(.system(size: 30))
                            .onTapGesture {
                                HandlingInfo.isMarked.toggle()
                            }
                    }
                }
                Form{
                    Section(header: Text("Mitarbeiter Kürzel")){
                        TextField("Optional", text: $employeSign)
                        Stepper("Anzahl Pakete: \(packetCount)", value: $packetCount, in: 1...10)
                            .padding(.vertical)
                    }
                }
                
                Form {
                    
                    Section(header: Text("Paket Größe auswählen")){
                        List {
                            ForEach(packageSizes.indices) { index in
                                Button(action: {
                                    if choosenPackage == index {
                                        choosenPackage = nil
                                    } else {
                                        choosenPackage = index
                                    }
                                }) {
                                    HStack {
                                        Text(packageSizes[index])
                                        Spacer()
                                        if choosenPackage == index {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                                .disabled(choosenPackage != nil && choosenPackage != index)
                            }
                        }
                    }
                    /*
                    Button("Lieferung beauftragen"){
                        print(handInfoToString())
                        currentOrder = setOrderAddress(repAddress: repAddress, handInfo: handInfoToString(), packageSize: choosenPackage!, numberPackages: packetCount, employeSign: employeSign)
                        self.isActive = true
                        print(currentOrder.toString())
                       
                    }
                    .disabled(choosenPackage == nil) */
                    Spacer()
                    
                    NavigationLink("Lieferung beauftragen", destination: DeliveryControllView(order: setOrderAddress(repAddress: repAddress, handInfo: handInfoToString(), packageSize: choosenPackage ?? 1, numberPackages: packetCount, employeSign: employeSign)))
                        .disabled(choosenPackage == nil)
                }
                .navigationTitle("Lieferung Infos")
            }
        }
    }
    func handInfoToString() -> String {
        let markedInfos = handInfo.filter { $0.isMarked }
        let combinedNames = markedInfos.map { $0.name }.joined(separator: "&")
        return combinedNames
    }
    func setOrderAddress(repAddress: recipientAddress, handInfo: String, packageSize: Int, numberPackages: Int, employeSign: String) -> Order{
        
        let newOrder = Order(token: "", timestamp: getCurrentDateTime(), employeName: employeSign, firstName: repAddress.surName, lastName: repAddress.name, street: repAddress.street, houseNumber: repAddress.streetNr, zip: repAddress.plz, city: "Lingen", numberPackage: "\(numberPackages)", packageSize: packageSizes[packageSize], handlingInfo: handInfo, deliveryDate: "")
        
        return newOrder
    }
    
    func getCurrentDateTime() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy:HH-mm"
        return formatter.string(from: now)
    }
    
}

struct FirstStepView_Previews: PreviewProvider {
    static var previews: some View {
        let repAdress = recipientAddress(name: "Dettler", surName: "Jan", street: "Kaiserstraße", streetNr: "12", plz: "49809")
        
        FirstStepView(repAddress: repAdress)
    }
}

