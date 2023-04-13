//
//  FirstStepView.swift
//  SEP23SellerAPP
//
//  Created by Jan Dettler on 08.04.23.
//

import SwiftUI

struct ShippingpView: View {
    
    let packageSizes = ["S", "M", "L", "XL" ]
    @State private var packetCount = 1
    @State private var employeSign = ""
    @State private var choosenPackage: Int? = nil
    @State var repAddress: recipientAddress
    @State private var handInfo = [ HandlingInfo(name: "Gebrechlich", isMarked: false), HandlingInfo(name: "Glas", isMarked: false), HandlingInfo(name: "Flüßigkeiten", isMarked: false), HandlingInfo(name: "Schwer", isMarked: false)]
    @State private var isActiveHandling = true
    @State private var isActiveEmpPackage = false
    @State private var isActivePackageSize = false
    @State private var isActiveDatePicker = false
    @State private var selectedDate = Date()
    @State private var selectedDateString = ""
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yy"
        return formatter
    }
    
    var body: some View {
        
        NavigationView{
            
            VStack{
                
                if isActiveHandling{
                    Form{
                        Section(header: Text("Handling Info")){
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
                        }
                        Button(action:
                                { isActiveHandling = false
                            isActiveEmpPackage = true
                        }) {
                            HStack{
                                Image(systemName: "checkmark.circle")
                                    .font(.system(size: 30))
                                    .foregroundColor(.green)
                                Text("Bestätigen")
                                    .font(.system(size: 20))
                                
                            }
                            
                        }
                    }
                }
                if isActiveEmpPackage{
                    Form{
                        Section(header: Text("Mitarbeiter Kürzel")){
                            TextField("Optional", text: $employeSign)
                            Stepper("Anzahl Pakete: \(packetCount)", value: $packetCount, in: 1...10)
                                .padding(.vertical)
                        }
                        Button(action:
                                { isActiveEmpPackage = false
                            isActivePackageSize = true
                        }) {
                            HStack{
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.green)
                                    .font(.system(size: 30))
                                Text("Bestätigen")
                                    .foregroundColor(.blue)
                            }
                        }
                        Button(action:
                                { isActiveHandling = true
                            isActiveEmpPackage = false
                        }) {
                            HStack{
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.red)
                                    .font(.system(size: 30))
                                Text("Zurück")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                if isActivePackageSize{
                    
                    Form {
                        Button(action:
                                { isActiveEmpPackage = true
                            isActivePackageSize = false
                        }) {
                            HStack{
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.red)
                                    .font(.system(size: 30))
                                Text("Zurück")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        Section(header: Text("Paket Größe auswählen")){
                            List {
                                ForEach(packageSizes.indices, id: \.self) { index in
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
                        Section(header: Text("Lieferdatum wählen")){
                                DatePicker(
                                    "Lieferdatum wählen",
                                    selection: $selectedDate,
                                    in: Date()...,
                                    displayedComponents: .date
                                )
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .padding()
                                
                                Button("Bestätigen") {
                                    selectedDateString = dateFormatter.string(from: selectedDate)
                                    print("Gewähltes Datum: \(selectedDateString)")
                                    isActiveDatePicker = false
                                }
                        }
                        
                        
                        NavigationLink("Lieferung beauftragen", destination: DeliveryControllView(order: setOrderAddress(repAddress: repAddress, handInfo: handInfoToString(), packageSize: choosenPackage ?? 1, numberPackages: packetCount, employeSign: employeSign, deliveryDate: selectedDateString)))
                            .disabled(choosenPackage == nil || selectedDateString == "")
                            .foregroundColor(.blue)
                    }
                }
                
            }
            
            
        }
        
    }
    
    func handInfoToString() -> String {
        let markedInfos = handInfo.filter { $0.isMarked }
        let combinedNames = markedInfos.map { $0.name }.joined(separator: "&")
        return combinedNames
    }
    func setOrderAddress(repAddress: recipientAddress, handInfo: String, packageSize: Int, numberPackages: Int, employeSign: String, deliveryDate: String) -> Order{
        
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

struct ShippingView_Previews: PreviewProvider {
    static var previews: some View {
        let repAdress = recipientAddress(name: "Dettler", surName: "Jan", street: "Kaiserstraße", streetNr: "12", plz: "49809")
        
        ShippingpView(repAddress: repAdress)
    }
}

