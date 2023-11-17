//
//  ContentView_PrieviewData.swift
//  SurfLock
//
//  Created by Sean McKenzie on 11/16/23.
//

import SwiftUI
import ManagedSettings

extension ContentView {
    static var preview: ContentView {
        let previewSet: Set<WebDomain> = [WebDomain(domain: "example.com")]
        return ContentView(blockedDomains: previewSet)
    }
    
    init(blockedDomains: Set<WebDomain> = []) {
        self.init()
    }
}

