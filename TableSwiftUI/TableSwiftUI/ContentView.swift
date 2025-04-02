
//  ContentView.swift
//  TableSwiftUI
//
//  Created by Lewallen, Mandalyn E on 3/31/25.
//

import SwiftUI
import MapKit

let data = [
    Item(name: "The Avenue", neighborhood: "1111 Avalon Avenue", desc: "A student-oriented apartment community offering fully furnished units with modern amenities. Residents can enjoy a large fitness center, tanning beds, a resort-style pool, basketball and sand volleyball courts, and a yoga studio. Additional features include a movie theater, golf simulator, game room with pool tables, and a cyber café with computer labs. The complex is conveniently situated near Texas State University, providing easy access to campus via the Bobcat Tram Route.", lat: 29.907182, long: -97.899727, imageName: "image1", rating: 2),
    Item(name: "The Thompson", neighborhood: "1655 Mill Street", desc: "A student-focused apartment community in San Marcos, Texas, offering fully furnished 4-bedroom flats and townhomes. Each unit features private bedrooms and bathrooms, full-sized kitchens with stainless steel appliances, and private patios or balconies. Residents can enjoy amenities such as a beach-entry swimming pool with sun cabanas, a fitness center, a volleyball court, a 24-hour clubhouse with a coffee bar, and a tech center with iMac computers and free printing.", lat:  29.8992, long: -97.9147, imageName: "image2", rating: 4),
    Item(name: "The Retreat", neighborhood: "512 Craddock Avenue", desc: "The Retreat at San Marcos is a student-focused housing community offering fully furnished 2, 3, 4, and 5 bedroom cottages near Texas State University. Each unit features private bedrooms and bathrooms, stainless steel appliances, granite countertops, and hardwood-style flooring. Residents can enjoy amenities such as a state-of-the-art fitness center, recreation center with billiards and foosball, swimming pool with spa and sun deck, basketball and sand volleyball courts, and a golf simulator. The community is conveniently located on the Bobcat Tram Bus Route, providing easy access to campus.", lat:  29.8935, long:  -97.9630, imageName: "image3", rating: 4),
    Item(name: "Sadler House Apartments", neighborhood: "1271 Sadler Drive", desc: "A modern apartment community that offers 1 and 2 bedroom units ranging from 674-1,126 square feet. Each apartment features high ceilings, stainless steel appliances, granite countertops, and full-size washer and dryer units. Residents can enjoy amenities such as a swimming pool with a sundeck, a fitness center, a dog park with a pet hydration station, and a playground. The community is conveniently located near grade schools. Additionally, offers easy access to local shopping centers and parks.", lat: 29.8505, long: -97.9497, imageName: "image4", rating: 5),
    Item(name: "Treehouse Apartments", neighborhood: "800 N LBJ Drive", desc: "Offers one and two bedroom units ranging from 413-770 square feet. Each apartment features custom cabinetry, a kitchen appliance package, and faux hardwood flooring in common living areas. Furnished options are available, including a bed frame and mattress, desk, chair, dresser, nightstand, couch, coffee table, end table, and entertainment stand. Residents can enjoy amenities such as a sparkling swimming pool, picnic area with grills, and a 24 hour on-site clothes care facility. The community is conveniently located within walking distance to campus, local eateries, and the San Marcos River.", lat: 29.8832, long: -97.9402, imageName: "image5", rating: 3)
]


struct Item: Identifiable {
    let id = UUID()
    let name: String
    let neighborhood: String
    let desc: String
    let lat: Double
    let long: Double
    let imageName: String
    var rating: Int
}

struct ContentView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 29.8832, longitude: -97.9402), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    ForEach(data, id: \.name) { item in
                        NavigationLink(destination: DetailView(item: item)) {
                            HStack {
                                Image(item.imageName)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(10)
                                
                                VStack(alignment: .leading) {
                                    
                                    Text(item.name)
                                        .font(.headline)
                                        .lineLimit(1)
                                        .foregroundColor(.black)
                                    
                                    Text(item.neighborhood)
                                        .font(.subheadline)
                                        .foregroundColor(Color.purple)
                                        .lineLimit(1)
                                }
                                .padding(.leading, 10)
                                
                                Spacer()
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(radius: 5))
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                        }
                    }
                }
                
                // Map view below the cards
                Map(coordinateRegion: $region, annotationItems: data) { item in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.purple)
                            .font(.title)
                            .overlay(
                                Text(item.name)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: true, vertical: false)
                                    .offset(y: 25)
                            )
                    }
                }
                .frame(height: 250)
            }
            .navigationTitle("SMTX Apartments")
        }
    }
}



struct DetailView: View {
    @State private var region: MKCoordinateRegion
    
    init(item: Item) {
        self.item = item
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        ))
    }
    
    let item: Item
    
    var body: some View {
        VStack {
            HStack {
              
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.primary)
                        .padding(.top, 20)
                    
                    Text(item.neighborhood)
                        .font(.subheadline)
                        .foregroundColor(Color.purple)
                        .bold()
                }
                
                Spacer()
                
                
                Image(item.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .cornerRadius(15)
                    .shadow(radius: 10)
            }
            .padding()
            
           
            Text(item.desc)
                .font(.body)
                .padding(10)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 10)
            
            // Displaying rating with stars
            HStack {
                ForEach(1..<6) { star in
                    Image(systemName: star <= item.rating ? "star.fill" : "star")
                        .foregroundColor(star <= item.rating ? .yellow : .gray)
                }
            }
            .font(.title)
            .padding(.bottom, 20)
            
            Spacer()

                        Map(coordinateRegion: $region, annotationItems: [item]) { item in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.purple)
                        .font(.title)
                        .overlay(
                            Text(item.name)
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .fixedSize(horizontal: true, vertical: false)
                                .offset(y: 15)
                        )
                }
            }
            .frame(height: 250)
            .padding(.bottom, -50)
            .padding(.horizontal, -20)
        }
        .padding()
        .background(Color("DetailBackground"))
        .cornerRadius(15)
        .shadow(radius: 10)
       // .navigationTitle(item.name)
        //.navigationBarTitleDisplayMode(.inline)
    }
}



#Preview {
    ContentView()
}
