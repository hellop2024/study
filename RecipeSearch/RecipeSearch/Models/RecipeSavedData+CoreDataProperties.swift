//
//  RecipeSavedData+CoreDataProperties.swift
//  RecipeSearch
//
//  Created by YS P on 6/3/24.
//
//

import Foundation
import CoreData


extension RecipeSavedData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeSavedData> {
        return NSFetchRequest<RecipeSavedData>(entityName: "RecipeSavedData")
    }

    @NSManaged public var imageUrl: String?

}

extension RecipeSavedData : Identifiable {

}
