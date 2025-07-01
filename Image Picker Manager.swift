
import Foundation
import UIKit
import AVFoundation
//
class ImagePickerManager: NSObject  {
    
    var picker = UIImagePickerController();
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    var optionMenu = UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
    
    override init(){
        super.init()
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.checkCameraValidations()
        })
        let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.openGallary()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(galleryAction)
        optionMenu.addAction(cancelAction)
     
        
        // Add the actions
        picker.delegate = self
        DispatchQueue.main.async {
            viewController.present(self.optionMenu, animated: true, completion: nil)
        }
        
    }
    
    func alertForCameraPermission() {
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required for capturing photos!",
            preferredStyle: UIAlertController.Style.alert
        )
       
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            
        }))
        self.viewController?.present(alert, animated: true, completion: nil)
    }
    
    
    func checkCameraValidations() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch (authStatus){
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.openCamera()
                    }
                }
            }
        case .restricted:
            alertForCameraPermission()
        case .denied:
            alertForCameraPermission()
        case .authorized:
            DispatchQueue.main.async {
                self.openCamera()
            }
        @unknown default:
            print("")
        }
        
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.modalPresentationStyle = .overCurrentContext
            picker.allowsEditing = true
            self.viewController?.present(picker, animated: true, completion: nil)
        }
        
        else {
            
        }
        
    }
    
    
    // MARK:-  Open galary Method 
    func openGallary() {
        //        UINavigationBar.appearance().barTintColor = AppColors.appColorRed
        //        UINavigationBar.appearance().tintColor = .white
        //        UINavigationBar.appearance().isTranslucent = false
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.modalPresentationStyle = .overCurrentContext
        self.viewController?.present(picker, animated: true, completion: nil)
        
    }
    
}

extension ImagePickerManager : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        pickImageCallback?(image)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
}
