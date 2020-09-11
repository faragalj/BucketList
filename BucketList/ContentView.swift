//
//  ContentView.swift
//  BucketList
//
//  Created by Joseph Faragalla on 2020-09-01.
//  Copyright © 2020 Joseph Farag Alla. All rights reserved.

import MapKit
import SwiftUI
import LocalAuthentication


struct User: Identifiable, Comparable {
    
    let id = UUID()
    var firstName: String
    var lastName: String
    
    //lets us call .sorted() without having to play around without messing up our layout code
    
    static func < (lhs: User, rhs: User) -> Bool {
        lhs.lastName < rhs.lastName
    }
    
    
}

struct ContentView: View {
    let users = [
    User(firstName: "a", lastName: "b"),
    User(firstName: "c", lastName: "d"),
    User(firstName: "e", lastName: "f"),
    User(firstName: "g", lastName: "h")
    
    ].sorted()
    
    var body: some View {
        List(users) { user in
            Text("\(user.firstName), \(user.lastName)")
        }
    }
}










struct WritingDataToDocumentsDirectory: View {
    //whats the difference between writing stuff to document directory vs core data vs userDefaults?
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    var body: some View {
        Text("Hello World")
            .onTapGesture {
                //setting url and what we want to send in
                let str = "test message"
                let url = self.getDocumentDirectory().appendingPathComponent("message.txt")
                do {
                    //writing it to document directory
                    try str.write(to: url, atomically: true, encoding: .utf8)
                    //fetching it again to see if it works and printing to test
                    let input = try String(contentsOf: url)
                    print(input)
                } catch {
                    //tell me if something goes wrong
                    print(error.localizedDescription)
                }
        }
    }
}










enum LoadingState {
    case loading, success, failed
}

struct SwitchingViewStatesWithEnums: View {
    var loadingState = LoadingState.loading
    
    var body: some View {
        Group {
            if loadingState == .loading {
                LoadingView()
            } else if loadingState == .success {
                SuccessView()
            } else if loadingState == .failed {
                FailedView()
            }
        }
    }
}


struct LoadingView: View {
    var body: some View {
        Text("Loading...")
    }
}

struct SuccessView: View {
    var body: some View {
        Text("Success!")
    }
}

struct FailedView: View {
    var body: some View {
        Text("Failed.")
    }
}










struct UsingMapKit: View {
    var body: some View {
        MapView()
            .edgesIgnoringSafeArea(.all)
    }
}



struct UsingFaceIDTouchID: View {
    
    @State private var isUnlocked = false
    
    
    var body: some View {
        VStack {
            if self.isUnlocked {
                Text("Unlocked")
            } else {
                Text("Locked")
            }
        }
    .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        let context =  LAContext()
        var error: NSError?
        
        //check wether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            //it is possible, go ahead and use it
            let reason = "We need to unlock your data"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, authenticationError) in
                //authentication has now been completed
                //what is the puropose of dispatchQueue.main.async?
                DispatchQueue.main.async {
                    if success {
                        //authenticated successfully
                        self.isUnlocked = true
                    } else {
                        //there was a problem
                    }
                }
            }
        } else {
            //no biometrics (ex ipod)
        }
    }
}


struct MoreOfMapKit: View {
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var locations = [MKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingPlaceDetails = false
    
    var body: some View {
        ZStack {
            MapView2(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations)
                .edgesIgnoringSafeArea(.all)
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        //create a new location
                        
                        //when the button is tapped, add a marker where the center circle is
                        let newLocation = MKPointAnnotation()
                        newLocation.title = "Example Location"
                        newLocation.coordinate = self.centerCoordinate
                        self.locations.append(newLocation)
                    }) {
                        Image(systemName: "plus")
                    }
                .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                }
            }
        }
        .alert(isPresented: $showingPlaceDetails) {
            Alert(title: Text(selectedPlace?.title ?? "Unknown Title"), message: Text(selectedPlace?.subtitle ?? "Missing Place information"), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")) {
                //edit here
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
