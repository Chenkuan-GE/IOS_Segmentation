import UIKit
import CoreMedia
import CoreML
import MetalKit
import MetalPerformanceShaders

// Dimensions of input image.
let inputWidth = 513
let inputHeight = 513

// Dimensions of the predicted segmentation mask.
let segmentationWidth = 513
let segmentationHeight = 513

let outputIsSigmoid = false

// How far away the controller can move from the center.
let maximumDistance: CGFloat = 120

// The available graphical effects.
enum Mode: String, CaseIterable {
  case maskColors = "Segmentation Mask"
  case shadow = "Shadow"
  case saturation = "Saturation & Brightness"
  case pixelate = "Pixelate"
  case blur = "Blur Background"
  case glow = "Glow"
}

let computeFunctionNames: [Mode: String] = [
  .maskColors: "maskColors",
  .shadow: "shadow",
  .saturation: "saturation",
  .pixelate: "pixelate",
  .blur: "composite",
  .glow: "glow",
]

struct MixParams {
  // We use this to tell the compute kernel how large the segmentation mask is.
  var width: Int32 = Int32(segmentationWidth)
  var height: Int32 = Int32(segmentationHeight)

  // Controller values between -1 and +1 for the graphical effects.
  var dx: Float = 0
  var dy: Float = 0
}


let colors: [UInt8] = [
     0, 0, 0, // background is black
     
     0, 0, 127,       // aeroplane
     0, 0, 255,        // bicycle
     0, 127, 255,        // bird
     0, 127, 127,        // boat
     0, 127, 0,       // bottle
     
     0, 255, 0,      // bus
     0, 255, 127,      // car
     0, 255, 255,      // cat
     127, 255, 255,     // chair
     255, 255, 255,    // cow
     
     255, 255, 127,    // dining table
     255, 255, 0,    // dog
     255, 127, 0,    // horse
     255, 0, 0,    // motorbike
     255, 0, 127,     // person
     
     255, 0, 255,      // poted plant
     127, 0, 255,  // sheep
     0, 0, 255,  // sofa
     127, 127, 255,   // train
     127, 127, 127,    // tv
     
 ]

class ViewController: UIViewController, UINavigationControllerDelegate {
    private let videoPreview: UIView = {
        let p = UIView()
        return p
    }()
    private let fpsLabel: UILabel = {
        let frame = UILabel()
        return frame
    }()
    private let metalView: MTKView = {
        let mv = MTKView()
        return mv
    }()
    
    private let control: UIView = {
        let p = UIView()
        return p
    }()
//    private let returnButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Return to Home", for: .normal)
//        button.setTitleColor(UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
//        button.addTarget(self, action: #selector(handleReturn), for: .touchUpInside)
//        return button
//    }()
//
//    private let switchbutton: UIButton = {
//        let button = UIButton(type: .system)
//        //button.setTitle("Return to Home", for: .normal)
//        button.setImage(UIImage(named: "SwitchCamera"), for: .normal)
//        //button.setTitleColor(UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
//        button.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
//        return button
//    }()
    
