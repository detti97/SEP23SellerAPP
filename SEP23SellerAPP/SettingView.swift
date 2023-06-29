import SwiftUI


struct SettingView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showEditAddress = false
    @State private var showEditOpeningHours = false
    @State private var showEditPhoneNumber = false
    @State private var zipCode = ""
    @State private var homeNumber = ""
    @State private var address = ""
    @State private var openingHours = ""
    @State private var phoneNumber = ""
    @State private var Email = ""
    @State private var Owner = ""
    @State private var showEditEmail = false
    @State private var showEditOwner = false

    @Binding var signInSuccess: Bool

    var body: some View {
        Form {
            Section(header: Text("Geschäftsinformationen-Bearbeiten")) {
                Button(action: {
                    showEditAddress = true
                }) {
                    Text("Adresse bearbeiten")
                }
                .sheet(isPresented: $showEditAddress) {
                    EditAddressView(address: $address, homeNumber: $homeNumber, zipCode: $zipCode)
                }


                Button(action: {
                    showEditOpeningHours = true
                }) {
                    Text("Öffnungszeiten bearbeiten")
                }
                .sheet(isPresented: $showEditOpeningHours) {
                    EditOpeningHoursView(openingHours: $openingHours)
                }

                Button(action: {
                    showEditPhoneNumber = true
                }) {
                    Text("Telefonnummer bearbeiten")
                }
                .sheet(isPresented: $showEditPhoneNumber) {
                    EditPhoneNumberView(phoneNumber: $phoneNumber)
                }
                
                Button(action: {
                    showEditEmail = true
                }) {
                    Text("Geschäfts-E-mail bearbeiten")
                }
                .sheet(isPresented: $showEditEmail) {
                    EditEmailView(Email: $Email)
                    
                
                }
                Button(action: {
                    showEditOwner = true
                }) {
                    Text("Verantwortliche fürs Geschäfts bearbeiten")
                }
                .sheet(isPresented: $showEditOwner) {
                    EditOwnerView(Owner: $Owner)
                }
            }

            Section {
                Button(action: {
                    signOut()
                }) {
                    Text("Abmelden")
                        .foregroundColor(.red)
                }
            }

            Section(header: Text("Einstellungen")) {
                Toggle(isOn: $isDarkMode) {
                    Text("Dark Mode")
                }
            }

        }
        .navigationBarTitle("Einstellungen")
    }

    
    private func signOut() {
       

        signInSuccess = false
    }
}









struct EditEmailView: View {
    @Binding var Email: String
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Email", text: $Email)
            }
            .navigationBarTitle("Email bearbeiten")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }

    private var saveButton: some View {
        Button(action: {
            // Speichere die geänderten Daten
            // ...

            // Schließe die Ansicht und kehre zum Einstellungsmenü zurück
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Speichern")
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            // Schließe die Ansicht und kehre zum Einstellungsmenü zurück
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Zurück")
        }
    }
}







struct EditOwnerView: View {
    @Binding var Owner: String
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Verantwortliche", text: $Owner)
            }
            .navigationBarTitle("Verantwortliche bearbeiten")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }

    private var saveButton: some View {
        Button(action: {
            // Speichere die geänderten Daten
            // ...

            // Schließe die Ansicht und kehre zum Einstellungsmenü zurück
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Speichern")
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            // Schließe die Ansicht und kehre zum Einstellungsmenü zurück
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Zurück")
        }
    }
}












struct EditAddressView: View {
    @Binding var address: String
    @Binding var homeNumber: String
    @Binding var zipCode: String
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Adresse", text: $address)
                TextField("Hausnummer", text: $homeNumber)
                TextField("PLZ", text: $zipCode)
            }
            .navigationBarTitle("Adresse bearbeiten")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }

    private var saveButton: some View {
        Button(action: {
            // Speichere die geänderten Daten
            // ...

            // Schließe die Ansicht und kehre zum Einstellungsmenü zurück
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Speichern")
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            // Schließe die Ansicht und kehre zum Einstellungsmenü zurück
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Zurück")
        }
    }
}


struct EditOpeningHoursView: View {
    @Binding var openingHours: String
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Öffnungszeiten", text: $openingHours)
            }
            .navigationBarTitle("Öffnungszeiten bearbeiten")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }

    private var saveButton: some View {
        Button(action: {
            // Speichere die geänderten Daten
            // ...

            // Schließe die Ansicht und kehre zum Einstellungsmenü zurück
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Speichern")
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            // Schließe die Ansicht und kehre zum Einstellungsmenü zurück
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Zurück")
        }
    }
}

struct EditPhoneNumberView: View {
    @Binding var phoneNumber: String
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Telefonnummer", text: $phoneNumber)
            }
            .navigationBarTitle("Telefonnummer bearbeiten")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }

    private var saveButton: some View {
        Button(action: {
            // Speichere die geänderten Daten
            // ...

            // Schließe die Ansicht und kehre zum Einstellungsmenü zurück
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Speichern")
        }
    }
    
    private var cancelButton: some View {
        Button(action: {
            // Schließe die Ansicht und kehre zum Einstellungsmenü zurück
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Zurück")
        }
    }
}
