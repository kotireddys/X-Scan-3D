//
//  ModelLibraryView.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import SwiftUI

struct ModelLibraryView: View {
    @EnvironmentObject var vm: ProjectViewModel
    private let grid = [GridItem(.adaptive(minimum: 160), spacing: 12)]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: grid, spacing: 12) {
                    ForEach(vm.projects) { p in
                        NavigationLink(destination: ModelViewer(project: p)) {
                            ZStack(alignment: .bottomLeading) {
                                (p.thumbnail.map { Image(uiImage: $0) } ?? Image(systemName: "cube"))
                                    .resizable().scaledToFill()
                                    .frame(width: 160, height: 160)
                                    .clipped()
                                    .background(Color.black)
                                    .cornerRadius(14)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(p.title).font(.caption).fontWeight(.semibold)
                                    Text(p.date, style: .date).font(.caption2)
                                }
                                .foregroundColor(.white)
                                .padding(6)
                                .background(.ultraThinMaterial)
                                .cornerRadius(8)
                                .padding(6)
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("My Models")
        }
    }
}
