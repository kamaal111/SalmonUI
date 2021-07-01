//
//  KFloatingTextField.swift
//  SalmonUI
//
//  Created by Kamaal Farah on 01/07/2021.
//

import SwiftUI

public struct KFloatingTextField: View {
    @Binding public var text: String

    public let title: String
    public let textFieldType: TextFieldType
    public let onEditingChanged: (_ changed: Bool) -> Void
    public let onCommit: () -> Void

    public init(
        text: Binding<String>,
        title: String,
        textFieldType: TextFieldType = .text,
        onEditingChanged: @escaping (_ changed: Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = { }) {
        self._text = text
        self.title = title
        self.textFieldType = textFieldType
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }

    public enum TextFieldType {
        case text
        case decimals
        case numbers

        #if canImport(UIKit)
        var keyboardType: UIKeyboardType {
            switch self {
            case .decimals: return .decimalPad
            case .numbers: return .numberPad
            case .text: return .default
            }
        }
        #endif
    }

    public var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(textColor)
                .offset(y: $text.wrappedValue.isEmpty ? 0 : -25)
                .scaleEffect($text.wrappedValue.isEmpty ? 1 : 0.75, anchor: .leading)
                .padding(.horizontal, titleHorizontalPadding)
            #if canImport(UIKit)
            TextField("", text: $text, onEditingChanged: onEditingChanged, onCommit: onCommit)
                .keyboardType(textFieldType.keyboardType)
            #else
            TextField(title, text: $text, onEditingChanged: onEditingChanged, onCommit: onCommit)
            #endif
        }
        .padding(.top, 12)
        .animation(.spring(response: 0.5))
    }

    private var textColor: Color {
        if $text.wrappedValue.isEmpty {
            return .secondary
        }
        return .accentColor
    }

    private var titleHorizontalPadding: CGFloat {
        if $text.wrappedValue.isEmpty {
            return 4
        }
        return 0
    }
}

struct KFloatingTextField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            KFloatingTextField(text: .constant(""), title: "Tile")
                .previewLayout(.sizeThatFits)
                .padding(.vertical, 20)
            KFloatingTextField(text: .constant(""), title: "Tile")
                .previewLayout(.sizeThatFits)
                .padding(.vertical, 20)
                .colorScheme(.dark)
                .background(Color.black)
        }
    }
}
