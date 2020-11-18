//
//  ContentView.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 11/17/20.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var quickActionSettings: QuickActionSettings
	@State private var showCheckInView = false
	
    var body: some View {
		NavigationView {
			List {
				Section {
					Text("Ridden Coasters")
					Text("Visited Parks")
					Text("Visited States")
					Text("Visited Countries")
				}
				Section {
					NavigationLink(destination: AboutView()) {
						Text("About")
					}
					NavigationLink(destination: LicenseView())
					{
						Text("License")
					}
				}
			}
			.navigationTitle("My Coaster Tracker")
			.navigationBarItems(trailing: Button(action: {
				self.showCheckInView.toggle()
			}, label: {
				Text("Check In")
			}).sheet(isPresented: $showCheckInView, content: {
				CheckInView(showSheetView: self.$showCheckInView)
			}))
			.listStyle(GroupedListStyle())
			.onChange(of: quickActionSettings.wasTapped, perform: { value in
				if value == true {
					self.showCheckInView.toggle()
				}
			})
		}
	}
}

struct AboutView: View {
	@State var showCheckInView = false

	var body: some View {
		VStack {
			Text("My Coaster Tracker")
				.font(.largeTitle)
			Image(decorative: "rollercoaster-trans")
				.resizable()
				.scaledToFit()
			Text("Copyright © 2020 David A. Frischknecht")
		}
		.navigationTitle("About")
		.navigationBarItems(trailing: Button(action: {
			self.showCheckInView.toggle()
		}, label: {
			Text("Check In")
		}).sheet(isPresented: $showCheckInView, content: {
			CheckInView(showSheetView: self.$showCheckInView)
		}))
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
    }
}
