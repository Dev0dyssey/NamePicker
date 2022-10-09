//
//  ContentView.swift
//  NamePicker
//
//  Created by Thomas Martin on 09/10/2022.
//

import SwiftUI

struct ContentView: View {
    let names = ["Lucia", "Guy", "Ruth", "Nathan", "Santosh", "Jackson", "Chibu", "Agnel", "Samora", "Amy", "Maz", "Jon"]
    let columns = [ GridItem(.adaptive(minimum: 100)) ]
    @State private var selectedName = ""
    @State private var namePicked = false
    func pickName() {
        selectedName = names.randomElement() ?? "John Doe"
        namePicked = true;
        print(selectedName)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple, .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Tap to choose name")
                    .font(.largeTitle.weight(.semibold))
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(names, id: \.self) {
                        item in
                        Text(item)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.purple, lineWidth: 3)
                                    .frame(width: 100)
                            )
                    }
                }
                .padding(.horizontal)
                Spacer()
                Button("Choose name") {
                    pickName()
                }
                    .buttonStyle(.borderedProminent)
                    .tint(.cyan)
                Spacer()
            }
        }
        .alert(selectedName, isPresented: $namePicked) {
            Button("Close", role: .cancel) {}
        } message: {
            Text("Is the lucky winner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
