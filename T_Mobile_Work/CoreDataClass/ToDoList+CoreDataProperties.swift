//
//  ToDoList+CoreDataProperties.swift
//  T_Mobile_Work
//
//  Created by Anand Nanavaty on 24/06/20.
//  Copyright © 2020 Anand Nanavaty. All rights reserved.
//

import Foundation
import CoreData

extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var title: String?
    @NSManaged public var subTitle: String?
    @NSManaged public var isSelect: String?
    @NSManaged public var imageData: Data?
}
