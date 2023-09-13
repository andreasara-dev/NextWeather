//
//  MapView.swift
//  NextWeather
//
//  Created by andreasara-dev on 03/08/23.
//

import MapKit
import SwiftUI

struct MapView: View {
    @Binding var userRegion: MKCoordinateRegion
    @State private var tracking: MapUserTrackingMode = .follow
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $userRegion,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: $tracking
            )
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(userRegion: .constant( MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 10), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))))
    }
}
