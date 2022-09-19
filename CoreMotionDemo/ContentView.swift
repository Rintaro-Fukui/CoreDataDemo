//
//  ContentView.swift
//  CoreMotionDemo
//
//  Created by Rintaro Fukui on 2022/09/19.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    @ObservedObject var sensor = MotionManager()
    
    var body: some View {
        VStack {
            Text("acceleration_x: "+sensor.acceleration_x)
            Text("acceleration_y: "+sensor.acceleration_y)
            Text("acceleration_z: "+sensor.acceleration_z)
            Text("rotation_x: "+sensor.rotation_x)
            Text("rotation_y: "+sensor.rotation_y)
            Text("rotation_z: "+sensor.rotation_z)
            Text("attitude_pitch: "+sensor.attitude_pitch)
            Text("attitude_roll: "+sensor.attitude_roll)
            Text("attitude_yaw: "+sensor.attitude_yaw)
            
            Button(action: {
                self.sensor.isStarted ? self.sensor.stop(): self.sensor.start()
                }) {
                self.sensor.isStarted ? Text("STOP") : Text("START")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
