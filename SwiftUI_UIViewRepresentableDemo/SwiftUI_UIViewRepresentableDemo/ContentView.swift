//
//  ContentView.swift
//  SwiftUI_UIViewRepresentableDemo
//
//  Created by MACM62 on 22/01/26.
//

import SwiftUI

struct ContentView: View {
    @State private var text: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 50)
            
            HStack {
                Text("Current TextField Entry:- ")
                Text(text)
                Spacer()
            }
            
            HStack {
                Text("SwiftUI: ")
                
                TextField("Type Here...", text: $text)
                    .frame(height: 55)
                    .padding(.horizontal, 10)
                    .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
            }
            
            HStack {
                Text("UIKit: ")
                
                UITextFieldRepresentable(text: $text)
                    .updatePlaceholder(text: "Enter Text Here...")
                    .updatePlaceholderColor(color: .orange)
                    .frame(height: 55)
                    .padding(.horizontal, 10)
                    .background(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
            }
            
            Spacer()
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct UITextFieldRepresentable: UIViewRepresentable {
    @Binding var text: String
    
    var placeholder: String
    var placeholderColor: UIColor
    
    init(text: Binding<String>, placeholder: String = "Type here...", placeholderColor: UIColor = .red) {
        self._text = text
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
    }
    
    //Send Data From UIKit To SwiftUI
    func makeUIView(context: Context) -> UITextField {
        let textField = createNewTextField()
        textField.delegate = context.coordinator
        return textField
    }
    
    //Send Data From SwiftUI To UIKit
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let currentText = textField.text,
               let currentRange = Range(range, in: currentText) {
                let updatedText = currentText.replacingCharacters(in: currentRange, with: string)
                
                print(updatedText)
            }
            
            return true
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
}

extension UITextFieldRepresentable {
    func createNewTextField() -> UITextField {
        let textField: UITextField = UITextField(frame: .zero)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: placeholderColor
        ]
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        
        return textField
    }
    
    func updatePlaceholder(text: String) -> UITextFieldRepresentable {
        var textField = self
        textField.placeholder = text
        return textField
    }
    
    func updatePlaceholderColor(color: UIColor) -> UITextFieldRepresentable {
        var textField = self
        textField.placeholderColor = color
        return textField
    }
}

#Preview {
    ContentView()
}
