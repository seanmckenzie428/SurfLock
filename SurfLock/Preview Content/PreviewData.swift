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
        return ContentView(domainManager: DomainManager.preview)
    }
}

extension DomainManager {
    static var preview: DomainManager {
        let exampleDomains: Set<WebDomain> = [WebDomain(domain: "example.com")]
        let exampleManager = DomainManager()
        exampleManager.domains = exampleDomains
        return exampleManager
    }
}
