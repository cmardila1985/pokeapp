//
//  Login.swift
//  pockeApp
//
//  Created by cristian manuel ardila troches on 2/05/23.
//


import SwiftUI

struct Login: View {
    
    @ObservedObject  var loginVM =  RequestUser()
    @State var isLogin = false
    @State var isAnyError = false
    @State var  loginText1 = NSLocalizedString("login_text1", comment: "")
    @State private var name = ""
    @FocusState private var nameIsFocused: Bool
    @Binding var linkView2 : linkedView
    @Environment(\.colorScheme) var colorScheme
    let  loginText13 = NSLocalizedString("login_text13", comment: "")
    let  loginText14 = NSLocalizedString("login_text14", comment: "")
   // @Published var isLogin : Bool = false //To show the loading screen while the request is working
   // @Published var registedSuccesfly : Bool = false // To Know if the result of the request is OK
    
    var body: some View {
            ZStack{
                 //Color("BackGround")
                    //Image("rectangleLogin").resizable().frame(width: .infinity, height: 220).offset(x: 0, y: 220)
                VStack{
                    if colorScheme != .light{
                        Image("icon-60").resizable().frame(width: 80, height: 80, alignment: .center).padding(.top,5)
                    }else{
                        Image("icon-60").resizable().frame(width: 80, height: 80, alignment: .center).padding(.top,5)
                    }
                    VStack{
                        Text(loginText13).font(.custom("Poppins-Bold", size: 27.0)).foregroundColor(Color("ColorTitleRegister"))
                        Text(loginText14).font(.custom("Poppins-Bold", size: 35.0)).foregroundColor(Color("ColorTitleRegister"))
                    }.padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                    FormularyLogin( loginVM: self.loginVM,
                                    showingAlert: $isAnyError, isRegistedSuccesly: $isLogin,textAlert: $loginText1, linkView: $linkView2
                    ).padding(EdgeInsets(top: 2, leading: 27, bottom: 30, trailing: 27)).alert(isPresented: $isAnyError) {
                        Alert(title: Text("Error"), message: Text(loginText1), dismissButton: .default(Text("Ok")))
                    }
                    //DownTextRegister(link: $linkView2)
                }
                
                if(loginVM.isLogin){
                    ZStack{
                        //LoadingView()
                    }.onDisappear(){
                        
                        if loginVM.registedSuccesfly! == false{
                            isAnyError=true
                        }
                        else{
                            isLogin=loginVM.registedSuccesfly!
                        }
                        
                    }
                }
               
                /*NavigationLink(destination: SendEmail(link: $linkView2),
                               isActive: $isLogin,
                               label: {
                    EmptyView()
                })*/
                
            }.ignoresSafeArea()
                .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true).navigationViewStyle(.stack)
    }
}

struct FormularyLogin : View {
    @ObservedObject var loginVM : RequestUser
    @State var userMail = ""
    @State var userPsswrd = ""
    @Binding var showingAlert : Bool
    @Binding var isRegistedSuccesly : Bool
    @Binding var textAlert : String
    @Binding var linkView : linkedView
    @State var isLogin = false
    
    let  loginText2 = NSLocalizedString("login_text2", comment: "")
    let  loginText3 = NSLocalizedString("login_text3", comment: "")
    let  loginText4 = NSLocalizedString("login_text4", comment: "")
    let  loginText5 = NSLocalizedString("login_text5", comment: "")
    let  loginText6 = NSLocalizedString("login_text6", comment: "")
    let  loginText7 = NSLocalizedString("login_text7", comment: "")
    let  loginText8 = NSLocalizedString("login_text8", comment: "")
    let  loginText9 = NSLocalizedString("login_text9", comment: "")
    @State var isOn1 = false
    @State var isOn2 = false
    
