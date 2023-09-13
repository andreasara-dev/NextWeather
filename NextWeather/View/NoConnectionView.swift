//
//  NoConnectionView.swift
//  NextWeather
//
//  Created by andreasara-dev on 11/09/23.
//

import SwiftUI

struct NoConnectionView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "wifi.slash")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.red)
            Text("You're probably offline, please check your internet connection in Settings and retry later.")
                .font(.title2)
                .padding()
                .multilineTextAlignment(.center)
        }
    }
}

struct NoInternetView_Previews: PreviewProvider {
    static var previews: some View {
        NoConnectionView()
    }
}
