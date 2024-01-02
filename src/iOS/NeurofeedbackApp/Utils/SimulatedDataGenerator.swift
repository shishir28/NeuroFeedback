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
        let allChannels = Mirror(reflecting: EEGChannel.self).children.compactMap { $0.value as? EEGChannel }
        
        allChannels.forEach { channel in
            let randomValue = Double.random(in: -3.35...3.5)
            values[channel] = randomValue
            readings.append(EEGReading(channel:channel, value:randomValue))
        }
        
        var result :EEGSeries = EEGSeries(timestamp: <#T##Date#>, readings:readings)
        
        return result
    }
    
    func generateRecording (durationTime : TimeInterval, recordingOffset:TimeInterval = 0 ) -> (baseTime:TimeInterval, data:[EEGSeries]) {
        let now = Date.now.timeIntervalSince1970
        let startTimeSince1970 : TimeInterval = now -  durationTime
        let baseTimeSince1970: TimeInterval = startTimeSince1970 - recordingOffset
        
        let sampleCount = Int(durationTime * Double(sampleRate))
        
        var result = (0..<sampleCount).map { _ in
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
