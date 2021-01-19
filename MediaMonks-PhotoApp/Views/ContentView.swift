//
//  ContentView.swift
//  MediaMonks-PhotoApp
//
//  Created by Alberto Juarez on 18/01/21.
//

import SwiftUI
import SDWebImageSwiftUI
import SDWebImage

//Normally if its a larger project I would separate this into other files

struct ContentView: View {
    @ObservedObject private var photoModel = PhotoViewModel()
    init(){
        //Change the navigation bar color
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().barTintColor =  UIColor(Color(#colorLiteral(red: 0.9187714458, green: 0.6712489724, blue: 0.7381495833, alpha: 1)))
        UINavigationBar.appearance().backgroundColor = UIColor(Color(#colorLiteral(red: 0.9187714458, green: 0.6712489724, blue: 0.7381495833, alpha: 1)))

    }
    var body: some View {
        ZStack{
            //Put a color on the bottom and ignore the top safe area
            //so that is seems continous with the navigationbar
            //and the black one so that the footnote looks good on devices without a home button
            Color(.black).edgesIgnoringSafeArea(.bottom)
            Color(#colorLiteral(red: 0.9187714458, green: 0.6712489724, blue: 0.7381495833, alpha: 1)).edgesIgnoringSafeArea(.top)
            
            
            //Main navigation bar for the albums -> photos
            NavigationView {
                ScrollView(.vertical){
                    VStack {
                        ForEach(photoModel.albumArray.keys.sorted(), id: \.self) { key in
                            NavigationLink(destination: singleAlbumView(photos: photoModel.albumArray[key]!).navigationBarTitle(Text("Album \(key)"), displayMode: .inline)) {
                                HStack {
                                    Text("Album \(key)").font(.title2).foregroundColor(.black).frame(minWidth: 0, maxWidth: .infinity,minHeight:50, maxHeight: 50)
                                }
                                .background(
                                    Capsule().fill(Color.white).border(Color.black, width: 3)
                                ).padding()
                            }.navigationBarTitle("📷 Photo App")
                        }
                    }
                }.padding(.horizontal)
                
            }.padding(.top).padding(.bottom,50)
            
            //Little footnote at the bottom
            VStack{
                Spacer()
                HStack{
                    Text("Made with ❤️ by Alberto.")
                        .foregroundColor(.white)
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity,minHeight:0, maxHeight: 50)
                        .background(Color.black)
                }
            }
        }.onAppear{
            //Load the data from the API as soon as the app appears
            self.photoModel.loadData()
        }
    }
}

struct singleAlbumView: View {
    //Define a 3 column grid that adapts to the screen
    private let threeColumnGrid = [
            GridItem(.flexible(minimum: 40), spacing: 5),
            GridItem(.flexible(minimum: 40), spacing: 5),
            GridItem(.flexible(minimum: 40), spacing: 5),]
    //It needs an array of photos to present
    var photos: [Photo]
    var body: some View {
        
        //Display each photo from the album in a lazy grid
        ScrollView(.vertical){
            LazyVGrid(columns: threeColumnGrid, content: {
                ForEach(photos){photo in
                    singlePhotoView(photo: photo)
                }
            })
        }.padding()
    }
}

struct singlePhotoView: View {
    //State to know if you clicked on a photo or dismissed the modal
    @State private var showDetails = false
    
    //The current photo
    var photo: Photo
    var body: some View {
        Button(action: {
            //Show the details
            self.showDetails.toggle()
        }, label: {
            //Present the thumbnail of the item in the lazy grid
            VStack(alignment:.leading){
                WebImage(url: URL(string: photo.thumbnailUrl))
                    .resizable()
                    .scaledToFit()
            }
            .cornerRadius(10)
            .padding(.vertical,0.5)
        }).sheet(isPresented: $showDetails) {
            //On clicked show the details (Call the other view)
            singlePhotoDetailView(photo: photo)
        }
    }
}

struct singlePhotoDetailView: View {
    //The current photo
    var photo: Photo
    var body: some View {
        // Vstack with the details of a individual photo
        VStack(alignment: .leading,spacing:10){
            //Get the title on the center on the top of the modal
            HStack{
                Spacer()
                Text(photo.title).bold()
                Spacer()
            }.padding(.vertical,15)
            HStack{
                Text("Photo ID: ").bold()
                Text("\(photo.id)")
            }
            HStack{
                Text("Album ID: ").bold()
                Text("\(photo.albumId)")
            }
            //Limit this to one line in case they are long
            HStack{
                Text("Image url: ").bold()
                Text(photo.url).font(.footnote).lineLimit(1)
            }
            HStack{
                Text("Thumbnail url: ").bold()
                Text(photo.thumbnailUrl).font(.footnote).lineLimit(1)
            }
            //Display the complete photo
            WebImage(url: URL(string: photo.url))
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
        }.padding(.horizontal)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
