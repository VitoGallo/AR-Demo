//
//  GlassBackground.swift
//  AR-Demo
//
//  Created by Vito Gallo on 14/01/24.
//

import SwiftUI

/// A glass background effect that can be applied to a specific shape
///
/// This background effect offers a glass look with a transparent surface and a gradient border
struct GlassBackground<S: Shape>: View {
    
    // MARK: - PROPERTIES
    
    /// The shape to apply the glass background effect to
    var shape: S
    /// The surface gradient, a linear transition from transparent white to completely transparent
    let gradientSurface = LinearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .topLeading, endPoint: .bottomTrailing)
    /// The border gradient, a linear transition from semi-transparent white to fully transparent, and then to semi-transparent green
    let gradientBorder = LinearGradient(colors: [.white.opacity(0.5), .clear, .clear, .clear, .green.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    // MARK: - BODY OF VIEW
    
    var body: some View {
        
        GeometryReader { geo in
            shape
                .foregroundStyle(gradientSurface)
                .background(.ultraThinMaterial)
                .mask {
                    shape.foregroundStyle(.white)
                }
                .overlay {
                    shape.stroke(lineWidth: 2.5)
                        .foregroundStyle(gradientBorder)
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 8)
        }
    }
}

#Preview {
    GlassBackground(shape: Circle())
}
