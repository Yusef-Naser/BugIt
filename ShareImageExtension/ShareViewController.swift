//
//  ShareViewController.swift
//  ShareImageExtension
//
//  Created by yusef naser on 11/09/2024.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {

    let appGroupName = "group.com.bugit.Bug-It"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Process the shared items
               if let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem {
                   if let attachments = extensionItem.attachments {
                       for attachment in attachments {
                           // Look for an image
                           if attachment.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
                               attachment.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil) { (imageData, error) in
                                   if let imageURL = imageData as? URL {
                                       // Handle the image URL, or fetch image from it
                                       self.saveImageFrom(url: imageURL)
                                   } else if let image = imageData as? UIImage {
                                       // Handle the UIImage object directly
                                       self.saveImage(image)
                                   }
                               }
                           }
                       }
                   }
               }
        
    }
    
    func getSharedContainerURL() -> URL {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupName) else {
            fatalError("Shared container not found. Check your App Group setup.")
        }
        return containerURL
    }
    
    // Example method to handle image saving
    func saveImage(_ image: UIImage) {
        if let imageData = image.pngData() {
            // Create a URL for saving the image to the shared container
            let fileURL = getSharedContainerURL().appendingPathComponent("sharedImage.png")
            do {
                try imageData.write(to: fileURL)
                print("Image saved to shared container: \(fileURL)")
            } catch {
                print("Error saving image: \(error)")
            }

            // Complete the extension process
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }
    
    func saveImageFrom(url: URL) {
        // Convert the image from URL and save it
        do {
            let data = try Data(contentsOf: url)
            if let image = UIImage(data: data) {
                saveImage(image)
            }
        } catch {
            print("Error loading image from URL: \(error)")
        }
    }
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
