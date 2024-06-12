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
    @FocusState private var isFocused: Bool // 키보드를 내릴때 필요한 상태 변수

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
                    
                    Text("Email")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("Email", text: $id)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray.opacity(0.2))
                        )
                        .padding(.bottom, 20)
                        .focused($isFocused)
                        .textInputAutocapitalization(.never) // 자동 대문자 비활성화
                    
                    Text("Password")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray.opacity(0.2))
                        )
                        .padding(.bottom, 50)
                        .focused($isFocused)
                                        
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
            } // ZStack
            .onTapGesture {
                isFocused = false // 탭하면 포커스 해제
            }
        }
    }
}

#Preview {
    ProfileView()
}
