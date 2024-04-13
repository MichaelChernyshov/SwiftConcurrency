//
//  AsyncAwait.swift
//  SwiftConcurrency
//
//  Created by Mikhail Chernyshov on 13/04/2024.
//

import SwiftUI

class AsyncAwaitVM: ObservableObject {
    @Published var dataArray: [String] = []
    
    func addTitle1 () {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataArray.append("Title 1: \(Thread.current)")
        }
    }
    
    func addTitle2 () {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title2 = "Title 2: \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title2)
                
                let title3 = "Title 3: \(Thread.current)"
                self.dataArray.append(title3)
            }
        }
    }
    
    func addAuthor1 () async {
        let author1 = "Author 1: \(Thread.current)"
        self.dataArray.append(author1)
        
       try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let author2 = "Author 2: \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(author2)
            
            let author3 = "Author 3: \(Thread.current)"
            self.dataArray.append(author3)
        }
    }
    
    func doSmoething () async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let something1 = "Something 1: \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(something1)
            
            let something2 = "Something 2: \(Thread.current)"
            self.dataArray.append(something2)
        }
    }
}

struct AsyncAwait: View {
    @StateObject private var vm = AsyncAwaitVM()
    var body: some View {
        List {
            ForEach(vm.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear{
//            vm.addTitle1()
//            vm.addTitle2()
            Task {
               await vm.addAuthor1()
                await vm.doSmoething()
                
                let final = "Final \(Thread.current)"
                vm.dataArray.append(final)
            }
        }
    }
}

#Preview {
    AsyncAwait()
}
