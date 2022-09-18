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
            Text("x: "+sensor.x)
            Text("y: "+sensor.y)
            Text("z: "+sensor.z)
            
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
