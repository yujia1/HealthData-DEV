//
//  AuthView.swift
//  HealthData-DEV
//
//  Created by Yu Jia on 9/11/22.
//

import SwiftUI
import Firebase

struct AuthView: View {
    @State private var email = ""
    @State private var passwod = ""
    @State private var userIsLoggedIn = false
    
    var body: some View {
        if userIsLoggedIn {
            // go somewhere
            //ContentView(store: store)
            ListView()
        } else {
           content
        }
       
    }
    var content: some View {
        VStack {
            //header section
            VStack(alignment: .leading) {
                HStack{Spacer()}
                Text("Welcome")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Text("Health App")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
            .frame(height: 260)
            .padding(.leading)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedShap(corner: [.bottomRight]))
            // login info section
            VStack(spacing:40){
                HStack{
                    Image(systemName: "envelope.badge")
                        .padding(.trailing,1)
                    TextField("Email", text:$email)
                }
                HStack {
                    Image(systemName: "lock")
                        .padding(.trailing,1)
                    TextField("Password", text: $passwod)
                }
            }
            .padding(.horizontal,32)
            .padding(.top, 44)
            // reset password section
            HStack {
                Spacer()
                NavigationLink{
//                    ForgotPasswordView()
//                        .navigationBarHidden(true)
                }label: {
                    Text("Forgot Password?")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.top)
                        .padding(.trailing, 24)
                }
            }
            // log in function
            Button {
                login()
            } label: {
                Text("Log in")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 340, height: 50)
                    .background(.blue)
                    .cornerRadius(20)
                    .padding()
                    
            }.shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 0)
            
            Spacer()
            
            // sign up footer
            Button{
                register()
            }label: {
                HStack{
                    Text("Don't have an account?")
                        .font(.footnote)
                    Text("Sign Up")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                }
            }
            .padding(.bottom, 32)
            .foregroundColor(.blue)
            
        }
        .onAppear{
            Auth.auth().addStateDidChangeListener{
                auth, user in
                if user != nil {
                    userIsLoggedIn.toggle()
                }
            }
        }
        .ignoresSafeArea()
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: passwod) {
            result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: passwod) {
            result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
}

