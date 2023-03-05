//
//  ObjectCaptureRequester.swift
//  ARBUILDER
//
//  Created by belal medhat on 05/02/2023.

import Foundation
import RealityKit
protocol ObjectCaputureRequesterProtocol{
    func requestObjCaputre(fileLocation:String,suggestedFileName:String,savedLocation:String,completion:@escaping (_ progress:Double?,_ msg:String?)->Void)
}
struct ObjectCaptureRequester:ObjectCaputureRequesterProtocol{
    func requestObjCaputre(fileLocation:String,suggestedFileName:String,savedLocation:String,completion:@escaping (_ progress:Double?,_ msg:String?)->Void) {
        let inputFolderUrl = URL(fileURLWithPath: fileLocation)
        let url = URL(fileURLWithPath: "\(savedLocation)/\(suggestedFileName).usdz")
        let request = PhotogrammetrySession.Request.modelFile(url: url,detail: .full)
        guard let session = try? PhotogrammetrySession(input: inputFolderUrl) else {
            return
        }
        Task {
            do {
                for try  await output in session.outputs {
                    switch output {
                        case .processingComplete:
                            // RealityKit has processed all requests.
                        completion(nil,"Model Created Successfully")
                        print("")

                        case .requestError(let request, let error):
                            // Request encountered an error.
                        completion(nil, error.localizedDescription)
                        print("")

                        case .requestComplete(let request, let result):
                            // RealityKit has finished processing a request.
                        print("")
                        case .requestProgress(let request, let fractionComplete):
                            // Periodic progress update. Update UI here.
                        print("request done with \(request)")
                        completion(fractionComplete,nil)
                        print("")

                    case .inputComplete: break
                            // Ingestion of images is complete and processing begins.
                        print("")

                        case .invalidSample(let id, let reason):
                            // RealityKit deemed a sample invalid and didn't use it.
                        print("")

                        case .skippedSample(let id):
                            // RealityKit was unable to use a provided sample.
                        print("")

                        case .automaticDownsampling:
                            // RealityKit downsampled the input images because of
                            // resource constraints.
                        print("")

                    case .processingCancelled:
                            // Processing was canceled.
                        print("")

                    @unknown default:
                        print("")

                            // Unrecognized output.
                    }
                }
            } catch {
                print("Output: ERROR = \(String(describing: error))")
                // Handle error.
            }
        }
        do{
            try session.process(requests: [request])
        }catch let erorr {
            print(erorr.localizedDescription)
        }

    }
}
