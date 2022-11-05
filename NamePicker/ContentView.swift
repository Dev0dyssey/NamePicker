//
//  ContentView.swift
//  NamePicker
//
//  Created by Thomas Martin on 09/10/2022.
//

import SwiftUI

struct ContentView: View {
    struct TeamMember: Identifiable {
        let id = UUID()
        let name: String
        var picked: Int
        var selected: Bool
    }
    @State var names = [
        TeamMember(name: "Lucia", picked: 0, selected: false),
        TeamMember(name: "Guy", picked: 0, selected: false),
        TeamMember(name: "Ruth", picked: 0, selected: false),
        TeamMember(name: "Nathan", picked: 0, selected: false),
        TeamMember(name: "Santosh", picked: 0, selected: false),
        TeamMember(name: "Jackson", picked: 0, selected: false),
        TeamMember(name: "Chibu", picked: 0, selected: false),
        TeamMember(name: "Agnel", picked: 0, selected: false),
        TeamMember(name: "Samora", picked: 0, selected: false),
        TeamMember(name: "Amy", picked: 0, selected: false),
        TeamMember(name: "Maz", picked: 0, selected: false),
        TeamMember(name: "Jon", picked: 0, selected: false)
//        "Lucia", "Guy", "Ruth", "Nathan", "Santosh", "Jackson", "Chibu", "Agnel", "Samora", "Amy", "Maz", "Jon"
    ]
    
    let columns = [ GridItem(.adaptive(minimum: 100)) ]
    
    @State private var selectedName = ""
    @State private var namePicked = false
    @State private var timesPicked = 0
    @State private var selected = false
    @State private var navSelection: String? = nil
    @State private var shouldTransit = false
    @State private var path: [String] = []
    
    func pickName() {
        selectedName = names.randomElement()?.name ?? "John Doe"
        namePicked = true;
        
        if let matchName =  names.first(where: {$0.name == selectedName}) {
            timesPicked = matchName.picked
        }
        
        if let index = names.firstIndex(where: {$0.name == selectedName}) {
            names[index].picked += 1
        }
        print(selectedName)
    }
    
    struct SecondView: View {
        var selectedTeamMember: String
        var body: some View {
            VStack {
                Text("The winner is: \(selectedTeamMember)")
            }
            
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                LinearGradient(colors: [.purple, .white], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    Text("Tap to choose name")
                        .font(.largeTitle.weight(.semibold))
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(names, id: \.id) {
                            item in
                            Text(item.name)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(.purple, lineWidth: 3)
                                        .frame(width: 100)
                                )
    //                            .background(selected ? .green : .white)
                        }
                    }
                    .padding(.horizontal)
                    Spacer()
//                    Button("Go Search") {
//                        path.append("SecondView")
//                    }
//                    NavigationLink(value: path[0]) {
//                        Text("New view")
//                    }
                    
                    NavigationLink(destination: SecondView(selectedTeamMember: selectedName), isActive: $shouldTransit) {
                        Text("Show detail View")
                            .onTapGesture {
                                self.pickName()
                                self.shouldTransit = true
                            }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.cyan)
                    
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
                Text("Is the lucky winner, they were picked a total of \(timesPicked) times")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
