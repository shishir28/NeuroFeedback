//
//  SimulatedDataGenerator.swift
//  NeurofeedbackApp
//
//  Created by Shishir Mishra on 3/1/2024.
//

import Foundation

class SimulatedDataGenerator  {
    
    private let sampleRate : Int
    
    private var currentTime : TimeInterval
    private var values: [EEGChannel: Double]
    
    init(sampleRate:Int) {
        self.sampleRate = sampleRate
        self.currentTime = Date.now.timeIntervalSince1970
        self.values = [:]
    }
    
    func generateSeries(values: inout [EEGChannel:Double], time: inout Double) -> EEGSeries {
        var readings:  [EEGReading] = []
        time += (1/Double(sampleRate))
        
        let allChannels: [EEGChannel] = [
            .af7, .af8, .fpz, .t9, .t10, .cz, .fz, .f3, .f4, .o1
        ]
        
        allChannels.forEach { channel in
            let randomValue = Double.random(in: -3.35...3.5)
            values[channel] = randomValue
            readings.append(EEGReading(channel:channel, value:randomValue))
        }
        
        return  EEGSeries(timestamp: (Date(timeIntervalSince1970: time)), readings:readings)
    }
    
    func next() -> EEGSeries {
        generateSeries(values: &values, time: &currentTime)
    }
}

class SimulatedRecorder {
    var sampleRate : Int = 0
    var mockGenerators : [EEGFrequency:SimulatedDataGenerator] = [:]
    
    init(sampleRate: Int) {
        self.sampleRate = sampleRate
        for frequency in EEGFrequency.allCases {
            mockGenerators[frequency] = SimulatedDataGenerator(sampleRate: self.sampleRate )
        }
    }
    
    func generateRecording (sampleTime: TimeInterval, recordingOffset: TimeInterval = 0) -> (baseTime:TimeInterval, data:[EEGFrequency:[EEGReading]]) {
        let firstTimeSince1970 = (Date.now.timeIntervalSince1970 - sampleTime)
        let baseTimeSice1970 = firstTimeSince1970 - recordingOffset
        let sampleSize  =  Int(sampleTime * Double(self.sampleRate))
        var currentTime = firstTimeSince1970
        var result : [EEGFrequency:[EEGReading]] = [:]
        for(frequency, dataGenerator) in mockGenerators {
            var channelReadings:[EEGChannel:Double] = [:];
            for _ in 1...sampleSize {
                let dataSeries = dataGenerator.generateSeries(values: &channelReadings, time: &currentTime)
                dataSeries.getChannels().forEach{channel in
                    let reading = dataSeries.getReadingForChannel(channel: channel)
                    if(result[frequency] == nil) {
                        result[frequency] = [reading]
                    }else {
                        var readings = result[frequency]
                        readings?.append(reading)
                        result[frequency] = readings
                    }
                }
            }
        }
        return (baseTimeSice1970,result)
    }
}
