import XCTest
@testable import SEP23SellerAPP
import SwiftUI

class APITests: XCTestCase {
    
    
    //Überprüfen ob die sendPostRequest Methode einen Fehler zurückgibt, wenn ungültige URL übergeben wird.
    //Überprüfen ob die sendPostRequest Methode einen Fehler zurückgibt, wenn die Daten nicht in JSON umgewandelt werden können.
    //Überprüfen ob die sendPostRequestWithArrayResponse Methode funktioniert, wie sie soll.
    
    // Wird vor dem Ausführen der Testmethode aufgerufen
    override func setUpWithError() throws {
        
        // Hier können Sie den Initialisierungscode platzieren.
    }
    
    // Wird nach der Ausführung der Testmethode aufgerufen
    override func tearDownWithError() throws {
        // Hier können Sie den Aufräumcode platzieren.
    }
    
    func testInvalidURL() {
        let expectation = self.expectation(description: "Completion handler invoked")
        var resultError: Error?
        
        NetworkManager.sendPostRequest(to: "invalidURL", with: ["key": "value"], responseType: [String: String].self) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                resultError = error
			case .successNoAnswer(_):
				break
			}
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(resultError)
        XCTAssertEqual(resultError?.localizedDescription, "unsupported URL")
    }
    
    func testInvalidJSON() {
        // Ähnlicher Test wie oben, aber sende ungültige Daten, die nicht zu JSON codiert werden können.
    }
    
    func testSendPostRequestWithArrayResponse() {
        // Teste die sendPostRequestWithArrayResponse Methode.
    }


	func testSendOrder() throws {

		let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdG9yZUlEIjo5LCJzdG9yZU5hbWUiOiJQb3JzY2hlIiwib3duZXIiOiJQb3JzY2hlIiwibG9nbyI6IjBmNzMyYmM3LWU2NDktNDBhOS05ODZiLTM0M2Y2OWZiYjMzMiIsInRlbGVwaG9uZSI6IjEyMzQ1Njc4OSIsImVtYWlsIjoiUG9yc2NoZUA5MTEuZGUiLCJ1c2VybmFtZSI6InBvcnNjaGUiLCJpYXQiOjE2OTI3NDE4NDUsInN1YiI6ImF1dGhfdG9rZW4ifQ.bl03z_j7CRKhszD2cno0hjwUgwBbujE-bf9zQ0yPa7k"


		let order = Order(token: token, timestamp: "22-11-2023", employeeName: "TEST", firstName: "Jan", lastName: "De", street: "Kais", houseNumber: "12", zip: "49809", city: "Lingen", packageSize: "L", handlingInfo: "Gebrechlich", deliveryDate: "2023-08-23", customDropOffPlace: "Garage")

		let expectation = self.expectation(description: "Completion handler invoked")
		var resultSuccess = false // Variable to track success

		NetworkManager.sendPostRequest(to: APIEndpoints.order, with: order, responseType: ServerAnswer.self) { result in
			switch result {
			case .success(_):
				resultSuccess = true
			case .failure(_):
				break
			case .successNoAnswer(_):
				break
			}
			expectation.fulfill()
		}

		waitForExpectations(timeout: 5, handler: nil)

		XCTAssertTrue(resultSuccess, "Order send successful")

	}

	func testSendMultipleOrders() throws {
		let expectation = self.expectation(description: "Completion handler invoked")
		var successfulOrderCount = 0 // Variable to count successful orders

		let dispatchGroup = DispatchGroup()
		let queue = DispatchQueue(label: "testQueue", attributes: .concurrent)

		let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdG9yZUlEIjo5LCJzdG9yZU5hbWUiOiJQb3JzY2hlIiwib3duZXIiOiJQb3JzY2hlIiwibG9nbyI6IjBmNzMyYmM3LWU2NDktNDBhOS05ODZiLTM0M2Y2OWZiYjMzMiIsInRlbGVwaG9uZSI6IjEyMzQ1Njc4OSIsImVtYWlsIjoiUG9yc2NoZUA5MTEuZGUiLCJ1c2VybmFtZSI6InBvcnNjaGUiLCJpYXQiOjE2OTI3NDE4NDUsInN1YiI6ImF1dGhfdG9rZW4ifQ.bl03z_j7CRKhszD2cno0hjwUgwBbujE-bf9zQ0yPa7k"


		let order = Order(token: token, timestamp: "22-11-2023:12-15", employeeName: "WB", firstName: "Jan", lastName: "De", street: "Kais", houseNumber: "12", zip: "49809", city: "Lingen", packageSize: "L", handlingInfo: "Gebrechlich", deliveryDate: "2023-08-23", customDropOffPlace: "Garage")

		for _ in 1...2 {
			dispatchGroup.enter()
			queue.async {
				var resultResponse: String?

				NetworkManager.sendPostRequest(to: APIEndpoints.order, with: order, responseType: ServerAnswer.self) { result in
					switch result {
					case .success(let response):
						resultResponse = response.response
						successfulOrderCount += 1
					case .failure(_):
						break
					case .successNoAnswer(_):
						break
					}
					if resultResponse == "Order successfully added" {
						dispatchGroup.leave()
					} else {
						XCTFail("Response should match")
					}
				}
			}
			dispatchGroup.wait() // Wait until the current dispatchGroup.leave() is called
		}

		dispatchGroup.notify(queue: .main) {
			// All orders have been processed
			XCTAssertEqual(successfulOrderCount, 5, "All orders should be sent successfully")
		}
	}

	func testLogin() {
		let expectation = self.expectation(description: "Completion handler invoked")
		var resultSuccess = false // Variable to track success
		let login = LoginData(username: "porsche", password: "Tesla")

		NetworkManager.sendPostRequest(to: APIEndpoints.login, with: login, responseType: ResponseToken.self) { result in
			switch result {
			case .success(_):
				resultSuccess = true // Set to true on success
			case .failure(_):
				break
			case .successNoAnswer(_):
				break
			}
			expectation.fulfill()
		}

		waitForExpectations(timeout: 5, handler: nil)

		XCTAssertTrue(resultSuccess, "Login should be successful")
	}
    
    
    class OrderDetailViewTests: XCTestCase {
        
        func testOrderDetailViewDisplaysCorrectData() throws {
            let testOrder = PlacedOrder(orderID: 1, timestamp: "12-08-2023:23-23", employeeName: "Jobs", packageSize: "M", deliveryDate: "2014-08-22T22:00:00.000Z", customDropoffPlace: "Garage", handlingInfo: "Zerbrechlich&Zerbrechlich&Zerbrechlich", firstName: "Test", lastName: "test", street: "Kaiserstraße", houseNumber: "12", ZIP: 49809)
            
            let view = OrderDetailView(order: testOrder)
            
            // Verwende XCTestExpectation, um auf das Rendern der Ansicht zu warten
            let expectation = XCTestExpectation(description: "View rendered")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5)
        }
        
    }
	class OrderStressTest: XCTestCase {

		func testSendOrder() throws {

			let login = LoginData(username: "porsche", password: "Tesla")

			let loginView = LogINView(signInSuccess: Binding.constant(false))

			print(loginView.signInSuccess)

			XCTAssertTrue(loginView.signInSuccess == true)

			loginView.sendLoginData(loginData: login)

			let order = Order(token: loginView.getSavedToken()!, timestamp: "22-11-2023", employeeName: "WB", firstName: "Jan", lastName: "De", street: "Kais", houseNumber: "12", zip: "49809", city: "Lingen", packageSize: "L", handlingInfo: "Gebrechlich", deliveryDate: "10-04-2023", customDropOffPlace: "Garage")

			let deliverControllView = DeliveryControllView(order: order, showShippingView: Binding.constant(false))

			deliverControllView.sendOrder(newOrder: order)

		}


	}
    
}
