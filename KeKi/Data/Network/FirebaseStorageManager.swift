//
//  FirebaseManager.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/18.
//

import Foundation
import FirebaseStorage
import Firebase

private let PROFILE_IMG_FOLDER_NAME = "iOS-profiles/"
private let PRODUCT_IMG_FOLDER_NAME = "product/"


class FirebaseStorageManager {
    static let firebase = FirebaseStorageManager()
    
    static let profileFolder = PROFILE_IMG_FOLDER_NAME
    static let productFolder = PRODUCT_IMG_FOLDER_NAME
    
    
    static func uploadImage(image: UIImage, pathRoot: String, folderName: String, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        var imageName = ""
        switch folderName {
        case PROFILE_IMG_FOLDER_NAME:
            imageName = "ProfileImg_" + pathRoot
        case PRODUCT_IMG_FOLDER_NAME:
            imageName = "ProductImg_" + pathRoot
        default:
            imageName = pathRoot
        }
        
        let firebaseReference = Storage.storage().reference().child(folderName + imageName)
        firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
            firebaseReference.downloadURL { url, _ in
                completion(url)
            }
        }
    }
    static func uploadImages(imageList: [UIImage], pathRoot: String, folderName: String, completion: @escaping ([String]) -> Void) {
           var urlList: [String] = []
           var idx = 0
           imageList.forEach { image in
               guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
               let metaData = StorageMetadata()
               metaData.contentType = "image/jpeg"

               var imageName = ""
               switch folderName {
               case PROFILE_IMG_FOLDER_NAME:
                   imageName = "ProfileImg" + pathRoot + (String(idx))
               case PRODUCT_IMG_FOLDER_NAME:
                   imageName = "ProductImg" + pathRoot + (String(idx))
               default:
                   imageName = pathRoot + (String(idx))
               }
               idx += 1

               let firebaseReference = Storage.storage().reference().child(folderName + imageName)
               firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
                   firebaseReference.downloadURL { url, _ in
                       if let url = url {urlList.append(url.description)}
                       if urlList.count == imageList.count { completion(urlList) }
                   }

               }
           }
       }
    
    
    
    
    
    
    static func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let storageReference = Storage.storage().reference(forURL: urlString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        storageReference.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }
}