    private let toggle: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(toggleVideoPreview), for: .touchUpInside)
        return button
    }()

  var device: MTLDevice!
  var metalLibrary: MTLLibrary!
  var commandQueue: MTLCommandQueue!
  var textureCache: CVMetalTextureCache?
  var computePipelineStates: [Mode: MTLComputePipelineState] = [:]
  var convertMaskToTexturePipeline: MTLComputePipelineState!
  var convertProbabilitiesToMaskPipeline: MTLComputePipelineState!
  var renderPipelineState: MTLRenderPipelineState!
  var colorsBuffer: MTLBuffer!
  var blur: MPSImageGaussianBlur!
  var bigBlur: MPSImageGaussianBlur!

  var videoCapture: VideoCapture!
  let startupGroup = DispatchGroup()
  let fpsCounter = FPSCounter()

  let model = PSPNet()

  var inputTexture: MTLTexture?
  var outputTexture: MTLTexture?
  var backgroundTexture: MTLTexture?
  var probabilitiesBuffer: MTLBuffer?
  var segmentationMaskBuffer: MTLBuffer?
  var segmentationMaskTexture: MTLTexture?
  var tempImage: MPSImage?
  var glowImage: MPSImage?

  var mode = Mode.maskColors
  var lastUsed: CFTimeInterval = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "Real-time Segmentation"
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(handleReturn))
    
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Return to Menu", style: .plain, target: self, action: #selector(handleReturn))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Switch", style: .plain, target: self, action: #selector(switchCamera))

    setUpUI()
    setUpMetal()
    setUpCompute()
    setUpRenderer()
    setUpCamera()
    
    
    backgroundTexture = loadTexture(named: "Background.jpg")
    if backgroundTexture == nil {
      fatalError("Could not load background texture")
    }

    startupGroup.notify(queue: .main) {
      self.fpsCounter.start()
      self.videoCapture.start()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    control.center = view.center
  }

  func setUpUI() {
    view.addSubview(videoPreview)
    view.addSubview(fpsLabel)
    view.addSubview(metalView)
    view.addSubview(control)
    //view.addSubview(returnButton)
    
    videoPreview.frame = CGRect(x: 0, y: 600, width: 120, height: 240)
    fpsLabel.frame = CGRect(x: 151.5, y: 760, width: 100, height: 30)
    metalView.frame = CGRect(x: 0, y: 82, width: view.frame.width, height: view.frame.height - 82)
    control.frame = CGRect(x: 84, y: 212, width: 44, height: 44)
    //returnButton.frame = CGRect(x: 16, y: 0, width: 44, height: 44)
    //switchbutton.frame = CGRect(x: 315, y: 0, width: 44, height: 44)
    toggle.frame = CGRect(x: 20, y: 547, width: 50, height: 80)
    // fpsLabel.text = ""
  }

  func setUpMetal() {
    // TODO: should display an alert to notify the user if no Metal available

    device = MTLCreateSystemDefaultDevice()
    if device == nil {
      print("Error: this device does not support Metal")
      return
    }

    guard MPSSupportsMTLDevice(device) else {
      print("Error: Metal Performance Shaders not supported on this device")
      return
    }

    metalLibrary = device.makeDefaultLibrary()
    if metalLibrary == nil {
      print("Error: could not load Metal library")
      return
    }

    commandQueue = device.makeCommandQueue()

    if CVMetalTextureCacheCreate(kCFAllocatorDefault, nil, device, nil,
                                 &textureCache) != kCVReturnSuccess {
      print("Error: could not create a texture cache")
    }

    blur = MPSImageGaussianBlur(device: device, sigma: 6)
    bigBlur = MPSImageGaussianBlur(device: device, sigma: 24)
  }

  func makeFunction(name: String) -> MTLComputePipelineState {
    do {
      guard let kernelFunction = metalLibrary.makeFunction(name: name) else {
        fatalError("Could not load compute function'")
      }
      return try device.makeComputePipelineState(function: kernelFunction)
    } catch {
      fatalError("Could not create compute pipeline. Error: \(error)")
    }
  }

  func setUpCompute() {
    for (mode, functionName) in computeFunctionNames {
      computePipelineStates[mode] = makeFunction(name: functionName)
    }

    convertMaskToTexturePipeline = makeFunction(name: "convertMaskToTexture")

    // If the output is from a sigmoid and not a softmax, then we run a quick
    // kernel that converts from floats between 0 and 1 to values that are
    // either 0 (background) or 15 (person). This is just so we can use the
    // same compute kernels with both types of model.
    if outputIsSigmoid {
      convertProbabilitiesToMaskPipeline = makeFunction(name: "convertProbabilitiesToMask")
      probabilitiesBuffer = self.device.makeBuffer(length: segmentationHeight * segmentationWidth * MemoryLayout<Float>.stride)
    }

    // For most kernels it's fine to have the segmentation mask as a buffer
    // of 32-bit integers.
    segmentationMaskBuffer = self.device.makeBuffer(length: segmentationHeight * segmentationWidth * MemoryLayout<Int32>.stride)

    // But for some kernels we want to have it as a texture. This is 0 for
    // background and 1 for person (and possibly values in between for regions
    // that are ambiguous).
    let textureDesc = MTLTextureDescriptor.texture2DDescriptor(
                          pixelFormat: .r8Unorm,
                          width: segmentationWidth,
                          height: segmentationHeight,
                          mipmapped: false)
    textureDesc.usage = [ .shaderRead, .shaderWrite ]
    segmentationMaskTexture = device.makeTexture(descriptor: textureDesc)

    // The segmentation mask texture after blurring.
    if let glowTexture = device.makeTexture(descriptor: textureDesc) {
      glowImage = MPSImage(texture: glowTexture, featureChannels: 1)
    }

    // Lookup table with colors for .maskColors mode.
    colorsBuffer = device.makeBuffer(bytes: colors, length: colors.count * MemoryLayout<UInt8>.stride)!
  }

  func setUpRenderer() {
    metalView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
    metalView.device = device
    metalView.delegate = self
    metalView.isPaused = true
    metalView.enableSetNeedsDisplay = false
    metalView.depthStencilPixelFormat = .invalid

    let renderStateDescriptor = MTLRenderPipelineDescriptor()
    renderStateDescriptor.vertexFunction = metalLibrary.makeFunction(name: "vertexFunc")
    renderStateDescriptor.fragmentFunction = metalLibrary.makeFunction(name: "fragmentFunc")
    renderStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

    do {
      renderPipelineState = try device.makeRenderPipelineState(descriptor: renderStateDescriptor)
    } catch {
      fatalError("\(error)")
    }
  }

  func setUpCamera() {
    startupGroup.enter()

    videoCapture = VideoCapture()
    videoCapture.delegate = self

    videoCapture.setUp(sessionPreset: .hd1280x720,
                       orientation: .portrait,
                       position: .front) { success in
      if success {
        if let previewLayer = self.videoCapture.previewLayer {
          self.videoPreview.layer.addSublayer(previewLayer)
          self.videoPreview.isHidden = true
          self.resizePreviewLayer()
        }
      }
      self.startupGroup.leave()
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    print(#function)
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    resizePreviewLayer()
  }

  func resizePreviewLayer() {
    videoCapture.previewLayer?.frame = videoPreview.bounds
  }

  @IBAction func switchCamera() {
    videoCapture.switchCamera()
  }

  @IBAction func toggleVideoPreview() {
    videoPreview.isHidden = !videoPreview.isHidden
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.randomElement() {
      let position = touch.location(in: view)
      let distX = view.center.x - position.x
      let distY = (view.center.y - position.y) / 2
      if distX >= -maximumDistance && distX <= maximumDistance {
        control.center.x = position.x
      }
      if distY >= -maximumDistance && distY <= maximumDistance {
        control.center.y = position.y
      }
      control.isHidden = false
      lastUsed = CACurrentMediaTime()
    }
  }

  func predict(input: CVPixelBuffer) {
    if let resizedInput = resizePixelBuffer(input, width: inputWidth, height: inputHeight),
       let output = try? self.model.prediction(image: resizedInput),
       let textureCache = self.textureCache,
       let inputTexture = CVPixelBufferToMTLTexture(pixelBuffer: input,
                                                    textureCache: textureCache) {
      DispatchQueue.main.async {
        // Allocate a new texture with the same size as the input image.
        if self.outputTexture == nil {
          let textureDesc = MTLTextureDescriptor.texture2DDescriptor(
                                pixelFormat: inputTexture.pixelFormat,
                                width: inputTexture.width,
                                height: inputTexture.height,
                                mipmapped: false)
          textureDesc.usage = [ .shaderRead, .shaderWrite ]
          self.outputTexture = self.device.makeTexture(descriptor: textureDesc)

          // Also make an MPSImage for using Metal Performance Shaders.
          if let tempTexture = self.device.makeTexture(descriptor: textureDesc) {
            self.tempImage = MPSImage(texture: tempTexture, featureChannels: 4)
          }
        }
        //output.semanticPredictions.da

        // Copy the MLMultiArray's contents into the MTLBuffer so we can
        // use it from Metal compute shaders.
        if outputIsSigmoid {
          if let buffer = self.probabilitiesBuffer {
            memcpy(buffer.contents(), output.semanticPredictions.dataPointer, buffer.length)
          }
            
        } else {
          if let buffer = self.segmentationMaskBuffer {
            memcpy(buffer.contents(), output.semanticPredictions.dataPointer, buffer.length)
          }
        }

        self.inputTexture = inputTexture
        self.metalView.draw()

        self.fpsCounter.frameCompleted()
        //self.fpsLabel.text = String(format: "%.1f FPS", self.fpsCounter.fps)
        self.fpsLabel.text = "FPS: \(self.fpsCounter.fps)"
      }
    }
  }
}

extension ViewController: VideoCaptureDelegate {
  func videoCapture(_ capture: VideoCapture, didCaptureSampleBuffer sampleBuffer: CMSampleBuffer) {
    if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
      predict(input: pixelBuffer)
    }
  }
}

