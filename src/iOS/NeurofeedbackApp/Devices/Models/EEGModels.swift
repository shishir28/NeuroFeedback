//
//  EEGModels.swift
//  NeurofeedbackApp
//
//  Created by Shishir Mishra on 3/1/2024.
//

import Foundation

//electrical activity or voltage measured by each electrode at that specific time
struct EEGChannel :RawRepresentable, Hashable {
    let rawValue: String
    // in-built channel in Muse
    static let af7 = EEGChannel(rawValue: "AF7")
    static let af8 = EEGChannel(rawValue: "AF8")
    static let fpz = EEGChannel(rawValue: "FPZ")
    static let t9 = EEGChannel(rawValue: "T9")
    static let t10 = EEGChannel(rawValue: "T10")
    // Additional possibble channel for external sensrs
    
    static let cz = EEGChannel(rawValue: "CZ")
    static let fz = EEGChannel(rawValue: "FZ")
    static let f3 = EEGChannel(rawValue: "F3")
    static let f4 = EEGChannel(rawValue: "F4")
    static let o1 = EEGChannel(rawValue: "O1")
}

struct EEGSeries : Identifiable {
    var id :Date {
        timestamp
    }
    let timestamp : Date
    
    private let readingsDictionary :[EEGChannel: EEGReading]
   
    init(timestamp: Date, readings: [EEGReading]) {
        self.timestamp = timestamp
        self.readingsDictionary = Dictionary(uniqueKeysWithValues: readings.map {($0.channel, $0)})
    }
    func getChannels() -> [EEGChannel] {
        return Array(readingsDictionary.keys)
    }
    
    func getReadingForChannel(channel:EEGChannel) -> EEGReading {
        guard let reading  = readingsDictionary[channel] else {
            preconditionFailure("No reading found for channel")
        }
        return reading
    }
}

struct EEGReading {
    
    let channel: EEGChannel
    let value : Double
    
    init(channel: EEGChannel, value: Double) {
        self.channel = channel
        self.value = value
    }
}