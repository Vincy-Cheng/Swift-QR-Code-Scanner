//
//  CamerPreviewView.swift
//  Scanner
//
//  Created by Wing Lam Cheng on 6/7/24.
//

import AVFoundation
import SwiftUI

struct CameraPreview: UIViewRepresentable {
  class VideoPreviewLayerView: UIView {
    override class var layerClass: AnyClass {
      AVCaptureVideoPreviewLayer.self
    }

    var previewLayer: AVCaptureVideoPreviewLayer {
      layer as! AVCaptureVideoPreviewLayer
    }
  }

  @ObservedObject var cameraModel: CameraModel

  func makeUIView(context: Context) -> VideoPreviewLayerView {
    let view = VideoPreviewLayerView()
    view.previewLayer.session = cameraModel.session
    view.previewLayer.videoGravity = .resizeAspectFill
    return view
  }

  func updateUIView(_ uiView: VideoPreviewLayerView, context: Context) {}
}
