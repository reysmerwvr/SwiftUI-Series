//
//  ContentView.swift
//  SwiftUI-Demo
//
//  Created by Reysmer Williangel Valle Ramírez on 6/21/20.
//  Copyright © 2020 Reysmer Williangel Valle Ramírez. All rights reserved.
//

import Combine
import SwiftUI

class DataSource: ObservableObject {
    let didChange = PassthroughSubject<Void, Never>()
    var pictures = [String]()
    
    init() {
        let fm = FileManager.default
        
        if let path = Bundle.main.resourcePath, let items = try? fm.contentsOfDirectory(atPath: path) {
            for item in items {
                if item.hasPrefix("nssl") {
                    pictures.append(item)
                }
            }
        }
        
        didChange.send(())
    }
}

struct DetailView: View {
    @State private var hidesNavigationBar = false
    var selectedImage: String
    
    var body: some View {
        let img = UIImage(named: selectedImage)!
        return Image(uiImage: img)
            .resizable()
            .aspectRatio(1024/768, contentMode: .fit)
            .navigationBarTitle(Text(selectedImage), displayMode: .inline)
            .navigationBarHidden(hidesNavigationBar)
            .onTapGesture {
                self.hidesNavigationBar.toggle()
            }
    }
}

struct ContentView: View {
    @State private var text = "Hello, World!"
    
    @ObservedObject var dataSource = DataSource()
    
    var body: some View {
//        Text(verbatim: text)
        NavigationView {
            List(dataSource.pictures, id: \.self) { picture in
                NavigationLink(destination: DetailView(selectedImage: picture)) {
                    Text(picture)
                }
            }.navigationBarTitle(Text("Storm Viewer"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
