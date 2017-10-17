//
//  OfflineDownload.swift
//  MySurveys2.0
//
//  Created by Chinthan on 21/12/16.
//  Copyright © 2016 OnePoint Global. All rights reserved.
//

import UIKit
import Foundation

class OfflineDownload: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    typealias CompletionBlock = (Double?, OPGSurvey?, NSError?) -> Void
    var completion: CompletionBlock = { result, survey, error in print(error) }
    var surveyObj: OPGSurvey?
    let sdk = OPGSDK()
    var downloadTask: URLSessionDataTask?
    var request: NSMutableURLRequest?
    var session: URLSession?
    var buffer: NSMutableData = NSMutableData()
    var expectedContentLength = 0
    var isDownloaded = 0


    // MARK: - Private methods
    /* !
    This method downloads the script file for the offline survey.
    */
    func downloadOfflineSurvey(_ survey: OPGSurvey, completionHandler: @escaping (Double?, OPGSurvey?,NSError?) -> Void) {
            self.completion = completionHandler
            self.surveyObj = survey
                // print("survey.surveyReference:\(survey.surveyReference)")
                if survey.surveyReference != "" {
                    do {
                        self.request = try self.sdk.getScriptRequest(survey)
                        let downloadRequest = self.request?.mutableCopy() as! URLRequest
                        self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
                        downloadTask = self.session?.dataTask(with: downloadRequest)
                        downloadTask!.resume()
                    }
                    catch{
                        print("GetScript Failed")         /* @"Error Occurred. Contact Support!" */
                    }
                }
    }
    
    func stopDownloadingSurvey() {
        if self.downloadTask != nil {
            self.downloadTask!.cancel()
        }
        if self.session != nil {
            self.session?.invalidateAndCancel()
        }
    }

    // MARK: - URLSession Delegate methods
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        expectedContentLength = Int(response.expectedContentLength)
        print(expectedContentLength)
        completionHandler(URLSession.ResponseDisposition.allow)
    }
  
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        buffer.append(data)
        let percentageDownloaded = Float(buffer.length) / Float(expectedContentLength)
        self.completion(Double(percentageDownloaded), self.surveyObj, nil)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            self.completion(0.0, self.surveyObj, error as NSError?)
        }
        else {
            isDownloaded = 1
            let script: OPGParseResult = OPGParseResult()
            do {
                if NSString(data: buffer as Data, encoding: String.Encoding.utf8.rawValue) != nil {
                    let json = try JSONSerialization.jsonObject(with: buffer as Data, options: .mutableContainers) as! [AnyHashable: Any]
                    let result: OPGScript = try script.parseAndDownloadScript(json, for: self.surveyObj)
//                    if result.isSuccess == 1 {
//                        print(result)
//                    }
                }
            } catch {
                print(error)
            }
            self.completion(1.0, self.surveyObj, nil)
        }
    }
    
}
