//
//  SidebarTabView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 17/05/2021.
//

import SwiftUI

struct SidebarTabView: View {
    @AppStorage(SettingsKey.sidebar_enabled_section) var enabledSections = SidebarItem.allCases.map{ $0.rawValue }
    private let sortedSections = SidebarItem.allCases.map{ $0.rawValue }

    var body: some View {
        Form {
            Section(header: Text("Sidebar items")) {
                ForEach(SidebarItem.allCases) { item in
                    HStack {
                        Toggle(isOn: Binding(get: {
                            enabledSections.contains(item.rawValue)
                        }, set: { enabled in
                            if enabled {
                                enabledSections.append(item.rawValue)
                                enabledSections = enabledSections.sorted(by: { sortedSections.firstIndex(of: $0)! < sortedSections.firstIndex(of: $1)! })
                            } else {
                                enabledSections.removeAll(where: { $0 == item.rawValue })
                            }
                        }), label: {
                            Text(item.title())
                        })
    
                    }
                }
            }
        }
        .padding(20)
        .frame(width: 400, height: 300)
    }
}

struct SidebarTabView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarTabView()
    }
}

