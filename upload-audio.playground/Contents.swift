//
//  UploadAudio.swift
//  upload-audio
//
//  Created by Matheus Silva on 29/08/19.
//  Copyright © 2019 Matheus Silva. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

func myAudioUploadRequest(_ url:String, _ nameOfAudioForToSave:String)
{
    
    let myUrl = URL(string: url)!
    var request = URLRequest(url: myUrl)
    request.httpMethod = "POST"
    
    do {
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        guard let url = Bundle.main.url(forResource: "audio", withExtension: "mp3") else { return }
        
        let audioData = try Data(contentsOf: url)
        //        if( audioData==nil ) { return }
        
        
        var body = Data()
        body = createBodyWithParameters(nil , "imgUploader", audioData, boundary, nameOfAudioForToSave)
        request.httpBody = body
        
        
    } catch let error {
        print(error.localizedDescription)
    }
    
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        (data, response, error) in
        do {
            if let data = data {
                let response = try JSONSerialization.jsonObject(with: data, options: [])
                print(response)
            }
            else {
                // Data is nil.
            }
        } catch let error as NSError {
            print("json error: \(error.localizedDescription)")
        }
    }
    task.resume()
}

func generateBoundaryString() -> String {
    return "Boundary-\(NSUUID().uuidString)"
}


func createBodyWithParameters(_ parameters: [String: String]?,_ filePathKey: String?,_ imageDataKey: Data,_ boundary: String, _ nameOfImageForToSave:String) -> Data {
    var body = Data()
    
    if parameters != nil {
        for (key, value) in parameters! {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
    }
    
    let filename = nameOfImageForToSave
    let mimetype = "image/jpeg"
    
    body.appendString("--\(boundary)\r\n")
    body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
    
    
    body.appendString("Content-Type: \(mimetype)\r\n\r\n")
    body.append(imageDataKey)
    body.appendString("\r\n")
    body.appendString("--\(boundary)--\r\n")
    return body
}

extension Data {
    mutating func appendString(_ string: String) {
        let data = string.data(
            using: String.Encoding.utf8,
            allowLossyConversion: true)
        append(data!)
    }
}


myAudioUploadRequest("http://192.168.1.58:3000/upload", "audio.mp3")
