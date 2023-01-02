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
    ]
    
    let columns = [ GridItem(.adaptive(minimum: 100)) ]
    
    @State private var selectedName = ""
    @State private var namePicked = false
    @State private var timesPicked = 0
    @State private var selected = false
    @State private var navSelection: String? = nil
    @State private var shouldTransit = false
    @State private var path: [String] = []
    @State private var indexPicked = 0
    @State private var addMoreNamesAlert = false
    @State private var addedNames = ""
    
    func pickName() {
        selectedName = names.randomElement()?.name ?? "John Doe"
        namePicked = true;
        
        if let matchName =  names.first(where: {$0.name == selectedName}) {
            timesPicked = matchName.picked
        }
        
        if let index = names.firstIndex(where: {$0.name == selectedName}) {
            names[index].picked += 1
            names[index].selected = true
            indexPicked = index
        }
    }
    
    func addNames() {
    // Investigate why preview throws error on components(separatedBy: [" ", ","])
        let namesToAdd = addedNames.components(separatedBy: " ")
        let transformedArray = namesToAdd.map{name -> TeamMember in
            TeamMember(name: name, picked: 0, selected: false)
        }
        names.append(contentsOf: transformedArray)
        addedNames = ""
        
    }
    
    func clearAllnames() {
        names = []
    }
    
    struct SecondView: View {
        var selectedTeamMember: String
        var body: some View {
            VStack {
                Text("The winner is: \(selectedTeamMember)")
            }
            
        }
    }
    // Look at possibly refactoring the below code block into a more reusable and modular approach
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                LinearGradient(colors: [.purple, .white], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    Text("CBeebies Name Picker")
                        .font(.largeTitle.weight(.semibold))
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(names, id: \.id) {
                            item in
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .strokeBorder(
                                        item.selected ? .clear : .purple, lineWidth: 2
                                    )
                                    .background(
                                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                                            .fill(item.selected ? .green : .clear))
                                            .frame(width: 100, height: 50)
                                            .overlay(
                                                Text(item.name)
                                                    .foregroundColor(item.selected ? .white : .indigo)
                                                    .padding()
                                            )
                        }
                    }
                    .padding(.horizontal)
                    Spacer()
                    
//                    NavigationLink(destination: SecondView(selectedTeamMember: selectedName), isActive: $shouldTransit) {
//                        Text("Show detail View")
//                            .onTapGesture {
//                                self.pickName()
//                                self.shouldTransit = true
//                            }
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .tint(.cyan)
                    
                    HStack {
                        Button("Add more names"){
                            addMoreNamesAlert = true
                        }
                        .alert("Add names", isPresented: $addMoreNamesAlert){
                            TextField("Enter additional names", text: $addedNames)
                                .foregroundColor(.black)
                            Button("Save") {
                                addNames()
                            }
                            Button("Cancel", role: .cancel, action: {})
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.white)
                        .tint(.indigo)
                        
                        Button("Clear All Names"){
                           clearAllnames()
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.white)
                        .tint(.red)
                        .disabled(names.isEmpty)
                    }

                    
                    Button("Choose name") {
                        pickName()
                    }
                    .alert(selectedName, isPresented: $namePicked) {
                        Button("Close", role: .cancel) {
                            names[indexPicked].selected = false
                            namePicked = false
                        }
                    } message: {
                        Text("Is the lucky winner, they were picked a total of \(timesPicked) times")
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .tint(.cyan)
                    .disabled(names.isEmpty)
                    Spacer()
                }
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
