//
//  Rallies.swift
//  NAS Rally
//
//  Created by Peyton Ward on 5/31/26.
//

import SwiftUI

struct RalliesView: View {
    @Binding var person: PersonInfo
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Rallies")
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                
                ForEach(0..<person.ralliesJoined, id: \.self) { idx in
                    HStack {
                        VStack {
                            if person.rallieNames.indices.contains(idx) {
                                Image("RallyLogos/Logo" + person.rallieNames[idx])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 200)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    .shadow(radius: 5)
                            }
                            else {
                                Image("RallyLogos/LogoUnknown")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 200)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    .shadow(radius: 5)
                            }
                        }
                        VStack {
                            if person.rallieNames.indices.contains(idx) {
                                Text(person.rallieNames[idx])
                            }
                            else {
                                Text("")
                                
                            }
                        }
                    } //HStack Style
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea(edges: .horizontal)
                    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                }
                Spacer()
                
            } //VStack Style - Moving off Edges
            .padding(.leading, 35)
            .padding(.trailing, 35)
        }
        .frame(maxWidth: .infinity)
    }
}
