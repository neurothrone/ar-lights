//
//  Coordinator.swift
//  ARLights
//
//  Created by Zaid Neurothrone on 2022-10-16.
//

import ARKit
import RealityKit

final class Coordinator {
  var arView: ARView?
  
  @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
    guard let arView = arView else { return }
    
    let tapLocation = recognizer.location(in: arView)
    let raycastResults = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
    
    guard let firstRaycast = raycastResults.first else { return }
    
//    addPointLight(with: firstRaycast, on: arView)
//    addDirectionalLight(with: firstRaycast, on: arView)
    addSpotLight(with: firstRaycast, on: arView)
  }
  
  private func addPointLight(with raycast: ARRaycastResult, on view: ARView) {
    let anchor = AnchorEntity(raycastResult: raycast)
    
    let lightEntity = PointLight()
    lightEntity.light.color = .purple
    lightEntity.light.intensity = 1000
    lightEntity.light.attenuationRadius = 0.5
    lightEntity.look(at: [0, 0, 0], from: [0, 0, 0.1], relativeTo: anchor)
    
    anchor.addChild(lightEntity)
    view.scene.addAnchor(anchor)
  }
  
  private func addDirectionalLight(with raycast: ARRaycastResult, on view: ARView) {
    let anchor = AnchorEntity(raycastResult: raycast)
    
    let lightEntity = DirectionalLight()
    lightEntity.light.color = .blue
    lightEntity.light.intensity = 1000
    lightEntity.light.isRealWorldProxy = true // When true: can cast shadows on other virtual projects
    lightEntity.shadow?.maximumDistance = 2
    lightEntity.shadow?.depthBias = 5 // How deep the shadow will be
    
    anchor.addChild(lightEntity)
    view.scene.addAnchor(anchor)
  }
  
  private func addSpotLight(with raycast: ARRaycastResult, on view: ARView) {
    let anchor = AnchorEntity(raycastResult: raycast)
    
    let lightEntity = SpotLight()
    lightEntity.light.color = .green
    lightEntity.light.intensity = 1000
    
    // Look at origin
    lightEntity.look(at: [0, 0, 0], from: [0, 0.06, 0.3], relativeTo: anchor)
    lightEntity.shadow = SpotLightComponent.Shadow()
    
    lightEntity.light.innerAngleInDegrees = 45
    lightEntity.light.outerAngleInDegrees = 60
    lightEntity.light.attenuationRadius = 10 // 10 meters
    
    anchor.addChild(lightEntity)
    view.scene.addAnchor(anchor)
  }
}
