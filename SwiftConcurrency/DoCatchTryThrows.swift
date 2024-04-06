//
//  DoCatchTryThrows.swift
//  SwiftConcurrency
//
//  Created by Mikhail Chernyshov on 06/04/2024.
//

import SwiftUI

class DoCatchTryThrowsDataManager {
    let isActive: Bool = true
    
    func getTitle () -> (title: String?, error: Error?) {
        if isActive {
            return ("New text", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2 () -> Result<String, Error> {
        if isActive {
            return.success("New text")
        } else {
            return.failure(URLError(.appTransportSecurityRequiresSecureConnection))
        }
    }
    
    func getTitle3 () throws -> String {
        if isActive {
            return "New text"
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    func getTitle4 () throws -> String {
        if isActive {
            return "Final text"
        } else {
            throw URLError(.badServerResponse)
        }
    }
}

class DoCatchTryThrowsViewModel: ObservableObject {
    @Published var text: String = "Starting text"
    let manager = DoCatchTryThrowsDataManager()
    
    func fetchTitle () {
        /*
         let returnedValue = manager.getTitle()
         if let newTitle = returnedValue.title {
         self.text = newTitle
         } else if let error = returnedValue.error {
         self.text = error.localizedDescription
         }
         */
        /*
         let result = manager.getTitle2()
         switch result {
         case .success(let newTitle):
         self.text = newTitle
         case.failure(let error):
         self.text = error.localizedDescription
         }
         */
        do {
            let newTitle = try? manager.getTitle3()
            if let newTitle = newTitle {
                self.text = newTitle
            }
            
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
        } catch let error {
            self.text = error.localizedDescription
        }
    }
}

struct DoCatchTryThrows: View {
    @StateObject private var vm = DoCatchTryThrowsViewModel()
    var body: some View {
        Text(vm.text)
            .frame(width: 300, height: 300)
            .background(.blue)
            .onTapGesture {
                vm.fetchTitle()
            }
    }
}

#Preview {
    DoCatchTryThrows()
}
