//
//  LoginView.swift
//  Vinoble
//
//  Created by won on 6/9/24.
//
import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    @State private var id = ""
    @State private var password = ""
    @State var result: Bool = false // Firebase Query Request가 완료 됬는지 확인하는 상태 변수
    @State private var showAlert = false // Alert 표시 여부를 관리하는 상태 변수
    @State private var errorMessage: String = "" // Alert창의 메세지를 저장할 상태 변수
    @State private var isLoggedIn = false // 로그인 성공 여부를 저장할 상태 변수
    @FocusState private var isFocused: Bool // 키보드를 내릴때 필요한 상태 변수
    
    var body: some View {
        
        NavigationStack { // NavigationStack으로 감싸기
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
                    
                    Text("Login")
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
                        .padding(.bottom, 10)
                        .focused($isFocused)
                    
//                    NavigationLink(destination: ProfileView()) {
                        Text("Forgot Password?")
                            .frame(alignment: .leading)
                            .foregroundStyle(.blue)
//                    }
                    .padding(.bottom, 50)
                    
                    Button {
                        // 로그인 로직
                        Task{
                            let userQuery = UserQuery(result: $result)
                            let userInfo = try await userQuery.fetchUserInfo(userid: id, userpw: password)

                            if result {
                                // firebase request 성공
                                if userInfo.documentId.isEmpty{
                                    // id, pw 잘못 입력
                                    self.showAlert = true
                                    self.errorMessage = "Please Check your ID or password"
                                }else{
                                    // id, pw 제대로 입력
                                    self.isLoggedIn = true
                                    UserDefaults.standard.set(id, forKey: "userEmail")
                                    UserDefaults.standard.set(userInfo.documentId, forKey: "documentId")
                                }
                            }else{
                                // firebase request 실패
                                self.showAlert = true
                                self.errorMessage = "Failed to connect to the server"
                            }
                            
                        } // Task
                        
                    } label: {
                        Text("Log In")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.theme)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                    .alert("Login Failed", isPresented: $showAlert) {               Button("OK") {
                            showAlert = false // OK 버튼 클릭 시 Alert 닫기
                        }
                    } message: {
                        Text(errorMessage) // Alert 메시지
                    }
                    .navigationDestination(isPresented: $isLoggedIn) { // Bool 값에 대한 목적지 뷰 설정
                        MainTabView(store: Store(initialState: ProductFeature.State()){
                            ProductFeature()
                        }, noteStore: Store(initialState: TastingNoteFeature.State()){
                            TastingNoteFeature()
                        })
                        .navigationBarBackButtonHidden(true)
                    }
                    
                    
                    VStack {
                        Text("Don't have an account yet?")
                        // 회원가입 화면으로 이동
                        NavigationLink(destination: RegisterView()) {
                            Text("Register for free")
                        }
                    }

                } // VStack
                .padding(.leading, 60)
                .padding(.trailing, 60)
                .padding(.bottom, 50)
                                
            } // ZStack
            .onTapGesture {
                isFocused = false // 탭하면 포커스 해제
            }

        } // NavigationStack

    } // View
    
} // struct LoginView

#Preview {
    LoginView()
}
