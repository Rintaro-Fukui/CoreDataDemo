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
    // 加速度
    @Published var acceleration_x = "0.0"
    @Published var acceleration_y = "0.0"
    @Published var acceleration_z = "0.0"
    // 回転速度
    @Published var rotation_x = "0.0"
    @Published var rotation_y = "0.0"
    @Published var rotation_z = "0.0"
    // 姿勢
    @Published var attitude_pitch = "0.0"
    @Published var attitude_roll = "0.0"
    @Published var attitude_yaw = "0.0"
    
    // 取得したデータを保存する配列
    var accelValueArray = [String](
        ["acceleration_x,acceleration_y,acceleration_z,rotation_x,rotation_y,rotation_z,attitude_pitch,attitude_roll,attitude_yaw"]
    )
    
    // ボタンが押されたかを判定する
    @Published var isStarted = false
    
    // データの取得
    private func getMotionData(deviceMotion: CMDeviceMotion) {
        acceleration_x = String(deviceMotion.userAcceleration.x)
        acceleration_y = String(deviceMotion.userAcceleration.y)
        acceleration_z = String(deviceMotion.userAcceleration.z)
        rotation_x = String(deviceMotion.rotationRate.x)
        rotation_y = String(deviceMotion.rotationRate.y)
        rotation_z = String(deviceMotion.rotationRate.z)
        attitude_pitch = String(deviceMotion.attitude.pitch)
        attitude_roll = String(deviceMotion.attitude.roll)
        attitude_yaw = String(deviceMotion.attitude.yaw)
        
        let geteData = acceleration_x+","+acceleration_y+","+acceleration_z+","+rotation_x+","+rotation_y+","+rotation_z+","+attitude_pitch+","+attitude_roll+","+attitude_yaw
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