extension ViewController: MTKViewDelegate {
  func draw(in view: MTKView) {
    // Remove the controller view from the screen if inactive.
    if CACurrentMediaTime() - lastUsed > 1.5 {
      control.isHidden = true
    }

    if let inputTexture = inputTexture,
       let outputTexture = outputTexture,
       let segmentationMaskBuffer = segmentationMaskBuffer,
       let commandBuffer = commandQueue.makeCommandBuffer(),
       let renderPassDescriptor = view.currentRenderPassDescriptor,
       let currentDrawable = view.currentDrawable {

      // Use this struct to pass data to the Metal compute shaders.
      var params = MixParams()
      params.dx = Float((control.center.x - view.center.x) / maximumDistance)
      params.dy = Float((control.center.y - view.center.y) / (maximumDistance*2))

      if outputIsSigmoid,
         let probabilitiesBuffer = probabilitiesBuffer,
         let pipeline = convertProbabilitiesToMaskPipeline,
         let encoder = commandBuffer.makeComputeCommandEncoder() {

        encoder.setBuffer(probabilitiesBuffer, offset: 0, index: 0)
        encoder.setBuffer(segmentationMaskBuffer, offset: 0, index: 1)
        encoder.setBytes(&params, length: MemoryLayout<MixParams>.size, index: 2)
        encoder.dispatch(pipeline: pipeline, count: Int(params.height * params.width))
        encoder.endEncoding()
      }

      // In blur mode, first run a Gaussian kernel to blur the input image.
      if mode == .blur, let destImage = tempImage {
        let inputImage = MPSImage(texture: inputTexture, featureChannels: 4)
        blur.encode(commandBuffer: commandBuffer, sourceImage: inputImage, destinationImage: destImage)
      }

      // In glow mode, run a Gaussian kernel to blur the segmentation mask.
      if mode == .glow,
         let segmentationMaskTexture = segmentationMaskTexture,
         let glowImage = glowImage,
         let pipeline = convertMaskToTexturePipeline,
         let encoder = commandBuffer.makeComputeCommandEncoder() {

        // First, convert the segmentation task into a texture.
        encoder.setTexture(segmentationMaskTexture, index: 0)
        encoder.setBuffer(segmentationMaskBuffer, offset: 0, index: 0)
        encoder.dispatch(pipeline: pipeline, width: segmentationWidth, height: segmentationHeight)
        encoder.endEncoding()

        // Now blur it to make it look like it's glowing.
        let inputImage = MPSImage(texture: segmentationMaskTexture, featureChannels: 1)
        bigBlur.encode(commandBuffer: commandBuffer, sourceImage: inputImage, destinationImage: glowImage)
      }

      // Run the compute shader to apply the current mode's graphical effect.
      if let pipeline = computePipelineStates[mode],
         let encoder = commandBuffer.makeComputeCommandEncoder() {
        encoder.setTexture(inputTexture, index: 0)
        encoder.setTexture(outputTexture, index: 1)
        encoder.setBuffer(segmentationMaskBuffer, offset: 0, index: 0)
        encoder.setBytes(&params, length: MemoryLayout<MixParams>.size, index: 1)

        if mode == .maskColors {
          encoder.setBuffer(colorsBuffer, offset: 0, index: 2)
        }
        if mode == .shadow {
          encoder.setTexture(backgroundTexture, index: 2)
        }
        if mode == .blur, let img = tempImage {
          encoder.setTexture(img.texture, index: 2)
        }
        if mode == .glow, let img = glowImage {
          encoder.setTexture(img.texture, index: 2)
        }

        encoder.dispatch(pipeline: pipeline, width: inputTexture.width, height: inputTexture.height)
        encoder.endEncoding()
      }

      // Run the vertex and fragments shaders to draw everything.
      if let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) {
        encoder.setRenderPipelineState(self.renderPipelineState)
        encoder.setFragmentTexture(outputTexture, index: 0)
        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        encoder.endEncoding()
      }

      commandBuffer.present(currentDrawable)
      commandBuffer.commit()
    }
  }

  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    // not implemented
  }
    
    // return to home page
    @objc func handleReturn() {
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        guard let mainNavigationController = window?.rootViewController as? MainNavigationController else { return }

        mainNavigationController.viewControllers = [HomeController()]
    }
}
