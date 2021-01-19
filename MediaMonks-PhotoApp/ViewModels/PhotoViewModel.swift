//
//  PhotoViewModel.swift
//  MediaMonks-PhotoApp
//
//  Created by Alberto Juarez on 18/01/21.
//

import Foundation


//Main API view model
class PhotoViewModel: ObservableObject{
    //Create a published dictionary of integers as keys and an array of photos as children
    //this will be our main array of albums so that for example {1: [photo1,photo2],2:[photo3,photo4]}
    @Published var albumArray: [Int: [Photo]] = [:]
    //API main url
    private let api_point = "https://jsonplaceholder.typicode.com/photos"
    
    //Function to get the data from the API
    func loadData(){
        //Check if you can form the URL
        guard let url = URL(string: self.api_point) else {
            print("Could not form URL")
            return
        }
        
        //Start the data task using the url
        URLSession.shared.dataTask(with: url){data,response,error in
            //Check for error present
            guard error == nil else {
                print("Error: \(error?.localizedDescription ?? "unknown")")
                return
            }
            
            //Check if there was data returned
            guard let data = data else {
                print("Could not retrieve data")
                return
            }
            
            //Get the data from JSON to a dictionary of Photos based on the albumId
            if let responseAPI = try? JSONDecoder().decode([Photo].self, from: data){
                DispatchQueue.main.async {
                    //Group in a dictionary by albumId so that all the photos from an album get stored on its proper key
                    let responseGrouped = Dictionary(grouping: responseAPI, by: { $0.albumId })
                    //Asign the data to the published object
                    self.albumArray = responseGrouped
                    return
                }
            }
        }.resume()
    }
}
