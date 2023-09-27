import SwiftUI
import SceneKit

class PlanetScene: SCNScene {
    private var planetNode: SCNNode?
    private var secondPlanetNode: SCNNode?
    
    override init() {
        super.init()
        addBackground()
        addPlanetNode()
        addSecondPlanetNode()
        configureCamera()
        addOmniLight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCamera() {
        self.rootNode.position = SCNVector3(x: 0, y: 0, z: -8)
    }
    
    func addBackground() {
        background.contents = UIColor.black
    }
    
    func addPlanetNode() {
        let planetMaterial = SCNMaterial()
        planetMaterial.diffuse.contents = UIImage(named: "4k_venus")
        
        let planetGeometry = SCNSphere(radius: 1)
        planetGeometry.materials = [planetMaterial]
        
        let planetNode = SCNNode(geometry: planetGeometry)
        planetNode.position = SCNVector3(0, 0, 0)
        self.rootNode.addChildNode(planetNode)
        self.planetNode = planetNode
    }
    
    func addSecondPlanetNode() {
        let secondPlanetMaterial = SCNMaterial()
        secondPlanetMaterial.diffuse.contents = UIImage(named: "8k_moon") // Replace with the moon's texture
        
        let secondPlanetGeometry = SCNSphere(radius: 0.2) // Adjust the size as needed
        secondPlanetGeometry.materials = [secondPlanetMaterial]
        
        let secondPlanetNode = SCNNode(geometry: secondPlanetGeometry)
        
        // Position the second planet (moon) relative to the first planet (Venus)
        secondPlanetNode.position = SCNVector3(1.5, 0, 0) // Adjust the position as needed
        
        self.rootNode.addChildNode(secondPlanetNode)
        self.secondPlanetNode = secondPlanetNode
    }
    
    func addOmniLight() {
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        
        omniLightNode.light?.type = SCNLight.LightType.omni
        omniLightNode.light?.color = UIColor(white: 1, alpha: 1)
        omniLightNode.position = SCNVector3Make(20, 0, 30)
        
        self.rootNode.addChildNode(omniLightNode)
    }
    
    func rotatePlanetNode(horizontalRotation: Angle, verticalRotation: Angle) {
        // Smoothly interpolate between the current rotations and the new rotations
        let horizontalRotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(horizontalRotation.radians), z: 0, duration: 0.1)
        let verticalRotateAction = SCNAction.rotateBy(x: CGFloat(verticalRotation.radians), y: 0, z: 0, duration: 0.1)
        let rotateSequence = SCNAction.sequence([horizontalRotateAction, verticalRotateAction])
        
        planetNode?.runAction(rotateSequence)
    }

    func rotateSecondPlanetNode(angle: Float) {
        // Calculate the new position of the moon as it orbits around Venus
        let radius = Float(1.5) // Adjust this radius based on your desired distance from Venus
        let x = radius * cos(angle)
        let z = radius * sin(angle)
        
        // Set the new position of the moon
        secondPlanetNode?.position = SCNVector3(x, 0, z)
        
        // Calculate the rotation angle for the moon's own axis
        let moonAxisRotationAngle = SCNVector3(0, 1, 0) // Rotate around the Y-axis (adjust axis as needed)
        
        // Create a rotation action to rotate the moon around its own axis
        let moonRotationAction = SCNAction.rotateBy(
            x: CGFloat(moonAxisRotationAngle.x * angle),
            y: CGFloat(moonAxisRotationAngle.y * angle),
            z: CGFloat(moonAxisRotationAngle.z * angle),
            duration: 0.1
        )
        
        // Apply the rotation action to the moon while ensuring it always rotates in one direction
        secondPlanetNode?.runAction(SCNAction.repeatForever(moonRotationAction), forKey: "moon_rotation")
    }
}
