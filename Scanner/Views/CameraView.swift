//
//  CameraView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/7/24.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @Binding var selectedImage: UIImage?
        @Binding var isPresented: Bool

        @StateObject private var cameraModel = CameraModel()

        var body: some View {
            ZStack {
                CameraPreview(cameraModel: cameraModel)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            cameraModel.takePhoto()
                        }) {
                            Image(systemName: "camera.circle.fill")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                }
            }
            .onAppear {
                cameraModel.startSession()
            }
            .onDisappear {
                cameraModel.stopSession()
            }
            .onChange(of: cameraModel.capturedPhoto) { newValue in
                if let newValue = newValue {
                    selectedImage = newValue
                    isPresented = false
                }
            }
        }
}


//class CameraModel: NSObject, ObservableObject {
//    private var session: AVCaptureSession
//    private var output: AVCapturePhotoOutput
//    private var videoPreviewLayer: AVCaptureVideoPreviewLayer
//
//    @Published var capturedPhoto: UIImage?
//
//    override init() {
//        session = AVCaptureSession()
//        output = AVCapturePhotoOutput()
//        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
//
//        super.init()
//        configureSession()
//    }
//
//    private func configureSession() {
//        session.beginConfiguration()
//
//        // Add video input
//        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
//              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
//              session.canAddInput(videoDeviceInput) else {
//            return
//        }
//        session.addInput(videoDeviceInput)
//
//        // Add photo output
//        if session.canAddOutput(output) {
//            session.addOutput(output)
//        }
//
//        session.commitConfiguration()
//    }
//
//    func startSession() {
//        if !session.isRunning {
//            DispatchQueue.global(qos: .background).async {
//                self.session.startRunning()
//            }
//        }
//    }
//
//    func stopSession() {
//        if session.isRunning {
//            DispatchQueue.global(qos: .background).async {
//                self.session.stopRunning()
//            }
//        }
//    }
//
//    func takePhoto() {
//        let settings = AVCapturePhotoSettings()
//        output.capturePhoto(with: settings, delegate: self)
//    }
//}
//
//extension CameraModel: AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        guard let data = photo.fileDataRepresentation(),
//              let image = UIImage(data: data) else {
//            return
//        }
//        DispatchQueue.main.async {
//            self.capturedPhoto = image
//        }
//    }
//}

class CameraModel: NSObject, ObservableObject {
    var session: AVCaptureSession
    private var output: AVCapturePhotoOutput
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer

    @Published var capturedPhoto: UIImage?

    override init() {
        session = AVCaptureSession()
        output = AVCapturePhotoOutput()
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)

        super.init()
        configureSession()
    }

    private func configureSession() {
        session.beginConfiguration()

        // Add video input
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              session.canAddInput(videoDeviceInput) else {
            return
        }
        session.addInput(videoDeviceInput)

        // Add photo output
        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        session.commitConfiguration()
    }

    func startSession() {
        if !session.isRunning {
            DispatchQueue.global(qos: .background).async {
                self.session.startRunning()
            }
        }
    }

    func stopSession() {
        if session.isRunning {
            DispatchQueue.global(qos: .background).async {
                self.session.stopRunning()
            }
        }
    }

    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            return
        }
        DispatchQueue.main.async {
            self.capturedPhoto = image
        }
    }
}
