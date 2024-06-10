//
//  RegisterView.swift
//  Vinoble
//
//  Created by won on 6/9/24.
//

import SwiftUI

struct RegisterView: View {
    @State private var id = ""
    @State private var password = ""
    @State private var passwordcheck = ""

    var body: some View {
        
        NavigationView { // NavigationView로 감싸기
            ZStack {
                Image("vinoble") // Assets Catalog에 추가된 이미지 이름
                    .resizable()
                    .scaledToFit()
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: 10) // 블러 효과 적용
                    .opacity(0.3)
                
                VStack {
                    Text("VINOBLE")
                        .font(.system(size: 50, design: .serif))
                        .foregroundStyle(.theme)
                        .padding(.bottom, 50)
                    
                    Text("Register")
                        .font(.system(.title, design: .serif))
                        .foregroundStyle(.theme)
                    
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 30)
                    
                    Text("ID")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("ID", text: $id)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray.opacity(0.2))
                        )
                        .padding(.bottom, 20)
                    
                    Text("Password")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray.opacity(0.2))
                        )
                        .padding(.bottom, 10)
                    
                    SecureField("Password Check", text: $passwordcheck)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray.opacity(0.2))
                        )
                        .padding(.bottom, 50)
                    
                    
                    Button(action: {
                        // 로그인 로직 처리
                    }) {
                        Text("Register")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.theme)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                }
                .padding(.leading, 60)
                .padding(.trailing, 60)
                .padding(.bottom, 70)
            }
        }
    }
}

#Preview {
    RegisterView()
}
