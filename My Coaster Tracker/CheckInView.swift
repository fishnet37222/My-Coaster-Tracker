//
//  CheckInView.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 11/18/20.
//

import SwiftUI

struct CheckInView: View {
	@Binding var showSheetView: Bool
	
    var body: some View {
		NavigationView {
			Text("Check In")
				.navigationTitle("Check In")
				.navigationBarTitleDisplayMode(.inline)
				.navigationBarItems(leading: Button(action: {
					self.showSheetView = false
				}, label: {
					Text("Cancel")
				}), trailing: Button(action: {
					self.showSheetView = false
				}, label: {
					Text("Done")
				}))
		}
    }
}

struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
		CheckInView(showSheetView: Binding<Bool>.constant(true))
    }
}
