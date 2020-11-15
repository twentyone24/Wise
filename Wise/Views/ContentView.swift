//
//  ContentView.swift
//  Wise
//
//  Created by NAVEEN MADHAN on 11/9/20.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @AppStorage("log_Status") var status = false
    var body: some View {

        ZStack{
            
            if status{
                
                Home()
            }
            else{
                
                NavigationView{
                    
                    Login()
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
