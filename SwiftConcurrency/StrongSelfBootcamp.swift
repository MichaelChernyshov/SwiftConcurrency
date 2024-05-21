//
//  StrongSelfBootcamp.swift
//  SwiftConcurrency
//
//  Created by Mikhail Chernyshov on 21.05.2024.
//

import SwiftUI

final class StrongSelfDataService {
    func getData() async -> String {
        "UpdatedData"
    }
}

final class StrongSelfBootcampViewModel: ObservableObject {
    @Published var data: String = "Some title"
    let ds = StrongSelfDataService()
    
    private var someTask: Task<Void, Never>? = nil
    private var myTasks: [Task<Void, Never>] = []
    
    func cancelTasks() {
        someTask?.cancel()
        someTask = nil
        
        myTasks.forEach({$0.cancel()})
        myTasks = []
    }
    
    // This implies a strong reference
    func updateData () {
        Task {
            data = await ds.getData()
        }
    }
    
    // This is a strong reference
    func updateData2 () {
        Task {
            self.data = await self.ds.getData()
        }
    }
    
    // This is a strong reference
    func updateData3 () {
        Task { [self] in
            data = await self.ds.getData()
        }
    }
    
    // This is a weak reference
    func updateData4 () {
        Task { [weak self] in
            if let data = await self?.ds.getData() {
                self?.data = data
            }
        }
    }
    
//    we don't need manage weak strong because
//    we can manage the task!
    func updateData5 () {
        someTask = Task {
            data = await self.ds.getData()
        }
    }
    
    func updateData6 () {
        let task1 = Task {
            data = await self.ds.getData()
        }
        myTasks.append(task1)
        
        let task2 = Task {
            data = await self.ds.getData()
        }
        myTasks.append(task2)
    }
    
    // we purposely do not cancel tasks to keep strong reference
    func updateData7 () {
        Task {
            self.data = await self.ds.getData()
        }
        Task.detached {
            self.data = await self.ds.getData()
        }
    }

}

struct StrongSelfBootcamp: View {
    @StateObject private var vm = StrongSelfBootcampViewModel()
    
    
    var body: some View {
        Text(vm.data)
            .onAppear(perform: {
                vm.updateData()
            })
            .onDisappear(perform: {
                vm.cancelTasks()
            })
    }
}

#Preview {
    StrongSelfBootcamp()
}
