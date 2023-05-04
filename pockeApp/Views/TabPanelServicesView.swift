//
//  TabPanelServicesView.swift
//  pockeApp
//
//  Created by cristian manuel ardila troches on 1/05/23.
//


import AlertToast
import SwiftUI

struct TabPanelServicesView: View {
    @StateObject var manager: DataManager = DataManager()
 
   // @ObservedObject  var requestUser =  RequestUser()
  
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.colorScheme) var colorScheme
  
    @Binding var show : Bool
    @Binding var showToolbar : Bool
    @State var preselectedIndex = 0
    @State var menuBusiness : Bool = false
    @Binding var currentView : String
    
    init(showToolbar: Binding<Bool>, show: Binding<Bool>, currentView : Binding<String>, manager: StateObject<DataManager>) {
        
        self._show = show
        self._showToolbar = showToolbar
        self._show = show
        self._currentView = currentView
        self._manager = manager
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("ColorToolbarTabPanel"))
        UISegmentedControl.appearance().setWidth(300, forSegmentAt: 1)
        UISegmentedControl.appearance().layer.cornerRadius = 0;
        
    }

    var body: some View {
        NavigationView{
            
            ZStack{
                VStack {
                    ZStack{
                        HStack{
                           Rectangle().fill(Color("ColorToolbarTabPanel")).frame(width: .infinity, height: 50, alignment: .center)
                        }
                    Text("list_services_text1").font(.custom("Poppins-Bold", size: 25.0))
                        .frame(width: .infinity, height: .infinity, alignment: .center)
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .foregroundColor(Color.white)
                 
                        ListServicesView(
                            showToolbar: $showToolbar,
                            show: $show,
                         //   link: $link,
                            currentView: $currentView
                        ).environmentObject(manager)
                            .environment(\.managedObjectContext, manager.container.viewContext)
                       // MyCompaniesListView(showToolbar: $showToolbar, show: $show, menuBusiness: $menuBusiness)
                     
                    CustomSegmentedControl(preselectedIndex: $preselectedIndex, menuBusiness: $menuBusiness)
                        .padding(.bottom, -11)
                    
                }.background(Color("ColorToolbarTabPanel"))
                Spacer()
                
            }.onAppear(){
             
            }.navigationBarHidden(true)
        }.navigationBarBackButtonHidden(true).navigationViewStyle(.stack)
        
    }
}

struct CustomSegmentedControl: View {
    @Binding var preselectedIndex: Int
    @Binding var menuBusiness : Bool
   // @Binding var relatedCompanies : [RelatedCompanies]
   // var options: [String]
    let color = Color.red
    @State var collapsed: Bool = true
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 0) {
            let isSelected = preselectedIndex
            ZStack {
               // Rectangle().fill(Color("BackGroundFields"))
                RoundedCorners(color: Color("ColorToolbarTabPanel"), tl: 0, tr: 0, bl: 0, br: 0)
                //.border(width: 1, edges: [.top], color: .blue)
                .padding(0)
                .opacity(isSelected == 0 ? 1 : 0.01)
                .onTapGesture {
                    withAnimation(.interactiveSpring(response: 0.2, dampingFraction: 2, blendDuration: 0.1)) {
                        preselectedIndex = 0
                    }
                }
                
                if colorScheme == .light{
                    
                    Text("")
                        .font(.custom("Poppins-Bold", size: 15.0))
                        .foregroundColor(isSelected == 1 ? Color.white :  Color.red)
                    
                }else{
                    
                    Text("")
                        .font(.custom("Poppins-Bold", size: 15.0))
                        .foregroundColor(isSelected == 0 ? Color.red :  Color.white)
                        // .foregroundColor(isSelected == 0 ? Color("NewContractButton") : Color.white)
                    
                }
                
            }
            
        }
        .frame(height: 50)
        .cornerRadius(0)
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
        
        //
    }
}
 
struct EdgeBorder: Shape {

    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

struct RoundedCorners: View {
    var color: Color = .blue
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                
                let w = geometry.size.width
                let h = geometry.size.height

                // Make sure we do not exceed the size of the rectangle
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)
                
                
                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
                path.closeSubpath()
            }
            .fill(self.color)
        }
    }
}
 
extension UserDefaults {
  func codableObject<T : Codable>(dataType: T.Type, key: String) -> T? {
    guard let userDefaultData = data(forKey: key) else {
      return nil
    }
    return try? JSONDecoder().decode(T.self, from: userDefaultData)
  }
}

