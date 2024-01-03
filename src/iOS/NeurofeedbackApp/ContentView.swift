//
//  ContentView.swift
//  NeurofeedbackApp
//
//  Created by Shishir Mishra on 3/1/2024.
//

import SwiftUI

struct ContentView: View {
    private let sampleRate : Int = 60
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
        let recorder = SimulatedRecorder(sampleRate:self.sampleRate)
        
        Timer.scheduledTimer(withTimeInterval: (1.0 / Double(self.sampleRate)) , repeats: true) { timer in
            let  result = recorder.generateRecording()
            for(frequency, reading) in result {
                print(frequency)
                print(reading)
            }
        }
    }
   
}



