//
//  ContentView.swift
//  BetterRest
//
//  Created by Jae Cho on 2/5/22.
//
import CoreML
import SwiftUI



struct ContentView: View {
	@State private var sleepAmount: Double  = 8.0
	@State private var wakeUp = defaultWakeTime
	@State private var coffeeAmount = 1
	@State private var alertTitle = ""
	@State private var alertmessage = ""
	@State private var showingAlert = false
	
	static var defaultWakeTime: Date{
		var components = DateComponents()
		components.hour = 7
		components.minute = 0
		return Calendar.current.date(from: components) ?? Date.now
	}
	
    var body: some View {
		 NavigationView {
			 Form{
				 Section("When do you want to wake up?"){
					 DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
						 .labelsHidden()
						 .onChange(of: wakeUp) { _ in
							 calculateBedtime()
						 }
				 }
				 Section("Desired amount of sleep"){
					 Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
						 .onChange(of: sleepAmount) { _ in
							 calculateBedtime()
						 }
				 }
				 Section("Daily coffee intake"){
					 //Stepper(coffeeAmount == 1 ?"1 cup" : "\(coffeeAmount) cups",value:$coffeeAmount, in: 1...20)
					 Picker(selection: $coffeeAmount) {
						 ForEach(1...10, id: \.self){ numberOfCups in
							 Text(numberOfCups == 1 ? "1 cup" : " \(numberOfCups) cups")
						 }
					 } label: {
						 Text("Daily Coffee Intake")
					 }
					 .pickerStyle(.menu)
					 .onChange(of: coffeeAmount) { _ in
						 calculateBedtime()
					 }

				 }

				 Section("Ideal Bedtime"){
					 Text(alertTitle + alertmessage)
						 .font(.subheadline)
						 .lineLimit(nil)
					 
					 
				 }
			 }
			 .navigationTitle("Better Rest")
//			 .toolbar {
//				 Button("Calculate", action: calculateBedtime)
//			 }
//			 .alert(alertTitle, isPresented: $showingAlert){
//				 Button("OK"){}
//			 }message: {
//				 Text(alertmessage)
//			 }


		 } // NavigationView

    }
	
	func calculateBedtime(){
		do {
			let config = MLModelConfiguration()
			let model = try SleepCalculator(configuration: config)
			
			let components = Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
			let hour = (components.hour ?? 0) * 60 * 60
			let minute = (components.minute ?? 0) * 60
			
			let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
			
			let sleepTime = wakeUp - prediction.actualSleep
			alertTitle = "Your ideal bedtime is..."
			alertmessage = sleepTime.formatted(date: .omitted, time:.shortened)
			print("time is \(alertmessage)")
		}catch{
			alertTitle = "Error"
			alertmessage = "Sorry, there was a problem calculating your bedtime."
			//Something went wrong
		}
		//showingAlert = true
	}
	

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
			 .previewDevice("iPhone 13 Mini")
    }
}
