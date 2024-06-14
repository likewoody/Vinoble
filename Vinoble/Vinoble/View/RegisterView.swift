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
    @State private var result: Bool = true // Firebase Query Request가 완료 됬는지 확인하는 상태 변수
    @State private var passwordcheck = ""
    @State private var isValidEmail = true // 이메일 정규식에 맞는지에 대한 변수
    @State private var isValidPw = true // 이메일 정규식에 맞는지에 대한 변수
    @State private var isCheckPw = true
    @FocusState private var isFocused: Bool // 키보드를 내릴때 필요한 상태 변수
    @Environment(\.dismiss) private var dismiss // Register 버튼을 클릭하면 screen을 pop 하는 상태변수
    @State private var showAlert = false // Alert 표시 여부를 관리하는 상태 변수
//    let userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    
    var body: some View {
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
                
                Text("Email")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("Email", text: $id)
                    .padding()
                    .keyboardType(.emailAddress)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray.opacity(0.2))
                    )
                    .padding(.bottom, 15)
                    .focused($isFocused)
                    .textInputAutocapitalization(.never) // 자동 대문자 비활성화
                    .onChange(of: id) { oldValue, newValue in
                        let regEx = RegularExpression()
                        self.isValidEmail = regEx.isValidEmailFunc(newValue)
                        if id.isEmpty{
                            isValidEmail = true
                        }
                    }
                    .overlay(
                        isValidEmail ?
                        nil : Text("   Please enter a valid email address.")
                            .font(.caption)
                            .foregroundColor(.red.opacity(0.8))
                            .padding(.top, 5), // 위쪽 여백 추가
                        alignment: .bottomLeading // 아래 왼쪽에 위치
                    )

                Text("Password")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray.opacity(0.2))
                    )
                    .padding(.bottom, 30)
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
                
                SecureField("Password Check", text: $passwordcheck)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray.opacity(0.2))
                    )
                    .padding(.bottom, 15)
                    .focused($isFocused)
                    .onChange(of: passwordcheck) { oldValue, newValue in
                        isCheckPw = false
                        if newValue == password || passwordcheck.isEmpty{
                            isCheckPw = true
                        }
                    }
                    .overlay(
                        isCheckPw ?
                        nil : Text("   Please make sure your passwords match")
                            .font(.caption)
                            .foregroundColor(.red.opacity(0.8))
                            .padding(.top, 5), // 위쪽 여백 추가
                        alignment: .bottomLeading // 아래 왼쪽에 위치
                    )
                    .padding(.bottom, 30)
                
                Button(action: {
                    // Register 로직 처리
                    Task{
                        let userQuery = UserQuery(result: $result)
                        
                        let isSameEmail = try await userQuery.checkUserEmail(userid: id)
                        if !isSameEmail {
                            let userInsert = UserInsert(result: $result)
                            let result = try await userInsert.insertUser(userid: id, userpw: password)
                            print(result)
                            dismiss()
                        }else{
                            showAlert = true
                            result = true
                            id = ""
                            password = ""
                            passwordcheck = ""
                        }
                        
                    } // Task
                }) {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(!isValidEmail || id.isEmpty || !isValidPw || password.isEmpty || !isCheckPw || passwordcheck.isEmpty || !result ?
                            .gray : .theme)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!isValidEmail || id.isEmpty || !isValidPw || password.isEmpty || !isCheckPw || passwordcheck.isEmpty || !result) // 버튼 비활성화
                .alert("Register Failed", isPresented: $showAlert) {               Button("OK") {
                        showAlert = false // OK 버튼 클릭 시 Alert 닫기
                    }
                } message: {
                    Text("This email address already exists") // Alert 메시지
                }
                
            } // VStack
            .padding(.leading, 60)
            .padding(.trailing, 60)
            .padding(.bottom, 70)
            
        } // ZStack
        .onTapGesture {
            isFocused = false // 탭하면 포커스 해제
        }
    } // body
    
} // struct RegisterView

#Preview {
    RegisterView()
}
