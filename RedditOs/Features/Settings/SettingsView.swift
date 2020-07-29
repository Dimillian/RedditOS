//
//  SettingsView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 26/07/2020.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        
                    }, label: {
                        VStack {
                            Image(systemName: "gearshape").imageScale(.large)
                            Text("General")
                        }
                    })
                }
                
                ToolbarItem {
                    Button(action: {
                        
                    }, label: {
                        VStack {
                            Image(systemName: "textformat.alt").imageScale(.large)
                            Text("Apperance")
                        }
                    })
                }
                
                
                ToolbarItem {
                    Button(action: {
                        
                    }, label: {
                        VStack {
                            Image(systemName: "stop.circle").imageScale(.large)
                            Text("Filters")
                        }
                    })
                }
                
                ToolbarItem {
                    Button(action: {
                        
                    }, label: {
                        VStack {
                            Image(systemName: "magnifyingglass").imageScale(.large)
                            Text("Search")
                        }
                    })
                }
                
                
                ToolbarItem {
                    Button(action: {
                        
                    }, label: {
                        VStack {
                            Image(systemName: "person").imageScale(.large)
                            Text("Accounts")
                        }
                    })
                }
        }.frame(width: 1000, height: 500)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
