//
//  ActivityEditView.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 16/3/2025.
//

import SwiftUI

struct ActivityEditView: View {
    @Environment(ScreenTimeMonitor.self) var monitor
    @Environment(ScreenTimeSelectAppsModel.self) var model
    @Environment(\.dismiss) private var dismiss
    @State var familyActivityPickerIsPresented: Bool = false
    @State var limitName = ""
    @State private var timeLimitHours = 12
    @State private var timeLimitMinutes = 30
    @State private var timeLimitSeconds = 30
    @State private var notifyBeforeLimit = false
    @State private var notificationMinutesBefore: Int = 5
    
    var body: some View {
        Section {
            TextField("Set a name for this limit", text: $limitName)
            
            VStack(alignment: .leading) {
                Text("Time limit:")
                    .bold()
                HStack {
                    VStack {
                        Picker("Hours limit", selection: $timeLimitHours) {
                            ForEach(Array(stride(from: 0, to: 24, by: 1)), id: \.self) { number in
                                Text("\(number)").tag(number)
                            }
                        }
                        Text("Hours")
                    }
                    .pickerStyle(.wheel)
                    VStack {
                        Picker("Minutes limit", selection: $timeLimitMinutes) {
                            ForEach(Array(stride(from: 0, to: 60, by: 1)), id: \.self) { number in
                                Text("\(number)").tag(number)
                            }
                        }
                        Text("Minutes")
                    }
                    .pickerStyle(.wheel)
                    VStack {
                        Picker("Seconds limit", selection: $timeLimitSeconds) {
                            ForEach(Array(stride(from: 0, to: 60, by: 1)), id: \.self) { number in
                                Text("\(number)").tag(number)
                            }
                        }
                        Text("Seconds")
                    }
                    .pickerStyle(.wheel)
                }
            }
            
            Toggle("Notify before limit", isOn: $notifyBeforeLimit)
            
            Picker("Notify", selection: $notificationMinutesBefore) {
                ForEach([1, 3, 5, 10, 15], id: \.self) { mins in
                    Text("\(mins) min before").tag(mins)
                }
            }
            .disabled(!notifyBeforeLimit)
            
            VStack {
                HStack {
                    Text("Apps selected:")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(model.activitySelection.applicationTokens.count)")
                }
                HStack {
                    Text("Websites selected:")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(model.activitySelection.webDomains.count)")
                }
                HStack {
                    Text("Categories selected:")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("\(model.activitySelection.categories.count)")
                }
                HStack() {
                    Spacer()
                    Button("Select apps") {
                        familyActivityPickerIsPresented = true
                    }
                    .familyActivityPicker(isPresented: $familyActivityPickerIsPresented, selection: Binding(get: {
                        model.activitySelection
                    }, set: { selection in
                        model.activitySelection = selection
                    }))
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle)
                    Spacer()
                }
                .padding(.bottom)
            }
        }
        
        VStack(alignment: .center) {
            Button("Save limit") {
                monitor.setTimeLimit(to: DateComponents(hour: timeLimitHours, minute: timeLimitMinutes, second: timeLimitSeconds))
                monitor.startDailyMonitoring()
                monitor.limitName = limitName
                dismiss()
                // TODO: Add save of notification settings
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
            .controlSize(.extraLarge)
        }
        .frame(maxWidth: .infinity)
        .listRowBackground(Color.clear)
    }
}

#Preview {
    ActivityEditView()
}
