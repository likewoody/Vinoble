//
//  ProfileView.swift
//  Vinoble
//
//  Created by won on 6/10/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var id = ""
    @State private var password = ""

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
                    
                    Text("Profile")
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
                        .padding(.bottom, 50)
                                        
                    Button(action: {
                        // 로그아웃 로직 처리
                    }) {
                        Text("SignOut")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.theme)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 10)
                    
                    Button(action: {
                        // 개인정보 수정 로직 처리
                    }) {
                        Text("Edit Profile")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.theme)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 10)
                    
                }
                .padding(.leading, 60)
                .padding(.trailing, 60)
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    ProfileView()
}
