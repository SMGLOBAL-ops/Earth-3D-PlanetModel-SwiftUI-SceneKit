import SwiftUI
import SceneKit

struct PlanetView: View {
    private let scene = PlanetScene()
    private let cameraNode = createCameraNode()
    @State private var initialDragLocation: CGPoint? = nil
    @State private var currentDragLocation: CGPoint? = nil
    @State private var horizontalRotationAngle: Angle = .zero
    @State private var verticalRotationAngle: Angle = .zero
    @State private var moonRotationAngle: Double = 0
    
    // Add a state variable to control the rotation of the second planet
    @State private var secondPlanetRotationAngle: Double = 0

    var body: some View {
        ZStack {
            // SceneView
            SceneView(scene: scene, pointOfView: cameraNode)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if initialDragLocation == nil {
                                initialDragLocation = gesture.location
                            }
                            currentDragLocation = gesture.location

                            // Calculate the rotation angles based on drag movement
                            let horizontalDelta = Double(currentDragLocation!.x - initialDragLocation!.x)
                            let verticalDelta = Double(currentDragLocation!.y - initialDragLocation!.y)

                            horizontalRotationAngle = Angle(degrees: horizontalDelta / 5.0)
                            verticalRotationAngle = Angle(degrees: verticalDelta / 5.0)
                        }
                        .onEnded { _ in
                            initialDragLocation = nil
                            currentDragLocation = nil
                        }
                )
                .onReceive(AnimationTicker.shared.ticker) { _ in
                    // Rotate the planet node smoothly
                    scene.rotatePlanetNode(horizontalRotation: horizontalRotationAngle, verticalRotation: verticalRotationAngle)
                    
                    // Rotate the second planet (moon) around the first planet (Venus)
                    secondPlanetRotationAngle += 0.005 // Adjust the speed of rotation
                    scene.rotateSecondPlanetNode(angle: secondPlanetRotationAngle)
                }
            // Background Image overlay
            Image("8k_starsMilkyWay") // Replace with your image asset name
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all) // Adjust this as needed
                .opacity(0.5) // You can adjust the opacity if needed
        }
        Text("Planet Venus - 3D Rotatable Model, with 'moon'")
    }

    static func createCameraNode() -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        return cameraNode
    }
}

struct PlanetView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetView()
    }
}
