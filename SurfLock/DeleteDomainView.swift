//
//  DeleteDomainView.swift
//  SurfLock
//
//  Created by Sean McKenzie on 11/16/23.
//

import SwiftUI
import ManagedSettings

struct DeleteDomainView: View {
    
    @ObservedObject var domainManager: DomainManager
    var timeToWait: Int
    @State var timer: Timer?
    private var domainString: String
    @State var secondsRemaining: Int = 60
    @State var timerStarted: Bool = false
    @State var timerFinished: Bool = false
    @State var labelText: String = ""
    
    var timeRemaining: String {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    init(domainManager: DomainManager, timeToWait: Int = 60) {
        self.domainManager = domainManager
        self.timeToWait = timeToWait
        self.secondsRemaining = timeToWait
        self.domainString = domainManager.deletingDomain?.domain! ?? ""
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Remember, you blocked ").bold() +
            Text(domainString).foregroundStyle(.red) +
            Text(" for a reason!!! ").bold() +
            Text("Are you sure you want to unblock it now?")
        }
        if ( timerStarted && !timerFinished) { // Timer is running
            Text("To make sure this is something you really want you will need to wait for \(timeRemaining) before you can remove it.")
        } else if (timerFinished) { // Timer is finished
            Text("If you're absolutely sure you want to unblock it, you can do so now.")
            Button("Unblock") {
                domainManager.finishUnblockDomain()
            }
            .foregroundStyle(.red)
        } else if (!timerStarted) { // Timer hasn't started
            Button("Unblock", action: startTimer)
                .foregroundStyle(.red)
                .disabled((secondsRemaining > 0) && (secondsRemaining < timeToWait))
        }
        Button("Cancel") {
            timer?.invalidate()
            secondsRemaining = timeToWait
            timerStarted = false
            timerFinished = false
            domainManager.cancelUnblockDomain()
        }
        
    }
    
    func startTimer() {
        timerStarted = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in updateTimer()} )
    }
    
    func updateTimer() {
        if (secondsRemaining > 0) {
            secondsRemaining -= 1
        } else {
            timerFinished = true
            timer?.invalidate()
        }
    }
}

#Preview {
    DeleteDomainView(domainManager: DomainManager.preview)
}
