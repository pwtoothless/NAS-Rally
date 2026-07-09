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
                    .bold()
                
                ForEach(0..<person.ralliesJoined, id: \.self) { idx in
                    HStack {
                        NavigationLink(destination: RallyInfoView(person: $person, rallyName: $person.rallieNames[idx])) {
                                if person.rallieNames.indices.contains(idx) {
                                    AsyncImage(url: try? getRallyImageURL(for: person.rallieNames[idx])) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                                .shadow(radius: 5)
                                        case .failure:
                                            Image(systemName: "car.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100)
                                                .foregroundColor(.gray)
                                                .opacity(0.5)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                                .shadow(radius: 5)
                                        case .empty: // Corrected: Separated .empty case
                                            ProgressView()
                                                .frame(width: 55, height: 44)
                                        @unknown default: // Corrected: Separated @unknown default and placed last
                                            ProgressView()
                                                .frame(width: 100, height: 100)
                                        }
                                    }
                                }
                                else {
                                    Image(systemName: "car.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.gray)
                                        .opacity(0.5)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                        .shadow(radius: 5)
                                }
                        }
                        NavigationLink(destination: RallyInfoView(person: $person, rallyName: $person.rallieNames[idx])) {
                            VStack {
                                if person.rallieNames.indices.contains(idx) {
                                    Text(person.rallieNames[idx])
                                }
                                else {
                                    Text("")
                                    
                                }
                            }
                        }
                    } //HStack Style
                    .padding(.vertical, 8)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea(edges: .horizontal)
                    .glassEffectCompat(.regular, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                }
                Spacer()
                
            } //VStack Style - Moving off Edges
            .padding(.leading, 35)
            .padding(.trailing, 35)
        }
        .frame(maxWidth: .infinity)
    }
}

struct RallyInfoView: View {
    @Binding var person: PersonInfo
    @Binding var rallyName: String
    
    var body: some View {
        Text("This is the screen where text/images about a Rally is shown. Along with sheet views for payment costs and joining the Rally.")
    }
}
