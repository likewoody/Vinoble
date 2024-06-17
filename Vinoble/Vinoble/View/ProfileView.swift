//
//  ProfileView.swift
//  Vinoble
//
//  Created by won on 6/10/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var id = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    @State private var password = ""
    @State private var result = false
    @State private var isValidPw = true // 패스워드 정규식에 맞는지에 대한 변수
    @FocusState private var isFocused: Bool // 키보드를 내릴때 필요한 상태 변수
    let documentId = UserDefaults.standard.string(forKey: "documentId") ?? ""

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
                    
                    TextField("", text: $id)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray.opacity(0.2))
                        )
                        .padding(.bottom, 20)
                        .focused($isFocused)
                        .textInputAutocapitalization(.never) // 자동 대문자 비활성화
                        .disabled(true) // 수정불가
                    
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
                        .onChange(of: password) { oldValue, newValue in
                            let regEx = RegularExpression()
                            self.isValidPw = regEx.isValidPwFunc(newValue)
                            if password.isEmpty{
                                isValidPw = true
                            }
                        }
                        .overlay(
                            isValidPw ?
                            nil : Text("   Password must be at least 8 characters long and contain at least one letter and one number")
                                .font(.caption)
                                .foregroundColor(.red.opacity(0.8))
                                .padding(.top, 5), // 위쪽 여백 추가
                            alignment: .bottomLeading // 아래 왼쪽에 위치
                        )

                    Button(action: {
                        // 비밀번호 수정 로직 처리
                        Task{
                            let userInsert = UserInsert(result: $result)
                            result = try await userInsert.updatePw(documentId: documentId, userpw: password)
                        }
                        
                    }) {
                        Text("Update Password")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.theme)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 10)
                    
                    Button(action: {
                        // 회원탈퇴 수정 로직 처리
                    }) {
                        Text("SignOut")
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
