//
//  ContentView.swift
//  SurfLock
//
//  Created by Sean McKenzie on 11/16/23.
//

import SwiftUI
import FamilyControls
import ManagedSettings

struct ContentView: View {
    
    @ObservedObject var center = AuthorizationCenter.shared
    @ObservedObject var domainManager = DomainManager()
    @State private var newDomain = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Surf Lock")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.bottom)
            
            Form {
                Section(header: Text("Block a domain")) {
                    TextField("Enter domain to block", text: $newDomain)
                    
                    Button("Submit", action: {
                        domainManager.blockDomain(domain: WebDomain(domain: newDomain))
                        newDomain.removeAll()
                    })
                }
                
                Section(header: Text("Blocked Domains")) {
                    BlockedDomainsView(domainmanager: domainManager)
                }
            }
        }
        .padding()
        .task {
            do {
                try await center.requestAuthorization(for: FamilyControlsMember.individual)
                domainManager.syncDomains()
            } catch {
                // Handle the error here.
                print("Error authorizing FamilyControls: \(error)")
            }
        }
        .refreshable {
            domainManager.syncDomains()
        }
    }
}

struct BlockedDomainsView: View {
    
    @ObservedObject var domainmanager: DomainManager
    
    var body: some View {
        if (domainmanager.isLoading) {
            ProgressView()
        } else {
            List {
                ForEach(Array(domainmanager.domains).sorted(by: {$0.hashValue < $1.hashValue}), id: \.hashValue) { domain in
                    Text(domain.domain ?? "Error with domain: \(domain)")
                }
                .onDelete(perform: { indexSet in
                    
                    var domains = Array(domainmanager.domains).sorted(by: {$0.hashValue < $1.hashValue})
                    let domain = domains.remove(at: indexSet.first!)
                    guard domain.domain != nil else {
                        print("DOMAIN WAS EMPTY")
                        return
                    }
                    let webDomain = WebDomain(domain: domain.domain!);
                    print(webDomain)
                    domainmanager.unblockDomain(domain: webDomain)
                })
            }
            .navigationTitle("Blocked Domains")
        }
    }
}

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(10)
    }
}

#Preview {
    ContentView.preview
}

