//
//  HomeView.swift
//  WeatherApp
//
//  Created by ali rahal on 23/06/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            //  MARK: Backround Color
            Color.background
                .ignoresSafeArea()
            
            // MARK: Background Image
            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            // MARK: House Image
            Image("House")
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 257)
            
            // MARK:
            VStack {
                Text("Montreal")
                    .font(.largeTitle)
                VStack {
                    Text("19°" + "\n" + "Mostly Clear")
                    Text("H:24°   L:18°")
                        .font(.title3.weight(.semibold))
                }
                Spacer()
            }
            .padding(.top, 51)
        }
    }
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
