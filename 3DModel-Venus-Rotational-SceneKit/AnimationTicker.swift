import SwiftUI

class AnimationTicker: ObservableObject {
    static let shared = AnimationTicker()
    
    let ticker = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common).autoconnect()
    
    private init() {}
}
