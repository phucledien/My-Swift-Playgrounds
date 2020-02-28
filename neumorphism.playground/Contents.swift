/// This is a simple example of Neumorphism applied to buttons in SwiftUI
/// As seen on https://twitter.com/dev_jac/status/1228575575171723264
/// This should work straight out of the box, no other files are required
import SwiftUI
import PlaygroundSupport

extension Color {
    static let mainColor = Color(red: 224/255, green: 229/255, blue: 236/255)
    static let mainColorActive = Color(red: 220/255, green: 225/255, blue: 232/255)
    static let grayShadow = Color(red: 163/255, green: 177/255, blue: 198/255)
    static let grayIcon = Color(red: 143/255, green: 157/255, blue: 188/255)
    static let grayActiveIcon = Color(red: 120/255, green: 140/255, blue: 160/255)
}


struct NeumorphismShadow: ViewModifier {
    var top: Color
    var bottom: Color
    /// This is at the same time the radius and the offsets of the shadows is just here so we are able to play with the slider
    var value: CGFloat = 9
    func body(content: Content) -> some View {
        content
            .overlay(Color.clear)
            .shadow(color: self.top, radius: value, x: value, y: value)
            .shadow(color: self.bottom, radius: value, x: -value, y: -value)
    }
    
    static var none = NeumorphismShadow(top: .grayShadow, bottom: .white, value: 0)
    static func simple(value: CGFloat) -> NeumorphismShadow {
        NeumorphismShadow(top: .grayShadow, bottom: .white, value: value)
    }
}

struct MyButtonStyle: ButtonStyle {
    var value: CGFloat
    var radius: CGFloat = 15
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .foregroundColor(.white)
        .colorMultiply(configuration.isPressed ? Color.grayActiveIcon : .grayIcon)
        .background(configuration.isPressed ? Color.mainColorActive : .mainColor)
        .cornerRadius(self.radius)
        .modifier(configuration.isPressed ? NeumorphismShadow.none : .simple(value: self.value))
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        // I didn't like the original animation luckily it can be changed this easily!
        .animation(.easeOut(duration: 0.1))
  }
}

struct ButtonNeu: View {
    var icon: String
    var value: CGFloat
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                // Just ignore the hardcoded values this is just for the quick demo
                .frame(width: 80, height: 80)
                .padding(30)
                
        }
        .background(Color.grayIcon.cornerRadius(15)) // More hardcoded values!
        .buttonStyle(MyButtonStyle(value: self.value))
    }
}

struct ButtonNeuRound: View {
    var icon: String
    var value: CGFloat
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                // Just ignore the hardcoded values this is just for the quick demo
                .frame(width: 80, height: 80)
                .padding(30)
        }
            .background(Color.grayIcon.cornerRadius(90)) // I know there are better ways to make a round button, but this is convinient enough for a quick demo
        .buttonStyle(MyButtonStyle(value: self.value, radius: 90))
    }
}

struct ContentView: View {
    @State var value: CGFloat = 9
    var body: some View {
        ZStack {
            Color.mainColor
            VStack(spacing: 40) {
                HStack(spacing: 40) {
                    ButtonNeu(icon: "heart.fill", value: self.value) { }
                    ButtonNeuRound(icon: "backward.fill", value: self.value) { }
                }
                Slider(value: self.$value, in: -2...10, step: 0.1)
                    .accentColor(.grayIcon)
                    .modifier( NeumorphismShadow.simple(value: self.value))
                    .padding()
                    .padding()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

PlaygroundPage.current.setLiveView(ContentView())
