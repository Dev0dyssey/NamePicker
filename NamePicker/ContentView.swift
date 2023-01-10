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
    
    struct ArrayWithIdentifier: Identifiable {
        let id: String
        var array: [TeamMember]
    }
    
    @State var names2: [ArrayWithIdentifier] = [
        ArrayWithIdentifier(
            id: "CBeebies",
            array: [
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
        )
    ]
    
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
    
    var namesList =
    ["CBeebies", "Custom One", "BBC", "Custom Two"]
    
    
    @State private var selectedNamesArray = "CBeebies"
    
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
    
    func selectArray(id: String) -> [TeamMember]? {
        if let arrayWithIdentifier = names2.first(where: {$0.id == id}) {
            return arrayWithIdentifier.array
        }
        return nil
    }
    
    func pickName() {
        selectedName = names2.first?.array.randomElement()?.name ?? "John Doe"
        namePicked = true;
        
        if let matchName =  names2.first?.array.first(where: {$0.name == selectedName}) {
            timesPicked = matchName.picked
        }
        
        if let index = names2.first?.array.firstIndex(where: {$0.name == selectedName}) {
            names2[0].array[index].picked += 1
            names2[0].array[index].selected = true
            indexPicked = index
        }
    }
    
    func addNames() {
        // Investigate why preview throws error on components(separatedBy: [" ", ","])
        // Ask within SwiftUI community
        let namesToAdd = addedNames.components(separatedBy: " ")
        let transformedArray = namesToAdd.map{name -> TeamMember in
            TeamMember(name: name, picked: 0, selected: false)
        }
        let selectedArray = selectArray(id: selectedNamesArray);
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
                    Picker("Please choose a color", selection: $selectedNamesArray) {
                        ForEach(namesList, id: \.self) {
                            Text($0)
                        }
                    }
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(names2) {
                            arrayWithIdentifier in
                            ForEach(arrayWithIdentifier.array) {
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
                            names2[0].array[indexPicked].selected = false
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
