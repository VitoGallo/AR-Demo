//
//  ARModelSelectionView.swift
//  AR-Demo
//
//  Created by Vito Gallo on 14/01/24.
//

import SwiftUI

/// A view that allows you to select an AR model
struct ARModelSelectionView: View {
    
    // MARK: - PROPERTIES
    
    /// The ViewModel object for managing the logic of the AR experience
    @ObservedObject var arViewModel: ARViewModel
    /// The ViewModel object for managing content and interactions in the AR scene
    @ObservedObject var contentViewModel: ContentViewModel
    
    // MARK: - BODY OF VIEW
    
    var body: some View {
        
        VStack(spacing: 10){
            
            // CANCEL BUTTON
            HStack{
                Button(action: {
                    contentViewModel.dismissPicker(contentViewModel.isPickerPresented)
                }, label: {
                    Image(systemName: "xmark")
                })
                .buttonStyle(GlassButtonStyle(shape: Circle(), title: .callout))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal, 20)
            
            // TITLE
            Text("Select the Object")
                .font(.title)
                .fontDesign(.rounded)
                .foregroundStyle(.white)
            
            // GRID
            ScrollView(.vertical){
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 30) {
                    ForEach(arViewModel.models) { model in
                        // BUTTON
                        ARModelButtonComponent(model: model) { selectedModel in
                            contentViewModel.selectModel(selectedModel, isPickerPresented: contentViewModel.isPickerPresented, isPlacementEnabled: contentViewModel.isPlacementEnabled)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 50)
            }
            .mask(LinearGradient(gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.black, Color.black, Color.black, Color.black.opacity(0)]), startPoint: .center, endPoint: .top))
        }
        .padding(.top, 50)
        .background(.ultraThinMaterial)
        .statusBar(hidden: true)
        .ignoresSafeArea(.all)
    }
    
}

#Preview {
    ARModelSelectionView(arViewModel: ARViewModel(), contentViewModel: ContentViewModel())
}
