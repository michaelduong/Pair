//
//  EntityController.swift
//  Pair Randomizer
//
//  Created by Michael Duong on 2/23/18.
//  Copyright © 2018 Turnt Labs. All rights reserved.
//

/* LOGIC:
 1. Not sure if model(Entity.swift) file necessary in this situation
 2. Create array and variable in this file to save time
 3. CRUD functions
 4. Save/load functions
 5. Randomize function using arc4random
 */


import Foundation
typealias Entity = String

class EntityController {
    
    static let shared = EntityController()
    
    var entities: [Entity] = []
    
    init() {
        loadEntity()
    }
    
    func createEntity(newEntity: Entity) {
        entities.append(newEntity)
        saveEntity()
    }
    
    func removeEntity(entity: Entity) {
        guard let index = entities.index(of: entity) else { return }
        entities.remove(at: index)
        saveEntity()
    }
    
    func randomize() {
        var randomEntities: [Entity] = []
        for entity in entities {
            let randomIndex = Int(arc4random_uniform(UInt32(randomEntities.count)))
            randomEntities.insert(entity, at: randomIndex)
        }
        entities = randomEntities
    }
    
    func saveEntity() {
        UserDefaults.standard.set(entities, forKey: EntityController.itemsKey)
    }
    
    static let itemsKey = "ItemsKey"
    func loadEntity() {
        guard let savedEntities = UserDefaults.standard.array(forKey: EntityController.itemsKey) as? [Entity] else { return }
        entities = savedEntities
    }
    
}


