//
//  Photo.swift
//  MediaMonks-PhotoApp
//
//  Created by Alberto Juarez on 18/01/21.
//

import Foundation


//Define a photo to be identifiable (so you can iterate through the array as well as decodable so you can extract the JSON data using this struct
struct Photo: Identifiable, Decodable {

    let id,albumId: Int
    let title,url,thumbnailUrl: String
}
