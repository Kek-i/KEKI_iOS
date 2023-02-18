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

class FirebaseStorageManager {
    static func uploadImage(image: UIImage, pathRoot: String, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = "ProfileImg_" + pathRoot
        
        let firebaseReference = Storage.storage().reference().child(PROFILE_IMG_FOLDER_NAME + imageName)
        firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
            firebaseReference.downloadURL { url, _ in
                completion(url)
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
