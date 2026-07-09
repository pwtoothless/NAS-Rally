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
                ForEach(person.rallieNames.indices, id: \.self) { idx in
                    HStack {
                        VStack {
                            Text(person.rallieNames[idx])
                                .font(.title)
                                .bold()
                        }
                        .padding(.trailing, 30)
                        
                    } //HStack Style
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
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
