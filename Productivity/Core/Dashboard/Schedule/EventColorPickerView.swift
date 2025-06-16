//
//  EventColorPickerView.swift
//  Productivity
//
//  Created by Khi Kidman on 6/15/25.
//

import SwiftUI

struct EventColorPickerView: View {
    @Binding var selectedColor: Color

    var body: some View {
            ColorPicker("", selection: $selectedColor, supportsOpacity: false)
                .padding(.vertical, 8)
    }
}
