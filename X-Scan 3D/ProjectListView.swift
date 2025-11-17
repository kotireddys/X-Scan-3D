//
//  ProjectListView.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import SwiftUI

struct ProjectListView: View {
    @EnvironmentObject var vm: ProjectViewModel

    var body: some View {
        List {
            ForEach(vm.projects) { project in
                NavigationLink(destination: ProjectDetailView(project: project)) {
                    HStack {
                        if let thumb = project.thumbnail {
                            Image(uiImage: thumb)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                        }
                        VStack(alignment: .leading) {
                            Text(project.title).bold()
                            Text(project.date, style: .date).font(.caption)
                        }
                    }
                }
            }
        }
        .navigationTitle("My Projects")
    }
}
