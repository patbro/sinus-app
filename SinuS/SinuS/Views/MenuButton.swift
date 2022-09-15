//
//  MenuButton.swift
//  SinuS
//
//  Created by Loe Hendriks on 15/09/2022.
//

import SwiftUI

struct MenuButton: View {
    let image: Image
    let name: String
    
    var body: some View {
        VStack {
            image
                .resizable()
                .frame(width: 35, height: 35)
            Text(name)
        }
        .frame(width: 150, height: 75)
        .background(Color.yellow)
        .cornerRadius(15)
        .shadow(radius: 10)
        
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButton(image: Image(systemName: "person"), name: "Profile")
    }
}