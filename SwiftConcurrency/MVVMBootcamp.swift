//
//  MVVMBootcamp.swift
//  SwiftConcurrency
//
//  Created by Mikhail Chernyshov on 21.05.2024.
//

import SwiftUI

final class MyManagerClass {
    
    func getData() async throws -> String {
        "some data"
    }
}

actor MyManagerActor {
    
    func getData() async throws -> String {
        "some data"
    }
}

@MainActor
final class MVVMBootcampViewModel: ObservableObject {
    let managerClass = MyManagerClass()
    let managerActor = MyManagerActor()
    
    @Published private(set) var myData: String = "starting text"
    private var tasks: [Task<Void, Never>] = []
    
    func cancelTasks () {
        tasks.forEach({$0.cancel()})
        tasks = []
    }
    
    
    func onCallActionButtonPressed() {
        let task = Task {
            do {
                myData = try await managerClass.getData()
                myData = try await managerActor.getData()
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
}

struct MVVMBootcamp: View {
    @StateObject private var vm = MVVMBootcampViewModel()
    
    var body: some View {
        VStack {
            Button(vm.myData) {
                vm.onCallActionButtonPressed()
            }
            
        }
        .onDisappear {
            
        }
    }
}

#Preview {
    MVVMBootcamp()
}
