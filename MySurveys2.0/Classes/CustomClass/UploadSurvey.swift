//
//  UploadSurvey.swift
//  MySurveys2.0
//
//  Created by Chinthan on 13/01/17.
//  Copyright © 2017 Chinthan. All rights reserved.
//

import UIKit

class UploadSurvey: NSObject {
    static let sharedInstance = UploadSurvey()
    let sdk = OPGSDK()
    private override init() {} // This prevents others from using

    /* !
    This method uploads the the offline survey results and sends out upload progress to the listener.
    */
    func uploadFile(surveyID: NSNumber, panellistID: String, fileName: String, filePath: String, totalUploadedCount: Int, fileCount: Int, pendingCount: Int, index: IndexPath) {
        var progress: Float = 0.0
        let panellistID: String = UserDefaults.standard.value(forKey: "PanelListID") as! String
        do {
            let resultObj: OPGUploadResult = try sdk.uploadOfflineResultFile(surveyID.stringValue, panelistId: panellistID, fileName: fileName, filePath: filePath)

            if resultObj.isSuccess == 1 {
                progress = Float(fileCount) / Float(totalUploadedCount)
                // code to update progress bar
                print("Upload Progress : \(progress*100)%")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "NotificationIdentifier"), object: nil, userInfo: ["percentage": progress, "surveyReference": surveyID.intValue, "index": index, "numberOfFilesPending": pendingCount])
            }
        }
        catch let err as NSError {
            print("Error: \(err)")
        }
    }

    func uploadOfflineSurvey(_ surveyReference: NSNumber, panelistID: String, index: IndexPath) {
        let sdk = OPGSDK()
        let offlineResultFiles: NSArray = sdk.getResultFiles(forOfflineSurvey: surveyReference) as NSArray
        let offlineMediaFiles: NSArray = sdk.getMediaFiles(forOfflineSurvey:  surveyReference) as NSArray
        let resultsFilePath: String = sdk.getResultsFilePath()
        let mediaFilePath: String = sdk.getMediaFilePath()

        let count = offlineResultFiles.count + offlineMediaFiles.count
        var filecount = 0
        var pendingCount = offlineResultFiles.count


        let serialQueue = DispatchQueue(label: "uploadresultsqueue")
        serialQueue.async {
            if offlineMediaFiles.count > 0 {
                for mediaFile in offlineMediaFiles {
                    filecount = filecount + 1
                    self.uploadFile(surveyID: surveyReference, panellistID: panelistID, fileName: mediaFile as! String, filePath: mediaFilePath, totalUploadedCount: count,fileCount: filecount, pendingCount: pendingCount, index: index)
                }
            }
            for resultFile in offlineResultFiles {
                filecount = filecount + 1
                pendingCount = pendingCount - 1
                self.uploadFile(surveyID: surveyReference, panellistID: panelistID, fileName: resultFile as! String, filePath: resultsFilePath, totalUploadedCount: count, fileCount: filecount, pendingCount: filecount, index: index)
            }
            print("Upload results DONE")
        }
    }
    
}
