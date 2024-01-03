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
    
    init(sampleRate:Int) {
        self.sampleRate = sampleRate
        self.currentTime = Date.now.timeIntervalSince1970
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
    
    func generateRecording (durationTime : TimeInterval, recordingOffset:TimeInterval = 0 ) -> (baseTime:TimeInterval, data:[EEGSeries]) {
        let now = Date.now.timeIntervalSince1970
        let startTimeSince1970 : TimeInterval = now -  durationTime
        let baseTimeSince1970: TimeInterval = startTimeSince1970 - recordingOffset
        
        let sampleCount = Int(durationTime * Double(sampleRate))
        
        let result = (0..<sampleCount).map { _ in
            return generateSeriesData(startTimeSince1970)
        }
        
        return (baseTimeSince1970, result)
    }
    
    func generateSeriesData(_ startTimeSince1970:TimeInterval) -> EEGSeries {
        var values: [EEGChannel: Double] = [:]
        var currentTime = startTimeSince1970
        let series = generateSeries(values: &values, time: &currentTime)
        return series
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
        
    func generateRecording () -> [EEGFrequency:EEGReading] {
        var result : [EEGFrequency:EEGReading] = [:]
        for(frequency, dataGenerator) in mockGenerators {
            var channelReadings:[EEGChannel:Double] = [:];
            var time: Double = 0;
            let dataSeries = dataGenerator.generateSeries(values: &channelReadings, time: &time)
            dataSeries.getChannels().forEach{channel in
                let reading = dataSeries.getReadingForChannel(channel: channel)
                result[frequency] = reading
            }
        }
        return result
    }
}
