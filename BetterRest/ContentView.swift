//
//  ContentView.swift
//  BetterRest
//
//  Created by Jae Cho on 2/5/22.
//

import SwiftUI
import Foundation


struct ContentView: View {
	@State private var sleepAmount: Double  = 0
	@State private var wakeUp = Date.now
	
	
	
    var body: some View {
		 VStack{
			 Text("Hello, world!")
				  .padding()
			 Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
			 DatePicker("Please enter a date", selection: $wakeUp,in: Date.now... )
				 .labelsHidden()
		 }
    }
	
	func exampleDates(){
		let tomorrow = Date.now.addingTimeInterval(86400)
		let range = Date.now...tomorrow
		
		var components = DateComponents()
		components.hour = 8
		components.minute = 0
		let date = Calendar.current.date(from: components) ?? Date.now
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
			 .previewDevice("iPhone 13 Mini")
    }
}
