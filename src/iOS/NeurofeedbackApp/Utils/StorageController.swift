//
//  StorageController.swift
//  NeurofeedbackApp
//
//  Created by Shishir Mishra on 4/1/2024.
//

import Foundation
import HDF5Kit

struct PersistentDataModel {
    let date: Date
    let sessionId: String
    let userId: String
    let fileName: String
    
    init(date: Date, sessionId: UUID, userId: UUID,fileName: String) {
        self.date = date
        self.sessionId = sessionId.uuidString
        self.userId = userId.uuidString
        self.fileName = fileName
    }
    
    init(withDict dict: Dictionary<String, Any>) {
        self.date = dict["date"] as! Date
        self.sessionId = dict["sessionId"] as! String
        self.userId = dict["userId"] as! String
        self.fileName = dict["fileName"] as! String
    }
    
    func asDictionary() -> Dictionary<String, Any> {
        let dict: [String: Any] = [
            "date": self.date,
            "sessionId": self.sessionId,
            "userId": self.userId,
            "fileName": self.fileName,
        ]
        return dict
    }
}

class StorageController {
    
    static let shared = StorageController()
    
    let defaults = UserDefaults.standard
    let notificationCenter = NotificationCenter.default
    
    func storeRecording(recordingData:EEGRecording){
        
        uploadDataToServer(recordingData: recordingData)
        // we can remove code for HDf5 if it not relevant in long run
        saveAshdf5(recordingData: recordingData)
    }
    
    func getRemoteURL() -> URL? {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let config = NSDictionary(contentsOfFile: path) as? [String: Any],
           let remoteURL = config["UPLOAD_DATA_URL"] as? String {
            return (URL(string:remoteURL)!)
            
            // Use the API key
        } else {
            print("Have problem accesing config file")
            return nil
        }
    }
    
    func uploadDataToServer(recordingData:EEGRecording) {
        
        if let url = getRemoteURL() {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(recordingData)
                
                let optionalData: Data? = jsonData
                
                request.httpBody = optionalData
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("Error: \(error)")
                    } else {
                        if let httpResponse = response as? HTTPURLResponse {
                            print("Status Code: \(httpResponse.statusCode)")
                            // Check for successful response (status code 20x)
                            if (200..<300).contains(httpResponse.statusCode) {
                                print("Data sent successfully to Azure Endpoint.")
                            } else {
                                print("Failed to send data to Azure Endpoint. Status Code: \(httpResponse.statusCode)")
                            }
                        }
                    }
                }
                task.resume()
                
            } catch {
                print("Error converting object to JSON: \(error)")
            }
            
        }else {
            print("Failed to create URL")
        }
    }
    
    
    func saveAshdf5(recordingData:EEGRecording) -> Int
    {
        let fileName = "\(recordingData.userId)_\(recordingData.sessionId)_\(recordingData.baseTime).hdf"
        
        guard let h5file = File.create(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/" + fileName, mode: .truncate) else {
            print("Could not create file!")
            return -1
        }
        
        do {
            let sessionId = recordingData.sessionId
            let userId = recordingData.userId
            
            let group = h5file.createGroup("Recording")
            try _ = group.createStringAttribute("SessionId")?.write(sessionId.uuidString)
            try _ = group.createStringAttribute("Userid")?.write(userId.uuidString)
            try _ = group.createStringAttribute("Time")?.write(recordingData.baseTime.description)
            
            for (frequency, readings) in recordingData.data {
                
                try group.createStringDataset("Frequency- \(frequency.rawValue)", dataspace: Dataspace(dims: [1, 1], maxDims: [1, 1]))?.write([frequency.rawValue])
                let groupedChannel = Dictionary(grouping: readings, by: { $0.channel.rawValue })
                
                for (channelName, readingValues)  in groupedChannel {
                    let dims: [Int] = [1,readingValues.count]
                    try _ = group.createAndWriteDataset("Frequency-Channel-Data- \(frequency.rawValue)- \(channelName)", dims: dims, data:  readingValues.compactMap({$0.value}))
                }
            }
            
        } catch {
            print("Could not write to file!")
            return -1
        }
        h5file.flush()
        return storeFileToDB(userId: recordingData.userId, sessionId: recordingData.sessionId, fileName: fileName)
    }
    
    func storeFileToDB(userId: UUID, sessionId:UUID, fileName: String) -> Int {
        let defaults = UserDefaults.standard
        let dataModel : PersistentDataModel = PersistentDataModel(date:Date(),sessionId: sessionId, userId: userId, fileName: fileName)
        
        if let storedData = defaults.array(forKey: "storedData")  {
            var tobeStored = storedData as! [Dictionary<String, Any>]
            tobeStored.append(dataModel.asDictionary())
            defaults.set(tobeStored, forKey:  "storedData")
            return (tobeStored.endIndex - 1)
        } else {
            // Handle the case where myOptionalVariable is nil
            print("Optional variable is nil")
            return 1
        }
    }
}
