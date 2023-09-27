
import SwiftUI
import SceneKit

class PlanetScene: SCNScene {
    private var planetNode: SCNNode?
    private var secondPlanetNode: SCNNode?
    private var earthRotationAngle: Double = 0
    private var moonRotationAngle: Double = 0

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
        if let backgroundImage = UIImage(named: "8k_starsMilkyWay") {
            self.background.contents = backgroundImage
        }
    }

    func addPlanetNode() {
        let planetMaterial = SCNMaterial()
        planetMaterial.diffuse.contents = UIImage(named: "earth_nightTime")
        
        let planetGeometry = SCNSphere(radius: 1)
        planetGeometry.materials = [planetMaterial]
        
        let planetNode = SCNNode(geometry: planetGeometry)
        planetNode.position = SCNVector3(0, 0, 0)
        self.rootNode.addChildNode(planetNode)
        self.planetNode = planetNode
    }
    
    func addSecondPlanetNode() {
        let secondPlanetMaterial = SCNMaterial()
        secondPlanetMaterial.diffuse.contents = UIImage(named: "8k_moon") // Replace with the Moon's texture
        
        let secondPlanetGeometry = SCNSphere(radius: 0.2) // Adjust the size as needed
        secondPlanetGeometry.materials = [secondPlanetMaterial]
        
        let secondPlanetNode = SCNNode(geometry: secondPlanetGeometry)
        
        // Position the second planet (moon) relative to the first planet (Earth)
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
        let horizontalRotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(horizontalRotation.radians), z: 0, duration: 0.01)
        let verticalRotateAction = SCNAction.rotateBy(x: CGFloat(verticalRotation.radians), y: 0, z: 0, duration: 0.1)
        let rotateSequence = SCNAction.sequence([horizontalRotateAction, verticalRotateAction])
        
        let earthRotationSpeed = 0.0025
        earthRotationAngle += earthRotationSpeed
        
        let earthAxisRotation =  SCNAction.rotateBy(x: 0, y: CGFloat(-0.01), z: 0, duration: 0)
        planetNode?.runAction(earthAxisRotation)
        planetNode?.runAction(rotateSequence)
    }

    func rotateSecondPlanetNode(angle: Double) {
        // Calculate the new position of the Moon as it orbits around Earth
        let radius = 1.5 // Adjust this radius based on your desired distance from Earth
        let x = radius * cos(angle)
        let z = radius * sin(angle)
        
        // Set the new position of the moon
        secondPlanetNode?.position = SCNVector3(x, 0, z)
        
        // Update the Moon's rotation around its own axis
        let moonRotationSpeed = 0.0025 // Adjust the speed of rotation
        moonRotationAngle += moonRotationSpeed
        
        // Apply the rotation to the Moon's own axis
        let moonAxisRotation = SCNAction.rotateBy(x: 0, y: CGFloat(0.01), z: 0, duration: 0)
        secondPlanetNode?.runAction(moonAxisRotation)
    }
}
