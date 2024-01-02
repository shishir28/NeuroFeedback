//
//  Device.swift
//  NeurofeedbackApp
//
//  Created by Shishir Mishra on 3/1/2024.
//

import Foundation

enum DeviceState {
    case unknown
    case found
    case connecting
    case connected
    case onHead
    case disconnecting
    case disconnected
}

enum DeviceType {
    case muse
    case dummy
    case other
}

protocol BaseDevice {
    var name:String {get }
    var id:String { get }
    var macAddress:String {get}
    var signalIndicator: Double { get }
    var deviceState: DeviceState { get }
    func connect ()
    func disconnect()
}
