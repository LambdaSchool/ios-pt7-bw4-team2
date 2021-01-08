//
//  CustomCameraVC.swift
//  QuickGifs
//
//  Created by Norlan Tibanear on 1/6/21.
//

import UIKit
import AVFoundation

class CustomCameraVC: UIViewController {
    
    // Outlets
    // Outlets
    let pictureButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(handleCameraButton), for: .touchUpInside)
        return button
    }()
    
    // Properties
    var captureSession = AVCaptureSession()

    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?

    var photoOutput: AVCapturePhotoOutput?

    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?

    var image: UIImage?

    var toggleCameraGestureRecognizer = UISwipeGestureRecognizer()

    var zoomInGestureRecognizer = UISwipeGestureRecognizer()
    var zoomOutGestureRecognizer = UISwipeGestureRecognizer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        captureSession.startRunning()


        toggleCameraGestureRecognizer.direction = .up
        toggleCameraGestureRecognizer.addTarget(self, action: #selector(self.switchCamera))
        view.addGestureRecognizer(toggleCameraGestureRecognizer)

        // Zoom In recognizer
        zoomInGestureRecognizer.direction = .right
        zoomInGestureRecognizer.addTarget(self, action: #selector(zoomIn))
        view.addGestureRecognizer(zoomInGestureRecognizer)

        // Zoom Out recognizer
        zoomOutGestureRecognizer.direction = .left
        zoomOutGestureRecognizer.addTarget(self, action: #selector(zoomOut))
        view.addGestureRecognizer(zoomOutGestureRecognizer)
        
    }//
    
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }

    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices

        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }

        currentDevice = backCamera
    }

    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer() {
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.cameraPreviewLayer?.frame = self.view.frame

        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }


    @objc func switchCamera() {
        captureSession.beginConfiguration()

        // Change the device based on the current camera
        let newDevice = (currentDevice?.position == AVCaptureDevice.Position.back) ? frontCamera : backCamera

        // Remove all inputs from the session
        for input in captureSession.inputs {
            captureSession.removeInput(input as! AVCaptureDeviceInput)
        }

        // Change to the new input
        let cameraInput:AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice!)
        } catch {
            print(error)
            return
        }

        if captureSession.canAddInput(cameraInput) {
            captureSession.addInput(cameraInput)
        }

        currentDevice = newDevice
        captureSession.commitConfiguration()
    }

    @objc func zoomIn() {
        if let zoomFactor = currentDevice?.videoZoomFactor {
            if zoomFactor < 5.0 {
                let newZoomFactor = min(zoomFactor + 1.0, 5.0)
                do {
                    try currentDevice?.lockForConfiguration()
                    currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentDevice?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }

    @objc func zoomOut() {
        if let zoomFactor = currentDevice?.videoZoomFactor {
            if zoomFactor > 1.0 {
                let newZoomFactor = max(zoomFactor - 1.0, 1.0)
                do {
                    try currentDevice?.lockForConfiguration()
                    currentDevice?.ramp(toVideoZoomFactor: newZoomFactor, withRate: 1.0)
                    currentDevice?.unlockForConfiguration()
                } catch {
                    print(error)
                }
            }
        }
    }




    func startRunningCaptureSession() {
        captureSession.startRunning()
    }



    @objc func handleCameraButton() {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }//
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CameraToEditiSegue" {
            let previewVC = segue.destination as! FilterViewController
            previewVC.pickerImage = self.image
        }
    }
    
    
    
    
    func configureUI() {
        view.addSubviewsUsingAutolayout(pictureButton)
        configurePictureButton()
    }//
    
    func configurePictureButton() {
        pictureButton.anchor(
            bottom: view.safeAreaLayoutGuide.bottomAnchor, centerX: view.centerXAnchor, padding: .init(top: 0, left: 0, bottom: -20, right: 0), size: .init(width: 70, height: 70)
        )
        pictureButton.layer.borderWidth = 2
        pictureButton.layer.borderColor = UIColor.white.cgColor
        pictureButton.layer.cornerRadius = 35
        pictureButton.clipsToBounds = true
        
    }//
    

}// CustomCameraVC

extension CustomCameraVC: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            image = UIImage(data: imageData)
            performSegue(withIdentifier: "CameraToEditiSegue", sender: nil)
        }
    }
}
