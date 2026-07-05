//
//  Wavers.swift
//  NAS Rally
//
//  Created by Peyton Ward on 6/19/26.
//

import SwiftUI

struct WaversView: View {
    @Binding var person: PersonInfo
    
    var body: some View {
        NavigationStack {
            Text("Wavers")
                .padding(.top, 10)
                .padding(.bottom, 10)
                .bold()
            
            VStack {
                ForEach(0..<person.ralliesJoined, id: \.self) { idx in
                    HStack {
                        VStack {
                            if person.rallieNames.indices.contains(idx) {
                                Text(person.rallieNames[idx])
                                    .font(.title)
                                    .bold()
                                //Text(getWaivers(name: person.rallieNames[idx])) This will call a function to see all of the waivers that are apart of an event and display them all
                                //There will also be a function call down here to determine weather the waiver has been signed.
                            }
                        }
                        .padding(.trailing, 30)
                        
                    } //HStack Style
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea(edges: .horizontal)
                    .glassEffectCompat(.regular, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                }
                Spacer()
            }
            //VStack Style - Moving off Edges
            .padding(.leading, 35)
            .padding(.trailing, 35)
        }
        .frame(maxWidth: .infinity)
    }
}
