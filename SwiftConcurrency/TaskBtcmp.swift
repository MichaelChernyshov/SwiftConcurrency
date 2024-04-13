//
//  TaskBtcmp.swift
//  SwiftConcurrency
//
//  Created by Mikhail Chernyshov on 13/04/2024.
//

import SwiftUI

class TaskBtcmpVM: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage () async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image = UIImage(data: data)
                print("Image returned")
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2 () async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image2 = UIImage(data: data)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

struct TaskBtcmpHomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink("Click me") {
                    TaskBtcmp()
                }
            }
        }
    }
}

struct TaskBtcmp: View {
    @StateObject private var vm = TaskBtcmpVM()
    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack (spacing: 40) {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image = vm.image2  {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await vm.fetchImage()
        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
//        .onAppear {
//            fetchImageTask = Task {
//                await vm.fetchImage()
//            }
////            Task {
////                print(Thread.current)
////                print(Task.currentPriority)
////                await vm.fetchImage2()
////            }
//            
////            Task(priority: .low) {
////                print("low: \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .medium) {
////                print("medium: \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .high) {
//////                try? await Task.sleep(nanoseconds: 2_000_000_000)
//////                await Task.yield() To let other task go first
////                print("high: \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .background) {
////                print("background: \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .utility) {
////                print("utility: \(Thread.current) : \(Task.currentPriority)")
////            }
//            
////            Task(priority: .userInitiated) {
////                print("userInitiated: \(Thread.current) : \(Task.currentPriority)")
////                
////                Task {
////                    print("userInitiated2: \(Thread.current) : \(Task.currentPriority)")
////                }
////            }
//            
//            
//        }
    }
}

#Preview {
    TaskBtcmp()
}
