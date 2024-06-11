////
////  Charts.swift
////  Vinoble
////
////  Created by 이대근 on 6/10/24.
////
//
//
//import SwiftUI
//
//
//let dimensions = [
//    Ray(maxVal: 100, rayCase: .Base),
//    Ray(maxVal: 100, rayCase: .Content),
//    Ray(maxVal: 100, rayCase: .SpeedWeb),
//    Ray(maxVal: 100, rayCase: .SpeedMobile),
//    Ray(maxVal: 100, rayCase: .Social)
//]
//
//let data = [
//    DataPoint(base: 58.9, content: 20.3, speedweb: 91, speedmobile: 56.01, social: 55.6, color: .blue),
//]
//
//
//enum RayCase:String, CaseIterable {
//    case Base = "Base"
//    case Content = "Content"
//    case SpeedWeb = "SpeedWeb"
//    case SpeedMobile = "SpeedMobile"
//    case Social = "Social"
//}
//
//struct DataPoint:Identifiable {
//    var id = UUID()
//    var entrys:[RayEntry]
//    var color:Color
//    
//    init(base:Double, content:Double, speedweb:Double, speedmobile:Double, social:Double, color:Color){
//        self.entrys = [
//            RayEntry(rayCase: .Base, value: base),
//            RayEntry(rayCase: .Content, value: content),
//            RayEntry(rayCase: .SpeedWeb, value: speedweb),
//            RayEntry(rayCase: .SpeedMobile, value: speedmobile),
//            RayEntry(rayCase: .Social, value: social)
//        ]
//        self.color = color
//    }
//}
//
//struct Ray:Identifiable {
//    var id = UUID()
//    var name:String
//    var maxVal:Double
//    var rayCase:RayCase
//    init(maxVal:Double, rayCase:RayCase) {
//        self.rayCase = rayCase
//        self.name = rayCase.rawValue
//        self.maxVal = maxVal
//        
//    }
//}
//
//struct RayEntry{
//    var rayCase:RayCase
//    var value:Double
//}
//
//func deg2rad(_ number: CGFloat) -> CGFloat {
//    return number * .pi / 180
//}
//
//func radAngle_fromFraction(numerator:Int, denominator: Int) -> CGFloat {
//    return deg2rad(360 * (CGFloat((numerator))/CGFloat(denominator)))
//}
//
//func degAngle_fromFraction(numerator:Int, denominator: Int) -> CGFloat {
//    return 360 * (CGFloat((numerator))/CGFloat(denominator))
//    
//}
//
//struct RadarChartView: View {
//    
//    var MainColor:Color
//    var SubtleColor:Color
//    var center:CGPoint
//    var labelWidth:CGFloat = 70
//    var width:CGFloat
//    var quantity_incrementalDividers:Int
//    var dimensions:[Ray]
//    var data:[DataPoint]
//    
//    init(width: CGFloat, MainColor:Color, SubtleColor:Color, quantity_incrementalDividers:Int, dimensions:[Ray], data:[DataPoint]) {
//        self.width = width
//        self.center = CGPoint(x: width/2, y: width/2)
//        self.MainColor = MainColor
//        self.SubtleColor = SubtleColor
//        self.quantity_incrementalDividers = quantity_incrementalDividers
//        self.dimensions = dimensions
//        self.data = data
//    }
//    
//    @State var showLabels = false
//    
//    var body: some View {
//        
//        ZStack{
//            //Main Spokes
//            Path { path in
//                
//                
//                for i in 0..<self.dimensions.count {
//                    let angle = radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
//                    let x = (self.width - (50 + self.labelWidth))/2 * cos(angle)
//                    let y = (self.width - (50 + self.labelWidth))/2 * sin(angle)
//                    path.move(to: center)
//                    path.addLine(to: CGPoint(x: center.x + x, y: center.y + y))
//                }
//                
//            }
//            .stroke(self.MainColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
//            //Labels
//            ForEach(0..<self.dimensions.count){i in
//                
//                Text(self.dimensions[i].rayCase.rawValue)
//                    
//                    .font(.system(size: 10))
//                    .foregroundColor(self.SubtleColor)
//                    .frame(width:self.labelWidth, height:10)
//                    .rotationEffect(.degrees(
//                        (degAngle_fromFraction(numerator: i, denominator: self.dimensions.count) > 90 && degAngle_fromFraction(numerator: i, denominator: self.dimensions.count) < 270) ? 180 : 0
//                        ))
//                    
//                    
//                    .background(Color.clear)
//                    .offset(x: (self.width - (50))/2)
//                    .rotationEffect(.radians(
//                        Double(radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
//                    )))
//            }
//            //Outer Border
//            Path { path in
//                
//                for i in 0..<self.dimensions.count + 1 {
//                    let angle = radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
//                    
//                    let x = (self.width - (50 + self.labelWidth))/2 * cos(angle)
//                    let y = (self.width - (50 + self.labelWidth))/2 * sin(angle)
//                    if i == 0 {
//                        path.move(to: CGPoint(x: center.x + x, y: center.y + y))
//                    } else {
//                        path.addLine(to: CGPoint(x: center.x + x, y: center.y + y))
//                    }
//                    
//                    
//                }
//                
//            }
//            .stroke(self.MainColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
//            
//            //Incremental Dividers
//            ForEach(0..<self.quantity_incrementalDividers){j in
//                Path { path in
//                    
//                    
//                    for i in 0..<self.dimensions.count + 1 {
//                        let angle = radAngle_fromFraction(numerator: i, denominator: self.dimensions.count)
//                        let size = ((self.width - (50 + self.labelWidth))/2) * (CGFloat(j + 1)/CGFloat(self.quantity_incrementalDividers + 1))
//                        
//                        let x = size * cos(angle)
//                        let y = size * sin(angle)
//                        print(size)
//                        print((self.width - (50 + self.labelWidth)))
//                        print("\(x) -- \(y)")
//                        if i == 0 {
//                            path.move(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
//                        } else {
//                            path.addLine(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
//                        }
//                        
//                    }
//                    
//                }
//                .stroke(self.SubtleColor, style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
//                
//                
//            }
//            
//            //Data Polygons
//            ForEach(0..<self.data.count){j -> AnyView in
//                //Create the path
//                let path = Path { path in
//                    
//                    
//                    for i in 0..<self.dimensions.count + 1 {
//                        let thisDimension = self.dimensions[i == self.dimensions.count ? 0 : i]
//                        let maxVal = thisDimension.maxVal
//                        let dataPointVal:Double = {
//                            
//                            for DataPointRay in self.data[j].entrys {
//                                if thisDimension.rayCase == DataPointRay.rayCase {
//                                    return DataPointRay.value
//                                }
//                            }
//                            return 0
//                        }()
//                        let angle = radAngle_fromFraction(numerator: i == self.dimensions.count ? 0 : i, denominator: self.dimensions.count)
//                        let size = ((self.width - (50 + self.labelWidth))/2) * (CGFloat(dataPointVal)/CGFloat(maxVal))
//                        
//                        
//                        let x = size * cos(angle)
//                        let y = size * sin(angle)
//                        print(size)
//                        print((self.width - (50 + self.labelWidth)))
//                        print("\(x) -- \(y)")
//                        if i == 0 {
//                            path.move(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
//                        } else {
//                            path.addLine(to: CGPoint(x: self.center.x + x, y: self.center.y + y))
//                        }
//                        
//                    }
//                    
//                }
//                //Stroke and Fill
//                return AnyView(
//                    ZStack{
//                        path
//                            .stroke(self.data[j].color, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
//                        path
//                            .foregroundColor(self.data[j].color).opacity(0.2)
//                    }
//                )
//                
//                
//            }
//            
//        }.frame(width:width, height:width)
//    }
//}
//
//
//
//struct RadarChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack{
//            Color.black.edgesIgnoringSafeArea(.all)
//            VStack{
//                Text("Final evaluation")
//                    .font(.system(size: 30, weight: .semibold))
//                RadarChartView(
//                    width: 370,
//                    MainColor: Color.init(white: 0.8),
//                    SubtleColor: Color.init(white: 0.6),
//                    quantity_incrementalDividers: 10,
//                    dimensions: dimensions,
//                    data: data
//                )
//                Spacer()
//            }.foregroundColor(.white)
//        }
//    }
//}
//
//
//#Preview {
////    Charts()
//}