    var body: some View{
       
            VStack{
                
                NavigationLink(destination: NavigationMenu(link: $linkView),
                               isActive: $isLogin,
                               label: {
                    EmptyView()
                })
                
                EditableTextFieldUser(descriptionText: Text(loginText2),
                                      placeholder: Text(loginText3).foregroundColor(Color("MonochromeDark")), text: $userMail).padding(.top,30).keyboardType(.emailAddress)
                    
                
                EditableSecureFieldPassw(descriptionText: Text(loginText4), placeholder: Text(loginText5).foregroundColor(Color("MonochromeDark")), text: $userPsswrd)
               
                Toggle("Recordar", isOn: $isOn1)
                  .toggleStyle(CheckboxToggleStyle(style: .square))
                  .foregroundColor(.blue)

                /*Toggle("Checkbox 2", isOn: $isOn2)
                  .toggleStyle(CheckboxToggleStyle(style: .circle))
                  .foregroundColor(.red)*/
                 
                
                Button(action: {
                    loginUser()
                    print("AQUI ES CLICKSITO ====>>>")
                    isLogin = true
                }, label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color("BlueLink"))
                        Text(loginText6).font(.custom("Poppins-Bold", size: 14.0)).foregroundColor(Color("ButtonTextSesion"))
                    }.frame(width: .infinity, height: 40)
                    
                }).padding(EdgeInsets(top: 0, leading: 20, bottom: 33, trailing: 20))
            }.background(Color("BackGround")).cornerRadius(7)
        
            
    }
    
    func loginUser(){
        
        /*loginVM.login(email: "tes001@eco.com", password: "TES001", remember: true, callback: { (response) in
           
           if response.error != nil {
               print("Error took place \(String(describing: response.error))")
               return
           }
           
           guard let dataFromService = response.data,
                 let model : ResponseLogin = try? JSONDecoder().decode(ResponseLogin.self, from: dataFromService) else {
               return
           }
           
           DispatchQueue.main.async {
              // loginVM.isLogin = false
             print("AQUI LLEGO TODO EL MODELO OIS")
             print(model)
               
           }
       })*/
        
        if !userPsswrd.isEmpty && !userMail.isEmpty {
            
          if textFieldValidatorEmail(userMail){
                if userPsswrd.count > 3{
                     
                    //isLogin = true
                     loginVM.login(email: userMail, password: userPsswrd, remember: true, callback: { (response) in
                        
                        if response.error != nil {
                            print("Error took place \(String(describing: response.error))")
                            return
                        }
                        
                        guard let dataFromService = response.data,
                              let model : ResponseLogin = try? JSONDecoder().decode(ResponseLogin.self, from: dataFromService) else {
                            return
                        }
                        
                        DispatchQueue.main.async {
                            
                            print(model)
                            if (model.statusCode == 200){
                                let defaults = UserDefaults.standard
                                
                                defaults.set(model.userId ?? $userMail,
                                             forKey: Constants.DefaultsKeys.userId)

                                defaults.set(model.email ?? $userMail,
                                             forKey: Constants.DefaultsKeys.userMail)
                                
                                defaults.set(model.userId ?? $userMail,
                                             forKey: Constants.DefaultsKeys.userId)
                                
                                defaults.set(model.token,forKey: Constants.DefaultsKeys.userToken)
                                
                                defaults.set(model.name ?? "Sin nombre",
                                             forKey: Constants.DefaultsKeys.userName)
                                
                                defaults.set(model.vehicleId ?? 0,
                                             forKey: Constants.DefaultsKeys.vehicleId)
                                
                                defaults.set(true, forKey: Constants.DefaultsKeys.logged)
                                
                                isLogin = true
                                linkView = .navigationMenu
                                loginVM.registedSuccesfly = true
                            
                            }else{
                                textAlert = model.message!
                                userPsswrd = ""
                                showingAlert = true
                                loginVM.registedSuccesfly = false
                            }
                        }
                    })
                }
                else{
                    textAlert = loginText7
                    userPsswrd = ""
                    showingAlert = true
                }
            }
            else{
                textAlert = loginText8
                userMail = ""
                userPsswrd = ""
                showingAlert = true
            }
            
        }else{
            textAlert = loginText9
            showingAlert = true
        }

    }
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}" // short format
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
}

struct DownTextRegister : View {
    @Binding var link:linkedView
    let  loginText10 = NSLocalizedString("login_text10", comment: "")
    let  loginText11 = NSLocalizedString("login_text11", comment: "")
    let  loginText12 = NSLocalizedString("login_text12", comment: "")
    
     
    var body: some View{
        
        HStack{
            Spacer()
            Text(loginText10).font(.custom("Poppins-Regular", size: 15.0)).foregroundColor(Color.white)
            Text(loginText11)
                .font(.custom("Poppins-Regular", size: 15.0))
                .foregroundColor(Color.white)
                .bold()
                .underline().onTapGesture {
                    link = .register
                }
            Spacer()
        }.padding(.bottom,80).frame(height: 55, alignment: .center)
    
        /*Text(loginText10).font(.custom("Poppins-Regular", size: 18.0)).padding(.top,20).foregroundColor(Color("TextDarkest"))
        Button(action: {
            link = .register
        }, label: {
            Text(loginText11)
                .font(.custom("Poppins-Bold", size: 18.0))
                .foregroundColor(Color("BlueLink")).underline()
        }).foregroundColor(.blue).padding(.top,1)*/
        
        
        /*NavigationLink(destination: SendRecoverPassword(link: $link)) {
            Text(loginText12)
                .font(.custom("Poppins-Bold", size: 15.0))
                .foregroundColor(Color.white).underline()
            
            
            
        }.foregroundColor(.blue).padding(.top,-60).onTapGesture(){
            link = .sendRecoverPassword
        }*/
    }
    
}

