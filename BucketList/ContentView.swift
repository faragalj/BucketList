//
//  ContentView.swift
//  BucketList
//
//  Created by Joseph Faragalla on 2020-09-01.
//  Copyright © 2020 Joseph Farag Alla. All rights reserved.

import SwiftUI


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





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
