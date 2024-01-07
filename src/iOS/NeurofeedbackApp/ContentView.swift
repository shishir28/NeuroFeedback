//
//  ContentView.swift
//  NeurofeedbackApp
//
//  Created by Shishir Mishra on 3/1/2024.
//

import SwiftUI

struct ContentView: View {
    
    private let sampleRate : Int = 60
    private let sessionId : UUID = UUID(); //  dummy session id for logged on user
    private let userId : UUID = UUID(); // Dummy user id ß
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button(action: generateSimulatedData) {
                Text("GenerateData")
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .padding()
    }
    
    func generateSimulatedData() {
        Constants.setUserDefaults()
        let recorder = SimulatedRecorder(sampleRate:self.sampleRate)
        
        Timer.scheduledTimer(withTimeInterval: 5 , repeats: true) { timer in
          
            
            let tupleResult =  recorder.generateRecording(sampleTime:5)
            let recordingData = EEGRecording(baseTime: tupleResult.baseTime, data: tupleResult.data, sessionId: self.sessionId, userId: self.userId)
            
            StorageController.shared.storeRecording(recordingData: recordingData)
          
            
        }
    }
}


