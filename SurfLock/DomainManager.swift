//
//  DomainManager.swift
//  SurfLock
//
//  Created by Sean McKenzie on 11/16/23.
//

import Foundation
import ManagedSettings

class DomainManager: ObservableObject {
    
    @Published var settingsStore = ManagedSettingsStore.init();
    @Published var domains: Set<WebDomain> = []
    @Published var isLoading = false;
    
    func getDomainSetFromFilter(filter: WebContentSettings.FilterPolicy?) -> Set<WebDomain> {
        var domainSetFromAuto: Set<WebDomain> = []
        
        if case let .auto(domains, _) = filter {
            for domain in domains {
                if let domainValue = domain.domain {
                    domainSetFromAuto.insert(WebDomain(domain: domainValue))
                }
            }
        }
        
        return domainSetFromAuto
    }
    
    func syncDomains() {
        isLoading = true;
        domains = getDomainSetFromFilter(filter: settingsStore.webContent.blockedByFilter)
        isLoading = false;
    }
    
    func setBlockedDomains(domainsToBlock: Set<WebDomain>) {
        settingsStore.webContent.blockedByFilter = .auto(domainsToBlock)
        syncDomains()
    }
    
    func blockDomain(domain: WebDomain) {
        guard domain.domain != nil else {
            return
        }
        domains.insert(domain)
        setBlockedDomains(domainsToBlock: domains)
    }
    
    func unblockDomain(domain: WebDomain) {
        domains.remove(domain)
        setBlockedDomains(domainsToBlock: domains)
    }
}
