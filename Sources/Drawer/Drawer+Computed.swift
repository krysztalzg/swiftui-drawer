//
//  Drawer+Computed.swift
//

import SwiftUI

extension Drawer {

    // MARK: Height Calculation
    
    internal var activeBound: ClosedRange<CGFloat> {
        return heights.min()!...heights.max()!
    }
    
    // MARK: View

    private var offset: CGFloat {
        if !dragging && !heights.contains(restingHeight), didAppear {
            DispatchQueue.main.async {
                let newHeight = Drawer.closest(self.restingHeight, markers: self.heights)
                self.restingHeight = newHeight
                self.height = newHeight
            }
        } else if !didAppear, let startingHeight = heights.first {
            DispatchQueue.main.async {
                self.restingHeight = startingHeight
                self.height = startingHeight
                didAppear = true
            }
        }
        return -$height.wrappedValue
    }
    
    public var body: some View {
        
        if (sizeClass != SizeClass(
                horizontal: horizontalSizeClass,
                vertical: verticalSizeClass)) {
            DispatchQueue.main.async {
                self.sizeClass = SizeClass(
                    horizontal: self.horizontalSizeClass,
                    vertical: self.verticalSizeClass)
            }
        }
        
        return ZStack(
            alignment: Alignment(
                horizontal: .center,
                vertical: .bottom
            )
        ) {
            GeometryReader { proxy in
                VStack(alignment: .leading) {
                    self.content
                        .frame(maxHeight: height)
                    Spacer()
                }
                .offset(y: proxy.frame(in: .global).height + self.offset)
                .animation(self.animation)
                .gesture(self.dragGesture)
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}
