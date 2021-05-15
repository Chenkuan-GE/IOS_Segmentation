import UIKit
import AVFoundation
import Vision
import Metal
import MetalPerformanceShaders
import CoreML

class VideoSegController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate {
    
    /// a local reference to time to update the framerate
    var time = Date()
    
    var ready: Bool = true

    /// the view to preview raw RGB data from the camera
    private let preview: UIView = {
        let p = UIView()
        return p
    }()
    /// the view for showing the segmentation
    private let segmentation: UIImageView = {
        let seg = UIImageView()
        return seg
    }()
    private let under_segmentation: UIImageView = {
        let seg = UIImageView()
        return seg
    }()
    
    /// a label to show the framerate of the model
    private let framerate: UILabel = {
        let frame = UILabel()
        return frame
    }()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Return to Menu", style: .plain, target: self, action: #selector(handleReturn))
        
        navigationItem.title = "Road Scene Segmentation"
        
        view.addSubview(preview)
        view.addSubview(segmentation)
        view.addSubview(framerate)
        view.addSubview(under_segmentation)
        
        preview.frame = CGRect(x: 50, y: 70, width: 400, height: 300)
        segmentation.frame = CGRect(x: 450, y: 70, width: 400, height: 300)
        framerate.frame = CGRect(x: 100, y: 350, width: 800, height: 80)
        under_segmentation.frame = CGRect(x: 450, y: 70, width: 400, height: 300)
        
    }
    
    /// the camera session for streaming data from the camera
    var captureSession: AVCaptureSession!
    /// the video preview layer
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    /// TODO:
    private var _device: MTLDevice?
    /// TODO:
    var device: MTLDevice! {
        get {
            // try to unwrap the private device instance
            if let device = _device {
                return device
            }
            _device = MTLCreateSystemDefaultDevice()
            return _device
        }
    }
    
    var _queue: MTLCommandQueue?
    
    var queue: MTLCommandQueue! {
        get {
            // try to unwrap the private queue instance
            if let queue = _queue {
                return queue
            }
            _queue = device.makeCommandQueue()
            return _queue
        }
    }

    /// the model for the view controller to apss camera data through
    private var _model: VNCoreMLModel?
    
    private let model_use = PSPNet()
    /// the model for the view controller to apss camera data through
    var model: VNCoreMLModel! {
        get {
            // try to unwrap the private model instance
            if let model = _model {
                return model
            }
            // try to create a new model and fail gracefully
            do {
                _model = try VNCoreMLModel(for: PSPNet().model)
            } catch let error {
                let message = "failed to load model: \(error.localizedDescription)"
                popup_alert(self, title: "Model Error", message: message)
            }

            return _model
        }
    }
    
    @objc func handleReturn() {
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        guard let mainNavigationController = window?.rootViewController as? MainNavigationController else { return }
        
        viewReturn(false)
        
        mainNavigationController.viewControllers = [HomeController()]
    }
    
    /// the request and handler for the model
    private var _request: VNCoreMLRequest?
    /// the request and handler for the model
    var request: VNCoreMLRequest! {
        get {
            // try to unwrap the private request instance
            if let request = _request {
                return request
            }
            // create the request
            _request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
                // handle an error from the inference engine
                if let error = error {
                    print("inference error: \(error.localizedDescription)")
                    return
                }
                // make sure the UI is ready for another frame
                guard self.ready else { return }
                // get the outputs from the model
                let outputs = finishedRequest.results as? [VNCoreMLFeatureValueObservation]
                // get the probabilities as the first output of the model
                guard let softmax = outputs?[0].featureValue.multiArrayValue else {
                    print("failed to extract output from model")
                    return
                }
                
                let mutil : MLMultiArray = softmax
                    
                let new_image = getPSPNetResultImage(result:mutil)
                // update the image on the UI thread
                DispatchQueue.main.async {
                    self.segmentation.image = new_image
                    self.segmentation.alpha = 0.5
                    let fps = -1 / self.time.timeIntervalSinceNow
                    self.time = Date()
                    self.framerate.text = "FPS: \(fps)"
                }

            }
            // set the input image size to be a scaled version
            // of the image
            _request?.imageCropAndScaleOption = .scaleFill
            return _request
        }
    }

    
    /// Respond to a memory warning from the OS
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        popup_alert(self, title: "Memory Warning", message: "received memory warning")
    }
    
    
    func viewReturn(_ animated:Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            //禁止横屏
            appDelegate.isLandscape = false
        }
        //强制为竖屏
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        super.viewWillDisappear(animated)

    }
    
    /// Handle the view appearing
    override func viewDidAppear(_ animated: Bool) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            //允许横屏
            appDelegate.isLandscape = true

            // 强制横屏打开下面两行代码即可
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")

        }
        super.viewWillAppear(animated)
        // setup the AV session
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd1280x720
        // get a handle on the back camera
        guard let camera = AVCaptureDevice.default(for: AVMediaType.video) else {
            let message = "Unable to access the back camera!"
            popup_alert(self, title: "Camera Error", message: message)
            return
        }
        // create an input device from the back camera and handle
        // any errors (i.e., privacy request denied)
        do {
            // setup the camera input and video output
            let input = try AVCaptureDeviceInput(device: camera)
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            // add the inputs and ouptuts to the sessionr and start the preview
            if captureSession.canAddInput(input) && captureSession.canAddOutput(videoOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(videoOutput)
                setupCameraPreview()
            }
        }
        catch let error  {
            let message = "failed to intialize camera: \(error.localizedDescription)"
            popup_alert(self, title: "Camera Error", message: message)
            return
        }
    }

    /// Setup the live preview from the camera
    func setupCameraPreview() {
        // create a video preview layer for the view controller
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        // set the metadata of the video preview
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .landscapeRight
        // add the preview layer as a sublayer of the preview view
        preview.layer.addSublayer(videoPreviewLayer)
        //under_segmentation.layer.addSublayer(videoPreviewLayer)
        // start the capture session asyncrhonously
        DispatchQueue.global(qos: .userInitiated).async {
            // start the capture session in the background thread
            self.captureSession.startRunning()
            // set the frame of the video preview to the bounds of the
            // preview view
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.preview.bounds
            }
        }
    }
    
    /// Handle a frame from the camera video stream
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // create a Core Video pixel buffer which is an image buffer that holds pixels in main memory
        // Applications generating frames, compressing or decompressing video, or using Core Image
        // can all make use of Core Video pixel buffers
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            let message = "failed to create pixel buffer from video input"
            popup_alert(self, title: "Inference Error", message: message)
            return
        }
        // execute the request
        do {
            try VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        } catch let error {
            let message = "failed to perform inference: \(error.localizedDescription)"
            popup_alert(self, title: "Inference Error", message: message)
        }
    }
    
    
}
