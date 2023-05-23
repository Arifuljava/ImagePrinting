//
//  ImageScreenView.swift
//  ImagePrinting
//
//  Created by sang on 23/5/23.
//

import UIKit
import Foundation
import Photos


class ImageScreenView: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var resulttext: UILabel!
    @IBOutlet weak var clickButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    let imagePickercontroller = UIImagePickerController();
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    
    @IBAction func touched(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
               {
                   
                    print("Button Clicked")
                    imagePickercontroller.delegate = self
                    imagePickercontroller.sourceType = .savedPhotosAlbum
                    imagePickercontroller.allowsEditing = false
                    present(imagePickercontroller,animated: true,completion: nil)
                  
                   
                   
                   
               }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
          print("Image picked declined")
      }
    var startingImage : UIImage = UIImage()

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let pickedImage = info[.originalImage] as? UIImage {
               imageView.contentMode = .scaleAspectFill
               imageView.image = pickedImage
               secondImage.image = pickedImage
               
               let imageUri = info[.imageURL] as?URL
               print("Image url : \n")
               print(imageUri)
               let stringValue = String(describing: imageUri)
               let urlString = URL(string: stringValue)
               let name = urlString?.lastPathComponent
               print("image \n\n\n")
               var mainstring = name
               let sub:Character = ")"
               mainstring = mainstring?.replacingOccurrences(of: String(sub), with: "")
               print(mainstring)
               
              }
        let newImage = convertImageToDifferentColorScale(with: UIImage(named: "bluetooth")!, imageStyle: "CIPhotoEffectNoir")
         secondImage.image = newImage
              //self.dismiss(animated: true)
        convertImageToBitmap(image: newImage)
        guard let  imagedatamy = UIImage(named: "bluetooth")else{
            return ;
        }
        guard let imageData = convertImageToBitmap(image : newImage) else {
                                       return }
        var arrayUinit = [UInt8](repeating: 0, count : imageData.count )
        imageData.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            arrayUinit = Array(UnsafeBufferPointer(start: bytes, count: imageData.count))
                                  }
        
        
           self.dismiss(animated: true)
           
           
       }
    var context = CIContext(options: nil)
    func convertImageToDifferentColorScale(with originalImage:UIImage, imageStyle:String) -> UIImage {
        let currentFilter = CIFilter(name: imageStyle)
        currentFilter!.setValue(CIImage(image: originalImage), forKey: kCIInputImageKey)
        let output = currentFilter!.outputImage
        let context = CIContext(options: nil)
        let cgimg = context.createCGImage(output!,from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        return processedImage
    }
    func convertImageToBitmap(image: UIImage) -> Data? {
          print("get")
          guard let cgImage = image.cgImage else { return nil }
          
          let width = cgImage.width
          let height = cgImage.height
          let colorSpace = CGColorSpaceCreateDeviceGray()
          
          let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
          guard let context = CGContext(data: nil,
                                        width: width,
                                        height: height,
                                        bitsPerComponent: 8,
                                        bytesPerRow: 0,
                                        space: colorSpace,
                                        bitmapInfo: bitmapInfo.rawValue) else {
              return nil
          }
         
          
          let rect = CGRect(x: 0, y: 0, width: width, height: height)
          context.draw(cgImage, in: rect)
          guard let bitmapData = context.data else { return nil }
          
          let dataSize = width * height
          let buffer = UnsafeBufferPointer(start: bitmapData.assumingMemoryBound(to: UInt8.self), count: dataSize)
          print("Bitmap Value : "+buffer.debugDescription)
        resulttext.text = buffer.debugDescription
        
          
          return Data(buffer: buffer)
      }
}