//Struc that keeps modify a TextField
struct EditableTextFieldUser: View {
    var descriptionText: Text
    var placeholder: Text
    @State var isFocusedText = false
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in}
    var commit: ()->() = { }
    
    var body: some View {
        VStack(spacing : 5){
            descriptionText.font(.custom("Poppins-ExtraBold", size: 14.0)).foregroundColor(isFocusedText ? Color("TextFieldSelected"):Color("TextField")).frame(maxWidth : .infinity,alignment: .leading)
            ZStack(alignment: .leading) {

                if text.isEmpty { placeholder.padding(.leading,20).font(.custom("Poppins-Regular", size: 13.0)) }
                TextField("", text: $text,  onEditingChanged: { (editingChanged) in
                    if editingChanged {
                        isFocusedText = true
                    } else {
                        isFocusedText = false
                    }
                }, onCommit: commit).font(.custom("Poppins-Regular", size: 13.0)).padding(EdgeInsets(top:
                                                        11, leading: 20, bottom: 11, trailing: 20)).overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(isFocusedText ? Color("TextFieldSelected"):Color("TextField"), lineWidth: 1)
                )
            }.background(Color("BackGroundFields")).cornerRadius(7)
            Divider().frame( height: 1, alignment: .center).background(isFocusedText ? .black:Color("MonochromeDark")).padding(.top,10).opacity(0)
        }.padding(.horizontal, 22.0)
    }
}

//OnlyWorksInSimulatorNotInPreview
struct EditableSecureFieldPassw: View {
    var descriptionText: Text
    var placeholder: Text
    @Binding var text: String
    @FocusState var isInFocus: Bool
    var editingChanged: (Bool)->() = { _ in}
    var commit: ()->() = { }
    
    var body: some View {
        VStack(spacing : 5){
            descriptionText.font(.custom("Poppins-ExtraBold", size: 14.0)).foregroundColor(isInFocus ? Color("TextFieldSelected"):Color("TextField")).frame(maxWidth : .infinity,alignment: .leading)
            ZStack(alignment: .leading) {
                if text.isEmpty { placeholder.padding(.leading,20).font(.custom("Poppins-Regular", size: 13.0)) }
                SecureField("", text: $text, onCommit: { isInFocus = false }).font(.custom("Poppins-Regular", size: 13.0)).focused($isInFocus).padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)).overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(isInFocus ? Color("TextFieldSelected"):Color("TextField"), lineWidth: 1))
            }.background(Color("BackGroundFields")).cornerRadius(7)
            Divider().frame( height: 1, alignment: .center).background(isInFocus ? Color("MonochromeDark"):.white).padding(.top,10).opacity(0)
        }.padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
    }
}

extension UserDefaults {
  func setCodableObject<T: Codable>(_ data: T?, forKey defaultName: String) {
    let encoded = try? JSONEncoder().encode(data)
    set(encoded, forKey: defaultName)
  }
}

struct CheckboxToggleStyle: ToggleStyle {
  @Environment(\.isEnabled) var isEnabled
  let style: Style // custom param

  func makeBody(configuration: Configuration) -> some View {
    Button(action: {
      configuration.isOn.toggle() // toggle the state binding
    }, label: {
      HStack {
        Image(systemName: configuration.isOn ? "checkmark.\(style.sfSymbolName).fill" : style.sfSymbolName)
          .imageScale(.large)
        configuration.label
      }
    })
    .buttonStyle(PlainButtonStyle()) // remove any implicit styling from the button
    .disabled(!isEnabled)
  }

  enum Style {
    case square, circle

    var sfSymbolName: String {
      switch self {
      case .square:
        return "square"
      case .circle:
        return "circle"
      }
    }
  }
}


