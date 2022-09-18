//
//  MotionManager.swift
//  CoreMotionDemo
//
//  Created by Rintaro Fukui on 2022/09/19.
//

import Foundation
import CoreMotion

class MotionManager: ObservableObject {
    let motionManager = CMMotionManager()
    
    // 取得したデータを一時的に保存する
    @Published var x = "0.0"
    @Published var y = "0.0"
    @Published var z = "0.0"
    
    // 取得したデータを保存する配列
    var accelValueArray = [String]()
    
    // ボタンが押されたかを判定する
    @Published var isStarted = false
    
    // データの取得
    private func getMotionData(deviceMotion: CMDeviceMotion) {
        x = String(deviceMotion.userAcceleration.x)
        y = String(deviceMotion.userAcceleration.y)
        z = String(deviceMotion.userAcceleration.z)
        
        let geteData = x+","+y+","+z
        accelValueArray.append(geteData)
    }
    
    // スタートボタンを押したときの処理
    func start() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: {
                (motion:CMDeviceMotion?, error:Error?) in
                self.getMotionData(deviceMotion: motion!)
            })
        }
        isStarted = true
    }
    
    // ストップボタンを押したときの処理
    func stop() {
        isStarted = false
        motionManager.stopDeviceMotionUpdates()
        
        // DocumentsフォルダのPathを取得
        guard let dirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Could not get folder path.")
        }
        
        // 現在時刻を取得
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let strDate = formatter.string(from: date)
        
        // ファイルのPathを生成
        let fileName = strDate + ".csv"
        let filePath = dirPath.appendingPathComponent(fileName)
        
        // 配列をCSVに変換する
        let getData = accelValueArray.joined(separator: "\n")
        
        // ファイルの書き出し
        do{
            try getData.write(to: filePath, atomically: true, encoding: .utf8)
        } catch let error as NSError{
            print("Error: \(error)")
        }
    }
}

