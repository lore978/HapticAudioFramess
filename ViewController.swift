//
//  ViewController.swift
//  VibView
//
//  Created by Lorenzo Giannantonio on 20/01/2020.

import UIKit
import CoreImage
import AVFoundation
import CoreHaptics
import CoreML
import Vision
import ImageIO
import CoreMotion
import Foundation

var countforbast = 0
var sccreentouched = false
var previousColor: UIColor = .black
var forceoftouch: Float = 0.1
var xtouch : Float = Float(UIScreen.main.bounds.width/2)
var ytouch : Float = Float(UIScreen.main.bounds.height/2)
var prextouch : Float = xtouch
var preytouch : Float = ytouch
var screenwidth : Float = 1
var screenheight : Float = 1
var xcorrection : Float = 1
var ycorrection : Float = 1
var widthcamera : Int = 480
var heightcamera : Int = 640
var stoggleTorch = false
var contvibr = false
var tocchi : Set<UITouch>? = nil
var convertedHeatmap: [[Double]] = []
var newdepthframe = false
var tap = true
var touchvibr : Float = 1
var pretouchvibr : Float = 1
var cgImage : CGImage?
var captureSession = AVCaptureSession()
var swipe = false
var rect : CGRect?
var orientationr = UIDevice.current.orientation.rawValue
var model : VNCoreMLModel?
var torch = false
let motionManager = CMMotionManager()
var rotationmatrix : CMRotationMatrix?
var prem12 : Float?
var prem33 : Float?
var prem23 : Float?
var prem21 : Float?
var corrtiltx : Float = 0
var corrtilty : Float = 0
var scale: CGFloat = 0.0
var previbr : Float = 0
var versionanalisys = 0 //previous 0, new 1
var colortovibr : UIColor = .black
var timetowave = CACurrentMediaTime() - 10000
var patternvibrcolor : CHHapticPattern?
var player : CHHapticAdvancedPatternPlayer?
var engine: CHHapticEngine?
var maxbastonedistance : Float = 2000
var prebastdistance : Float = 0
var depthpresence : Bool = false
var typeofcane : Bool = false
var preinclination : Float = 0
var vibrating : Bool = false
var contintensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0)
var contsharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
var tdtouchabsencedefault : CGFloat = 0
var contintensityctrl : Float = 0
var contsharpnessctrl : Float = 0
var rengine = AVAudioEngine()
var positionztest : Float = 0
var latoquadratoaudio = 5
var audioPlayer = [AVAudioPlayerNode]()
var soundstred = false
var depthforsound = Array(repeating: Float(0), count: latoquadratoaudio*latoquadratoaudio)
var verticalbands = Array(repeating: Int(0), count: latoquadratoaudio)
var horizontalbands = Array(repeating: Int(0), count: latoquadratoaudio)
var colorvalues = Array(repeating: 90, count: latoquadratoaudio*latoquadratoaudio)
var count = 0
var musicfilenumber = 9
var withcolours = false
var firstcanedistance = true
var maxdepth : Float = 0
var mindepth : Float = 0
var orientation : AVCaptureVideoOrientation = AVCaptureVideoOrientation(rawValue: 1)!
var deltamove : Float = 0
var volumeadjusting : Float = 4.5
var hapticinhibittimer : Timer!
var hapticusageseconds = 0
var inhibittimer = false
var basecount = 3
var stepforaudio = 3
var mode = 0
var saveddefault : [Any]?
var lastwithdepth = false
var differenceincolor : Float = 0
var updatedepth = false
var updatecolors = false
 var intensitycolorofimage = 0
var pauseduration = 0
var gradeofcolor = CGFloat(0)
var ratioadj = Float(0)
var typeplay = false
//var lastrendere = Array(repeating: UInt64(0), count: latoquadratoaudio*latoquadratoaudio*2)
/*
 FCRNFP16 Copyright (c) 2016, Iro Laina
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */
/*
 depthmap real time rights
 /// Copyright (c) 2019 Razeware LLC
 ///
 /// Permission is hereby granted, free of charge, to any person obtaining a copy
 /// of this software and associated documentation files (the "Software"), to deal
 /// in the Software without restriction, including without limitation the rights
 /// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 /// copies of the Software, and to permit persons to whom the Software is
 /// furnished to do so, subject to the following conditions:
 ///
 /// The above copyright notice and this permission notice shall be included in
 /// all copies or substantial portions of the Software.
 ///
 /// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 /// distribute, sublicense, create a derivative work, and/or sell copies of the
 /// Software in any work that is designed, intended, or marketed for pedagogical or
 /// instructional purposes related to programming, coding, application development,
 /// or information technology.  Permission for such use, copying, modification,
 /// merger, publication, distribution, sublicensing, creation of derivative works,
 /// or sale is expressly withheld.
 ///
 /// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 /// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIESF MERCHANTABILITY,
 /// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 /// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 /// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 /// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 /// THE SOFTWARE.
 */


class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate  {
    var tview = UIView()
    var accview = UIView()
    var pinching = false
    var lastpinch : CGFloat = 1
    var cgImagecropped : CGImage?
    var cameraImage : CIImage?
    //var cameraImagecache : CIImage?
    var rectangle : CGRect?
   
    lazy var environment = AVAudioEnvironmentNode()
    @objc func pinch( sender : UIPinchGestureRecognizer) {
        if tap == true {return}
        if sender.state == .ended && newdepthframe == true {pinching = false;view.isUserInteractionEnabled = true}
        if sender.state == .began {
            view.isUserInteractionEnabled = false
            motionManager.stopDeviceMotionUpdates();corrtiltx = 10;corrtilty = 10;prem12 = 0;prem33 = 0;prem23 = 0;prem21 = 0;
            sccreentouched = false;
            if vibrating == true {
            do {
                try player?.stop(atTime: CHHapticTimeImmediate);vibrating = false;
            } catch let error {
                print("Error stopping the continuous haptic player: \(error)")
                }}
            pinching = true
    }
        
        if sender.state == .changed {
            let change = (sender.scale - 1)*0.3 + 1
            if change/lastpinch > 1.15 {
                lastpinch = change;let generator = UIImpactFeedbackGenerator();generator.impactOccurred()
                if cgImagecropped == nil {cgImagecropped = cgImage}
                let width = CGFloat(cgImagecropped!.width)/lastpinch
                let height = CGFloat(cgImagecropped!.height)/lastpinch
                let xorigin = (sender.location(in: accview).x / CGFloat(screenwidth))
                let yorigin = (sender.location(in: accview).y / CGFloat(screenheight))
                rectangle = CGRect(x: CGFloat(cgImagecropped!.width)*xorigin - width/2, y: CGFloat(cgImagecropped!.height)*yorigin - height/2, width: width, height: height)
                cgImagecropped = cgImagecropped?.cropping(to: rectangle!)
                accodaflusso(filteredImage: UIImage(cgImage: cgImagecropped!))
            }
            if lastpinch/change > 1.15 && cgImagecropped != nil && change < 1{
                lastpinch = change;let generator = UIImpactFeedbackGenerator();generator.impactOccurred()
                let width = CGFloat(cgImage!.width)/lastpinch
                let height = CGFloat(cgImage!.height)/lastpinch
                let xorigin = (sender.location(in: accview).x / CGFloat(screenwidth))
                let yorigin = (sender.location(in: accview).y / CGFloat(screenheight))
                rectangle = CGRect(x: CGFloat(cgImage!.width)*xorigin - width/2, y: CGFloat(cgImage!.height)*yorigin - height/2, width: width, height: height)
                cgImagecropped = cgImage?.cropping(to: rectangle!)
                accodaflusso(filteredImage: UIImage(cgImage: cgImagecropped!))
            }
        }
        if sender.state == .ended && newdepthframe == true {
           // if cameraImagecache == nil {cameraImagecache = cameraImage}
            newdepthframe = false
            //cameraImagecache = cameraImagecache?.cropped(to: (rectangle)!)
            processaimmaginezoom(cameraImage: cameraImage!.cropped(to: (rectangle)!))
        }
    }

    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var backCameradepth: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    let context = CIContext()
    func playsoundsoraccesslibrary(){
        switch typeplay {
        case false:
            if versionanalisys == 0 {
                do {
                     try player?.stop(atTime: CHHapticTimeImmediate);vibrating = false
                 } catch let error {
                     print("Error stopping the continuous haptic player: \(error)")
                 };
                withcolours = true
                if rengine.isRunning {for i in 0...audioPlayer.count - 1 {rengine.detach(audioPlayer[i])};_ = sounds(environment: environment).endplay();environment.reset();}
                if ProcessInfo.processInfo.thermalState.rawValue > 1 {latoquadratoaudio = 3}
                lastwithdepth = true
                sounds(environment: environment).playsounds()
                filteredImage.image = UIImage(named: "sfondoaudio.jpg")!
            }
        default :
            if versionanalisys == 0 &&  depthpresence == true {
                model = nil
                do {
                     try player?.stop(atTime: CHHapticTimeImmediate);vibrating = false
                 } catch let error {
                     print("Error stopping the continuous haptic player: \(error)")
                 };
                withcolours = false
                if rengine.isRunning {for i in 0...audioPlayer.count - 1 {rengine.detach(audioPlayer[i])};_ = sounds(environment: environment).endplay();environment.reset()}
                if ProcessInfo.processInfo.thermalState.rawValue > 1 {latoquadratoaudio = 3}
                lastwithdepth = false
                sounds(environment: environment).playsounds()
                filteredImage.image = UIImage(named: "sfondoaudiobn.jpg")!
            }
            if versionanalisys == 0 &&  depthpresence == false {
                do {
                     try player?.stop(atTime: CHHapticTimeImmediate);vibrating = false
                 } catch let error {
                     print("Error stopping the continuous haptic player: \(error)")
                 };
                withcolours = false
                //if rengine.isRunning {_ = sounds().endplay();changesound = true}
                //if ProcessInfo.processInfo.thermalState.rawValue > 1 {latoquadratoaudio = 3}
                if !rengine.isRunning {sounds(environment: environment).playsounds()}
                tap = false
                lastwithdepth = false
                //processaimmagine(cameraImage: cameraImage!)
                captureSession.startRunning()
                //changesound = true
                filteredImage.image = UIImage(named: "sfondoaudiobn.jpg")!
            }

            /*    do {
                    try player?.stop(atTime: CHHapticTimeImmediate);
                } catch let error {
                    print("Error stopping the continuous haptic player: \(error)")
                };
                vibrating = false
                sccreentouched = false;
                captureSession.stopRunning()
                motionManager.stopDeviceMotionUpdates();corrtiltx = 10;corrtilty = 10;prem12 = 0;prem33 = 0;
        */
        }
    }
    
    @objc func swipgeup() {
        if mode == 3 {if !lastwithdepth {musicfilenumber += 1};typeplay = true;playsoundsoraccesslibrary()}
        if versionanalisys == 2 && maxbastonedistance > 200 && typeofcane == false {maxbastonedistance-=100
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
    
    @objc func swipegright() {
        DispatchQueue.main.async {
        if soundstred == true {
            if volumeadjusting > 0 {volumeadjusting = volumeadjusting*1.1;let generator = UIImpactFeedbackGenerator();generator.impactOccurred(intensity: 0.4)} else
            {volumeadjusting = volumeadjusting/1.1;let generator = UIImpactFeedbackGenerator();generator.impactOccurred(intensity: 0.4)}}
        if volumeadjusting > -0.5 && volumeadjusting < 0 {volumeadjusting = 0.6;let generator = UIImpactFeedbackGenerator();generator.impactOccurred(intensity: 1)}
        if versionanalisys == 2 && typeofcane == false {typeofcane = true;preinclination = 0;vibrating = false;
            do {
                try player?.stop(atTime: CHHapticTimeImmediate);
            } catch let error {
                print("Error stopping the continuous haptic player: \(error)")
            }
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            }}
    }
    
    @objc func swipegleft() {
        DispatchQueue.main.async {
        if soundstred == true {
            if volumeadjusting > 0 {volumeadjusting = volumeadjusting/1.1;let generator = UIImpactFeedbackGenerator();generator.impactOccurred(intensity: 0.4)} else
            {volumeadjusting = volumeadjusting*1.1;let generator = UIImpactFeedbackGenerator();generator.impactOccurred(intensity: 0.4)}}
        if volumeadjusting < 0.5 && volumeadjusting > 0 {volumeadjusting = -0.6;let generator = UIImpactFeedbackGenerator();generator.impactOccurred(intensity: 1)}
        if versionanalisys == 2 && typeofcane == true {typeofcane = false;preinclination = 0;vibrating = false;
            do {
                try player?.stop(atTime: CHHapticTimeImmediate); vibrating = false
            } catch let error {
                print("Error stopping the continuous haptic player: \(error)")
            }
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            }}
    }

 @objc func swipegdown() {
    if mode == 3 {if lastwithdepth {musicfilenumber += 1};typeplay = false;playsoundsoraccesslibrary()}
        if versionanalisys == 2 && maxbastonedistance < 6000 && typeofcane == false  {maxbastonedistance+=100
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
        }
    }



    @IBOutlet weak var filteredImage: UIImageView!
   

     @objc func tapped() {
        if orientationr != 0 && UIDevice.current.orientation.rawValue != 0 {orientationr = UIDevice.current.orientation.rawValue}
            xcorrection = Float(widthcamera)/screenwidth
            ycorrection = Float(heightcamera)/screenheight
        var xpos : Float = 360
        switch orientationr {
        case 0...2:
            xpos = (xtouch/Float(widthcamera))*640
        case 5:
            xpos = (xtouch/Float(widthcamera))*640
        case 3:
            xpos = 640 - (ytouch/Float(heightcamera))*640
        case 4:
            xpos = (ytouch/Float(heightcamera))*640
            
        default:
            xpos = (ytouch/Float(heightcamera))*640
        }
        
        switch xpos {
        case 0...90:
            previousColor = .white
            sccreentouched = false;vibrating = false;
            motionManager.stopDeviceMotionUpdates();corrtiltx = 10;corrtilty = 10;prem12 = 0;prem33 = 0;prem23 = 0;prem21 = 0;timetowave = CACurrentMediaTime() - 10000;
            do {
                try player?.stop(atTime: CHHapticTimeImmediate)
            } catch let error {
                print("Error stopping the continuous haptic player: \(error)")
            }
            switch mode {
            case 0:
                versionanalisys = 0
                playsoundsoraccesslibrary()
                mode = 3
            case 1:
                versionanalisys = 0
                mode = 0
            case 2:
                versionanalisys = 2;firstcanedistance = true
                mode = 1
                if depthpresence == false {mode = 0 ;versionanalisys = 0}
            default:
                versionanalisys = 1
                mode = 2
                if soundstred == true && captureSession.isRunning && rengine.isRunning {for i in 0...audioPlayer.count - 1 {rengine.detach(audioPlayer[i])};
                    let a = sounds(environment: environment).endplay();environment.reset();soundstred = a; depthforsound = Array(repeating: Float(0), count: latoquadratoaudio*latoquadratoaudio)}

            }
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            if versionanalisys == 2 && backCameradepth == nil {versionanalisys = 0}
            if versionanalisys == 3 {versionanalisys = 0;preinclination = 0; prebastdistance = 0;typeofcane = false}
            
        case 550...640:
            previousColor = .white
            sccreentouched = false;vibrating = false;
            motionManager.stopDeviceMotionUpdates();corrtiltx = 10;corrtilty = 10;prem12 = 0;prem33 = 0;prem23 = 0;prem21 = 0;timetowave = CACurrentMediaTime() - 10000;
            do {
                try player?.stop(atTime: CHHapticTimeImmediate)
            } catch let error {
                print("Error stopping the continuous haptic player: \(error)")
            }
            switch mode {
            case 0:
                versionanalisys = 2;firstcanedistance = true
                mode = 1
                if depthpresence == false {mode = 2 ;versionanalisys = 1}
            case 1:
                versionanalisys = 1
                mode = 2
            case 2:
                versionanalisys = 0
                playsoundsoraccesslibrary()
                mode = 3
            default:
                if soundstred == true && captureSession.isRunning && rengine.isRunning {for i in 0...audioPlayer.count - 1 {rengine.detach(audioPlayer[i])};
                    let a = sounds(environment: environment).endplay();environment.reset();soundstred = a; depthforsound = Array(repeating: Float(0), count: latoquadratoaudio*latoquadratoaudio)}
                versionanalisys = 0
                mode = 0
            }
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            if versionanalisys == 2 && backCameradepth == nil {versionanalisys = 0}
            if versionanalisys == 3 {versionanalisys = 0;preinclination = 0; prebastdistance = 0;typeofcane = false}
        default:
            if versionanalisys == 0 && soundstred == false {
            tap.toggle()
            vibrating = false
            do {
                try player?.stop(atTime: CHHapticTimeImmediate)
            } catch let error {
                print("Error stopping the continuous haptic player: \(error)")
            }
            sccreentouched = false
                //cameraImagecache = nil
                captureSession.stopRunning()
                
                captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080;
                captureSession.startRunning()
                sleep(1)
                widthcamera = 1080
                heightcamera = 1920
                cgImagecropped = nil
                xcorrection = Float(widthcamera)/screenwidth
                ycorrection = Float(heightcamera)/screenheight
                if tap == true {if motionManager.isDeviceMotionActive == true {
                    captureSession.sessionPreset = AVCaptureSession.Preset.vga640x480;
                    widthcamera = 480
                    heightcamera = 640
                    xcorrection = Float(widthcamera)/screenwidth
                    ycorrection = Float(heightcamera)/screenheight
                    motionManager.stopDeviceMotionUpdates()};captureSession.startRunning();newdepthframe = false;}
                }
        }
}

    override func viewDidLoad() {
      //  checknewsounds()
      //   getnewsounds()
        
        accview.frame = self.view.frame
                accview.isAccessibilityElement = true
                accview.accessibilityTraits = .allowsDirectInteraction
                let SwiperightGesture = UISwipeGestureRecognizer(target:self,action:#selector(swipegright))
                SwiperightGesture.direction = .right
                SwiperightGesture.cancelsTouchesInView = false
                self.accview.addGestureRecognizer(SwiperightGesture)
                let SwipeleftGesture = UISwipeGestureRecognizer(target:self,action:#selector(swipegleft))
                SwipeleftGesture.direction = .left
                SwipeleftGesture.cancelsTouchesInView = false
                self.accview.addGestureRecognizer(SwipeleftGesture)
                let SwipeuptGesture = UISwipeGestureRecognizer(target:self,action:#selector(swipgeup))
                SwipeuptGesture.direction = .up
                SwipeuptGesture.cancelsTouchesInView = false
                self.accview.addGestureRecognizer(SwipeuptGesture)
                let SwipedownGesture = UISwipeGestureRecognizer(target:self,action:#selector(swipegdown))
                SwipedownGesture.direction = .down
                SwipedownGesture.cancelsTouchesInView = false
                self.accview.addGestureRecognizer(SwipedownGesture)
                let tapGesture = UITapGestureRecognizer(target:self,action:#selector(tapped))
                tapGesture.numberOfTapsRequired = 2
                tapGesture.cancelsTouchesInView = false
        tapGesture.delaysTouchesBegan = false
        tapGesture.delaysTouchesEnded = false
        self.accview.addGestureRecognizer(tapGesture)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        pinchGesture.cancelsTouchesInView = true
        self.accview.addGestureRecognizer(pinchGesture)
        self.view.addSubview(accview)
        
        hapticinhibittimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(timerusage), userInfo: nil, repeats: true)

        
        DispatchQueue.main.async{self.createAndStartHapticEngine()}
    }
    
    override func viewWillLayoutSubviews() {
        ratioadj = Float(view.frame.height/view.frame.width)
        //print(ratioadj)
    }
    
    
    override func viewDidLayoutSubviews(){
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        if orientationr == 0 {orientationr = UIDevice.current.orientation.rawValue}
        if soundstred == false && mode == 3 {playsoundsoraccesslibrary()}
        
    }
    
    @objc func timerusage(){
        pauseduration += Int(contintensity.value * 25)
        switch vibrating {
        case true:
            hapticusageseconds += 50 + Int(contintensity.value * 65)
            if hapticusageseconds > 800 {
                hapticusageseconds = 1000 + pauseduration
                pauseduration = 0
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            }
        default:
            hapticusageseconds -= 200
            if hapticusageseconds < 100 {hapticusageseconds = 0}
        }
        

        switch hapticusageseconds {
        case 800...:
            inhibittimer = true
            if vibrating {  do {vibrating=false
                try player?.stop(atTime: CHHapticTimeImmediate);
  
            } catch let error {
                print("Error stopping the continuous haptic player: \(error)")
            }
            }
            
            vibrating = false
            sccreentouched = false
            return
            
        default:
            inhibittimer = false
        }
    }
    
    func createAndStartHapticEngine() {
        do {
            engine = try CHHapticEngine()
        } catch let error {
            fatalError("Engine Creation Error: \(error)")
        }
        
        do {
            try engine?.start()
        } catch {
            print("Failed to start the engine: \(error)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

        screenwidth = Float(UIScreen.main.bounds.width)
        screenheight = Float(UIScreen.main.bounds.height)
        xcorrection = Float(widthcamera)/screenwidth
        ycorrection = Float(heightcamera)/screenheight
        addobserver()
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != .authorized
        {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler:
            { (authorized) in
                DispatchQueue.main.async
                {
                    if authorized
                    {
                        self.setupDevice()
                    }
                }
            })
        } else {
            setupDevice()
        }

    }

    
    override func viewDidAppear(_ animated: Bool) {
        }

    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [
            .builtInWideAngleCamera,
            .builtInUltraWideCamera,
            .builtInDualCamera,
            .builtInDualWideCamera,
            .builtInTripleCamera
        ], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back)
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == .back && backCameradepth == nil &&
                (device.deviceType == .builtInDualCamera ||
                device.deviceType == .builtInDualWideCamera ||
                device.deviceType == .builtInTripleCamera
                ) {backCameradepth = device
                depthpresence = true
                print(device)
            }
            }
        for device in devices {if device.position == .back && device != backCameradepth && backCamera == nil {backCamera = device} }
        currentCamera = backCamera
        if backCameradepth != nil{
            configureDepthCaptureSession()
        }
        setupInputOutput()
    }
    
    
  /*  func checknewsounds(){
        return
        let downloadTask = URLSession.shared.downloadTask(with: URL(string: "https://medicert.it/VibViewAudioFiles/")!) {
            urlOrNil, responseOrNil, errorOrNil in
            // check for and handle errors:
            // * errorOrNil should be nil
            // * responseOrNil should be an HTTPURLResponse with statusCode in 200..<299
            
            guard let fileURL = urlOrNil else { return }
            
            do {
                let documentsURL = try
                    FileManager.default.url(for: .documentDirectory,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: false)
                let savedURL = documentsURL.appendingPathComponent(fileURL.lastPathComponent)
                print(savedURL)
                try FileManager.default.moveItem(at: fileURL, to: savedURL)
            } catch {
                print ("file error: \(error)")
            }
        }
        downloadTask.resume()
    }
    
    
    func getnewsounds(){
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
            print(directoryContents)

            // if you want to filter the directory contents you can do like this:
            let wavFiles = directoryContents
            print("wav urls:",wavFiles)
            let sound = wavFiles[5]
            do {
                let soundplay = try AVAudioPlayer(contentsOf: sound, fileTypeHint: nil)
                soundplay.play()
                print("ibyhbu",sound.absoluteString,sound.description)
             } catch _{
                print("nosound")
               return
             }
            
            let wavFileNames = wavFiles.map{ $0.deletingPathExtension().lastPathComponent }
            print("wav list:", wavFileNames)

        } catch {
            print(error)
        }
    }
    */
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            if captureSession.canSetSessionPreset(.vga640x480) {captureSession.sessionPreset = AVCaptureSession.Preset.vga640x480} else {exit(0)}
            if captureSession.canAddInput(captureDeviceInput) {
               captureSession.addInput(captureDeviceInput)
            }
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
            if captureSession.canAddOutput(videoOutput) {
               captureSession.addOutput(videoOutput)
            }
            do {try currentCamera?.lockForConfiguration();
                if currentCamera?.hasTorch ?? false{if currentCamera?.isTorchModeSupported(.auto) == true {currentCamera?.torchMode = .auto}}
                if currentCamera?.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) == true { currentCamera?.whiteBalanceMode = .continuousAutoWhiteBalance}
                if currentCamera?.isExposureModeSupported(.continuousAutoExposure) == true {  currentCamera?.exposureMode = .continuousAutoExposure}} catch {print("no lock of camera available")}
            currentCamera?.unlockForConfiguration();
            captureSession.startRunning()
        } catch {
            print(error)
        }
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if soundstred == true {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer){
        cameraImage = CIImage(cvImageBuffer: pixelBuffer)
        playsounds(colorimage: cameraImage);return}}
   //     if sccreentouched && versionanalisys == 0 {
   //     if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer){
   //         pixelBuffer.clampfortouch()
   //         }
   //     }
        connection.videoOrientation = .portrait
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        cameraImage = CIImage(cvImageBuffer: pixelBuffer)
        if sccreentouched && cameraImage != nil && backCameradepth == nil{
            let color = cameraImage!.cropped(to: CGRect(x: min(Int(cameraImage!.extent.width),max(0,Int(xtouch) - 2)), y: min(Int(cameraImage!.extent.height),max(0,Int(ytouch) - 2)), width: 4,height: 4)).averageColor ?? 8421414
            let greencolor = Int(color/65536) //wl 520 - 565
            let bluecolor = Int(color/256)-greencolor*256 //wl 435 - 500
            let redcolor = Int(color)-bluecolor*256-greencolor*65536 //wl 625 - 740
            intensitycolorofimage = greencolor + bluecolor + redcolor
            let maxcolor = max(greencolor,bluecolor,redcolor)
            let mincolor = min(greencolor,bluecolor,redcolor)
            let diffcolor = max(maxcolor - mincolor, 1)
            if maxcolor == redcolor {gradeofcolor = CGFloat(greencolor - bluecolor)/CGFloat(diffcolor)}
            if maxcolor == greencolor {gradeofcolor = 2 + CGFloat(bluecolor - redcolor)/CGFloat(diffcolor)}
            if maxcolor == bluecolor {gradeofcolor = 4 + CGFloat(redcolor - greencolor)/CGFloat(diffcolor)}
            if gradeofcolor > 5.7 {gradeofcolor = 0}
            //var colortopass = 1
            //if max(redcolor,greencolor,bluecolor) == greencolor {colortopass = 2}
            //if max(redcolor,greencolor,bluecolor) == bluecolor {colortopass = 3}
            //let colortoload = Int(Float((redcolor + greencolor*2 + bluecolor*3) * colortopass))
        }
        processaimmagine(cameraImage: cameraImage!)
        let filteredImagea = UIImage(cgImage: cgImage!)
        accodaflusso(filteredImage: filteredImagea)
        }
    
    
    func accodaflusso(filteredImage: UIImage){
        DispatchQueue.main.async {
            if soundstred == false {  self.filteredImage.image = filteredImage
                if sccreentouched && !depthpresence && mode == 0 && captureSession.isRunning {vibradepthrt(vibr: 0.5)}
            }
        }
    }
    
    
    func playsounds(colorimage: CIImage?){
        DispatchQueue.main.async {if count > basecount && captureSession.isRunning {
            
            if withcolours == true || !depthpresence{
                
                self.createcolorframes(baseimag: colorimage!);
                count=0;sounds(environment: self.environment).changeposition(pos: depthforsound, colors: colorvalues);
            } else {
                count=0;sounds(environment: self.environment).changeposition(pos: depthforsound, colors: colorvalues);
            }}
            if depthpresence == false {count += 1}
            }
    }
    
    func createcolorframes(baseimag: CIImage){
        let transfor = CGAffineTransform(scaleX: 0.2, y: 0.2)
        let baseimage = baseimag.transformed(by: transfor)
    
     let width = baseimage.extent.width
     let height = baseimage.extent.height
     let spessorex = width/CGFloat(latoquadratoaudio)
     let spessorey = height/CGFloat(latoquadratoaudio)
        for i in 0...latoquadratoaudio-1 {
        verticalbands[i]=(baseimage.cropped(to: CGRect(x: spessorex*CGFloat(latoquadratoaudio-(i+1)), y: 0, width: spessorex, height: height)).averageColor!)
        horizontalbands[i]=(baseimage.cropped(to: CGRect(x: 0, y: spessorey*CGFloat(i), width: width, height: spessorey)).averageColor!)
        }
     differenceincolor = 0
     for i in 0...latoquadratoaudio*latoquadratoaudio-1 {
     let ypos = Int((i)/latoquadratoaudio)
     let xpos = i - ypos*latoquadratoaudio
            let greencolorv = Int(verticalbands[xpos]/65536)
            let bluecolorv = Int(verticalbands[xpos]/256)-greencolorv*256
            let redcolorv = Int(verticalbands[xpos])-bluecolorv*256-greencolorv*65536
            let greencolorh = Int(horizontalbands[ypos]/65536)
            let bluecolorh = Int(horizontalbands[ypos]/256)-greencolorh*256
            let redcolorh = Int(horizontalbands[ypos])-bluecolorh*256-greencolorh*65536
        //colorvalues[i][1] = (redcolorv+redcolorh+greencolorv+greencolorh+bluecolorv+bluecolorh)/16
        let red = (redcolorv+redcolorh)
        let green = (greencolorv+greencolorh)
        let blue = (bluecolorv+bluecolorh)
        var colortopass = 1
        if max(red,green,blue) == green {colortopass = 2}
        if max(red,green,blue) == blue {colortopass = 3}
        let colortoload = Int(Float((red + green*2 + blue*3) * colortopass))
        if !depthpresence {
            let value = abs(Float(1 + colortoload)/Float(1 + colorvalues[i]))
            differenceincolor += max(value,1/value) - 1}
        if updatecolors || depthpresence {colorvalues[i] = colortoload}
     }
        updatecolors = false
        if differenceincolor > 1.8 {updatedepth = true;updatecolors = true;depthforsoundml(cameraImage: baseimag)}
        return
    }

    func depthforsoundml(cameraImage: CIImage) {
        var cgImage2 : CGImage?
            switch orientationr {
            case 3:
                let rotatedImage = cameraImage.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.right.rawValue))
                let rotaterect = CGRect(x: Int((rect?.origin.y)!), y: Int((rect?.origin.x)!), width: Int(rect!.height), height: Int(rect!.width))
                cgImage2 = self.context.createCGImage(rotatedImage, from: rotaterect)!
            case 4:
                let rotatedImage = cameraImage.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.left.rawValue))
                let rotaterect = CGRect(x: Int((rect?.origin.y)!), y: Int((rect?.origin.x)!), width: Int(rect!.height), height: Int(rect!.width))
                cgImage2 = self.context.createCGImage(rotatedImage, from: rotaterect)!
            default:
                cgImage2 = self.context.createCGImage(cameraImage, from: rect!)!
            }
        let postprocessor = HeatmapPostProcessor()
        if model == nil {model = try! VNCoreMLModel(for: FCRNFP16().model)}
        let request = VNCoreMLRequest(model: model!)
        let handler = VNImageRequestHandler(cgImage: cgImage2!)
        try! handler.perform([request])
        if let observations = request.results as? [VNCoreMLFeatureValueObservation],
            let heatmap = observations.first?.featureValue.multiArrayValue {
            convertedHeatmap = postprocessor.convertTo2DArray(from: heatmap)
            if soundstred == true{
                let intervaly = Float(128/latoquadratoaudio)
                let intervalx = Float(160/latoquadratoaudio)
                for lx in 0...latoquadratoaudio-1 {
                    for ly in 0...latoquadratoaudio-1 {
                        var valuecell : Float = 0
                        var dimensioncell = 0
                        for x in stride(from: Int(intervalx*Float(lx)), to : Int(intervalx*Float(lx+1)), by: 1){
                            for y in stride(from: Int(intervaly*Float(ly)), to : Int(intervaly*Float(ly+1)), by: 1){
                                valuecell += Float(convertedHeatmap[x][127-y])*7
                                    dimensioncell += 1
                                    }
                                    }
                                    depthforsound[lx + ly*latoquadratoaudio] = valuecell/Float(dimensioncell)
                        
                        
                       
                    }
                                    }
            }
        
        }}
    
    
    func processaimmagine (cameraImage : CIImage) {
        rect = cameraImage.extent
        switch versionanalisys {
        case 1:
                let comicEffect = CIFilter(name: "CIGaussianBlur") // CIPhotoEffectChrome
                comicEffect!.setDefaults()
                comicEffect!.setValue(cameraImage, forKey: kCIInputImageKey)
                comicEffect!.setValue(CGFloat(120)-min(3,CGFloat((forceoftouch))*40), forKey: "inputRadius")
            
            cgImage = self.context.createCGImage(comicEffect!.outputImage!, from: rect!)!
        default:
                let comicEffect = CIFilter(name: "CIEdges") // CIPhotoEffectChrome
                comicEffect!.setDefaults()
                comicEffect!.setValue(cameraImage, forKey: kCIInputImageKey)
                comicEffect!.setValue(7, forKey: "inputIntensity")
            let comicEffect2 = CIFilter(name: "CIAdditionCompositing") // CIPhotoEffectChrome
            comicEffect2!.setDefaults()
            comicEffect2!.setValue(comicEffect!.outputImage!, forKey: kCIInputImageKey)
            comicEffect2!.setValue(cameraImage, forKey: kCIInputBackgroundImageKey)
            //comicEffect2!.setValue(7, forKey: "inputIntensity")
            cgImage = self.context.createCGImage(comicEffect2!.outputImage!, from: rect!)!
        }
        
        let semaphore = DispatchSemaphore(value: 0)
        if tap == false {semaphore.signal();captureSession.stopRunning();newdepthframe = false
        let postprocessor = HeatmapPostProcessor()
        let comicEffect = CIFilter(name: "CINoiseReduction")
        comicEffect!.setDefaults()
        comicEffect!.setValue(cameraImage, forKey: kCIInputImageKey)
        var cgImage2 : CGImage?
            switch orientationr {
            case 3:
                let rotatedImage = comicEffect!.outputImage!.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.right.rawValue))
                let rotaterect = CGRect(x: Int((rect?.origin.y)!), y: Int((rect?.origin.x)!), width: Int(rect!.height), height: Int(rect!.width))
                cgImage2 = self.context.createCGImage(rotatedImage, from: rotaterect)!
            case 4:
                let rotatedImage = comicEffect!.outputImage!.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.right.rawValue))
                let rotaterect = CGRect(x: Int((rect?.origin.y)!), y: Int((rect?.origin.x)!), width: Int(rect!.height), height: Int(rect!.width))
                cgImage2 = self.context.createCGImage(rotatedImage, from: rotaterect)!
            default:
                cgImage2 = self.context.createCGImage(comicEffect!.outputImage!, from: rect!)!
            }
            if model == nil { model = try! VNCoreMLModel(for: FCRNFP16().model)}
            let request = VNCoreMLRequest(model: model!)
            let handler = VNImageRequestHandler(cgImage: cgImage2!)
        try! handler.perform([request])
        if let observations = request.results as? [VNCoreMLFeatureValueObservation],
            let heatmap = observations.first?.featureValue.multiArrayValue {
            convertedHeatmap = postprocessor.convertTo2DArray(from: heatmap)
            if soundstred == true{
                
                let intervaly = Float(128/latoquadratoaudio)
                let intervalx = Float(160/latoquadratoaudio)
                for lx in 0...latoquadratoaudio-1 {
                    for ly in 0...latoquadratoaudio-1 {
                        var valuecell : Float = 0
                        var dimensioncell = 0
                        for x in stride(from: Int(intervalx*Float(lx)), to : Int(intervalx*Float(lx+1)), by: 1){
                            for y in stride(from: Int(intervaly*Float(ly)), to : Int(intervaly*Float(ly+1)), by: 1){
                                valuecell -= Float(convertedHeatmap[x][127-y])*18
                                
                                    dimensioncell += 1
                                    }
                                    }
                                    depthforsound[lx + ly*latoquadratoaudio]=valuecell/Float(dimensioncell)
                       
                    }
                                    }
                semaphore.wait()
            return
            }
            
            newdepthframe = true
            let generator = UIImpactFeedbackGenerator();generator.impactOccurred()
            }
            }
    }

    func processaimmaginezoom (cameraImage : CIImage){
        rect = cameraImage.extent
        let semaphore = DispatchSemaphore(value: 0)
        if tap == false {semaphore.signal();captureSession.stopRunning();newdepthframe = false
        let postprocessor = HeatmapPostProcessor()
        let comicEffect = CIFilter(name: "CINoiseReduction")
        comicEffect!.setDefaults()
        comicEffect!.setValue(cameraImage, forKey: kCIInputImageKey)
        var cgImage2 : CGImage?
            switch orientationr {
            case 3:
                let rotatedImage = comicEffect!.outputImage!.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.left.rawValue))
                let rotaterect = CGRect(x: Int((rect?.origin.y)!), y: Int((rect?.origin.x)!), width: Int(rect!.height), height: Int(rect!.width))
                cgImage2 = self.context.createCGImage(rotatedImage, from: rotaterect)!
            case 4:
                let rotatedImage = comicEffect!.outputImage!.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.right.rawValue))
                let rotaterect = CGRect(x: Int((rect?.origin.y)!), y: Int((rect?.origin.x)!), width: Int(rect!.height), height: Int(rect!.width))
                cgImage2 = self.context.createCGImage(rotatedImage, from: rotaterect)!
            default:
                cgImage2 = self.context.createCGImage(comicEffect!.outputImage!, from: rect!)!
            }

            if model == nil { model = try! VNCoreMLModel(for: FCRNFP16().model)}
            let request = VNCoreMLRequest(model: model!)
            let handler = VNImageRequestHandler(cgImage: cgImage2!)
        try! handler.perform([request])
        if let observations = request.results as? [VNCoreMLFeatureValueObservation],
            let heatmap = observations.first?.featureValue.multiArrayValue {
            convertedHeatmap = postprocessor.convertTo2DArray(from: heatmap)
            semaphore.wait()
            newdepthframe = true
            let generator = UIImpactFeedbackGenerator();generator.impactOccurred()
            }
            }
    }
    

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!captureSession.isRunning && tap == true) || (soundstred == false && !audioPlayer.isEmpty) || pinching {return}
        if inhibittimer == true {return}
        sccreentouched = false;
        motionManager.stopDeviceMotionUpdates();corrtiltx = 10;corrtilty = 10;prem12 = 0;prem33 = 0;prem23 = 0;prem21 = 0;timetowave = CACurrentMediaTime() - 10000;
        do {
            try player?.stop(atTime: CHHapticTimeImmediate);vibrating = false;
        } catch let error {
            print("Error stopping the continuous haptic player: \(error)")
        }
    }
    
    
    
    
 //   override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
      //  if motion == .motionShake  {
      //      playsoundsoraccesslibrary(type: 2)
      //  }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (soundstred == false && !audioPlayer.isEmpty) || pinching  {return}
        
        
            if self.traitCollection.forceTouchCapability == .unavailable {
                tdtouchabsencedefault = 1
            }
        
        if inhibittimer == true {return}
        
        sccreentouched = true;
       
        if let touch = touches.first {tocchi = touches;
          let location = touch.location(in: self.accview)
            xtouch = Float(location.x)*xcorrection
            ytouch = (Float(screenheight) - Float(location.y))*ycorrection
            forceoftouch = Float(max(touch.force,tdtouchabsencedefault))
        }
        if rengine.isRunning == true {return}
        
        if versionanalisys == 2 {return}
        
        if newdepthframe == false && tap == false {return}
        
        if tap == false && !pinching {corrtiltx = 10; corrtilty = 10;motionManager.startDeviceMotionUpdates();motion()}

        
        switch tap {
        case true:
            touchvibr = 1;corrtilty=0;corrtiltx=0; analizza(touches); if depthpresence == false && versionanalisys == 1 {vibracolor(color: colortovibr, vibr: 0)}
        default:
            if newdepthframe == false {return}
            analizza(touches);
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)  {
        if (soundstred == false && !audioPlayer.isEmpty) || pinching  {return}
        if rengine.isRunning == true {return}
        if inhibittimer == true {return}
        if versionanalisys == 2 {return}
        prextouch = xtouch;preytouch = ytouch
        if newdepthframe == false && tap == false {return}
        if tap == false && !pinching {motion()}
        if let touch = touches.first {tocchi = touches;
            let location = touch.location(in: self.accview)
            xtouch = Float(location.x)*xcorrection
            ytouch = (Float(screenheight) - Float(location.y))*ycorrection
            deltamove = sqrt(pow(prextouch-xtouch,2)+pow(preytouch-ytouch,2))
            forceoftouch = Float(max(touch.force,tdtouchabsencedefault))
        }
        switch tap {
        case true:
            touchvibr = 1;corrtilty=0;corrtiltx=0;analizza(touches);if depthpresence == false && versionanalisys == 1 {vibracolor(color: colortovibr, vibr: 0)}
        default:
            if newdepthframe == false {return}
            analizza(touches);
        }
    }
    
    
    func motion() {
        if motionManager.isDeviceMotionActive == false{
        if motionManager.isDeviceMotionAvailable {
        motionManager.deviceMotionUpdateInterval = 1.0 / 20
            if sccreentouched == true && tap == false && newdepthframe == true {
                motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical, to: .main) { (data, error)
            in if data != nil {
                rotationmatrix = motionManager.deviceMotion?.attitude.rotationMatrix
                if rotationmatrix != nil {if corrtiltx == 10 && corrtilty == 10 {prem21 = Float(Double(rotationmatrix!.m21));prem23 = Float(Double(rotationmatrix!.m23));prem12 = Float(Double(rotationmatrix!.m12)) + Float(Double(rotationmatrix!.m21));prem33 = Float(Double(rotationmatrix!.m33))};
                 
                    switch orientationr {
                    case 3:
                        corrtilty = (prem21 ?? 0) - Float(rotationmatrix?.m21 ?? 0);corrtiltx = (prem33 ?? 0) - Float(rotationmatrix?.m33 ?? 0);
                    case 4:
                        corrtilty = (prem21 ?? 0) - Float(rotationmatrix?.m21 ?? 0);corrtiltx = -((prem33 ?? 0) - Float(rotationmatrix?.m33 ?? 0));
                    default:
                        corrtiltx = (prem12 ?? 0) - (Float(rotationmatrix?.m12 ?? 0) + Float(rotationmatrix!.m21));corrtilty = (prem33 ?? 0) - Float(rotationmatrix?.m33 ?? 0);
                    }
                    
                    
                    
                    
                }
                self.vibradepth();self.analizza(tocchi!)
            }}}
            }
        } else {self.vibradepth()}}
    

    
    
    
    func vibradepth() {
        if !sccreentouched {return}
       //     let rect = rectangle ?? cameraImage!.extent
       //     let correctionx = Float(rect.width/(cameraImage?.extent.width ?? 0))
        //    let correctiony = Float(rect.height/(cameraImage?.extent.height ?? 0))
       //     intensitycolorofimage = cameraImage!.cropped(to: rect).cropped(to: CGRect(x: Int(correctionx*min(Float(cameraImage!.extent.width),max(0,xtouch - 2))), y: Int(correctiony*min(Float(cameraImage!.extent.height),max(0,ytouch - 2))), width: 4,height: 4)).averageColorsum ?? 765}
        intensitycolorofimage = 1
        var xtouchcorr = Float(0)
        var ytouchcorr = Float(0)
        switch orientationr{
        case 4:
             xtouchcorr = (ytouch - corrtilty*1000*ratioadj)/12
             ytouchcorr = (xtouch - corrtiltx*1000)/8.4375
           
            if xtouchcorr > 159 || xtouchcorr < 0 || ytouchcorr > 127 || ytouchcorr < 0 {
                do {
                    try player?.stop(atTime: CHHapticTimeImmediate);vibrating=false
                } catch let error {
                    print("Error stopping the continuous haptic player: \(error)")
                }
                return} else { touchvibr = Float(min(max(0,(1-convertedHeatmap [min(159,Int(xtouchcorr))][min(127,Int(ytouchcorr))])),1))}
            
            
            
        case 3:
             xtouchcorr = (ytouch + corrtilty*1000*ratioadj)/12
             ytouchcorr = (xtouch + corrtiltx*1000)/8.4375
            
      // print(xtouchcorr,ytouchcorr)
            if xtouchcorr > 159 || xtouchcorr < 0 || ytouchcorr > 127 || ytouchcorr < 0 {
                do {
                    try player?.stop(atTime: CHHapticTimeImmediate);vibrating=false
                } catch let error {
                    print("Error stopping the continuous haptic player: \(error)")
                }
                return} else {touchvibr = Float(min(max(0,(1-convertedHeatmap [min(159,Int(xtouchcorr))][min(127,128-Int(ytouchcorr))])),1))}
            
            
        default:
             xtouchcorr = (xtouch + corrtiltx*1000)/6.75
             ytouchcorr = (ytouch + corrtilty*1000*ratioadj)/16
            
           // print(xtouchcorr,ytouchcorr)
            if xtouchcorr > 159 || xtouchcorr < 0 || ytouchcorr > 127 || ytouchcorr < 0 {
                do {
                    try player?.stop(atTime: CHHapticTimeImmediate);vibrating=false
                } catch let error {
                    print("Error stopping the continuous haptic player: \(error)")
                }
                return} else {touchvibr = Float(min(max(0,(1-convertedHeatmap [min(159,Int(xtouchcorr))][min(127,128-Int(ytouchcorr))])),1))}
            
            
        }
        pretouchvibr = touchvibr
        if touchvibr > pretouchvibr + 0.15 {let gen = UIImpactFeedbackGenerator(); gen.impactOccurred(intensity: CGFloat(min(1,touchvibr - pretouchvibr)));}
        let adjustwithforce = Float(forceoftouch)
        pretouchvibr=(touchvibr + pretouchvibr*10)/11
        if inhibittimer == true {return}
        if newdepthframe == false && tap == false {return}


        let differencetouchvibr = (touchvibr-pretouchvibr)*adjustwithforce*deltamove/6
       
        
        let inte = Float(max(0,min(1,touchvibr + differencetouchvibr))); //let sharp = Float(max(0,min(1,1-touchvibr*differencetouchvibr)))
        let intensityvar = Float(max(0.01,min(1,pow(inte, 0.7))))/max(0.001,contintensity.value)
        let sharpnessvar = Float(max(0,min(1,1-inte))) - contsharpness.value
        switch vibrating {
        case true:
            let intensityParameter = CHHapticDynamicParameter(parameterID: .hapticIntensityControl,
                                                              value: intensityvar,
                                                                          relativeTime: 0)
                        
            let sharpnessParameter = CHHapticDynamicParameter(parameterID: .hapticSharpnessControl,
                                                              value: sharpnessvar,
                                                                          relativeTime: 0)
                        
            do {
                            try player?.sendParameters([intensityParameter, sharpnessParameter],
                                                                atTime: 0)
                        } catch let error {
                            print("Dynamic Parameter Error: \(error)")}
            default:
                        contintensity = CHHapticEventParameter(parameterID: .hapticIntensity, value:  Float(max(0.01,min(1,pow(inte, 0.7)))))
                        contsharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(max(0,min(1,1-inte))))

            do {
                let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [contintensity, contsharpness], relativeTime:0, duration: 10000)
                let pattern = try CHHapticPattern(events: [event], parameters: [])
                player = try engine?.makeAdvancedPlayer(with: pattern)
                if !inhibittimer { try player?.start(atTime: 0)
                vibrating = true;}
        
                } catch {
                print("Failed to play pattern: \(error.localizedDescription).")
            }}
        }
    
    override func didReceiveMemoryWarning() {
       basecount += 5
      //  print(basecount)
    }
    
    
    
    func analizza(_ touches: Set<UITouch>) {
        if inhibittimer == true {return}
        var touch = touches.first
        if(touch?.force != 0) {forceoftouch = Float(touch?.force ?? 1)} else {touch=tocchi?.first}
        if (touch?.location(in: view)) != nil {
            let color = self.filteredImage.image?.averageColor
            //let color = filteredImage.getPixelColorAt(atPosition: point)
            if versionanalisys == 1 {colortovibr = color ?? previousColor;return}
            var redval1: CGFloat = 0
            var greenval1: CGFloat = 0
            var blueval1: CGFloat = 0
            var alphaval1: CGFloat = 0
            var redval: CGFloat = 0
            var greenval: CGFloat = 0
            var blueval: CGFloat = 0
            var alphaval: CGFloat = 0
            previousColor.getRed(&redval1, green: &greenval1, blue: &blueval1, alpha: &alphaval1);
            color?.getRed(&redval, green: &greenval, blue: &blueval, alpha: &alphaval);
            let sumofdifferences = abs(redval1 - redval) + abs(greenval1 - greenval) + abs(blueval1 - blueval)
            if sumofdifferences > 0.2 && forceoftouch != 0 {
                let maxcolor = max(greenval,blueval,redval)
                let mincolor = min(greenval,blueval,redval)
                let diffcolor = max(maxcolor - mincolor, 1)
                if maxcolor == redval {gradeofcolor = CGFloat(greenval - blueval)/CGFloat(diffcolor)}
                if maxcolor == greenval {gradeofcolor = 2 + CGFloat(blueval - redval)/CGFloat(diffcolor)}
                if maxcolor == blueval {gradeofcolor = 4 + CGFloat(redval - greenval)/CGFloat(diffcolor)}
                if gradeofcolor > 5.7 {gradeofcolor = 0}
                let colorpattern = Array(repeating: gradeofcolor, count: 1)
                let colorintensity = Float((redval + greenval + blueval) - abs(greenval - blueval) - abs(blueval - redval) - abs(redval - greenval))/3
                let intervaltime = 0//((log10(1+(redval/greenval)/blueval))/(redval + greenval + blueval))*100
                var events = [CHHapticEvent]()
                    if vibrating == true {
                            do {
                                try player?.stop(atTime: CHHapticTimeImmediate); vibrating = false;
                    } catch let error {
                        print("Error stopping the continuous haptic player: \(error)")
                    }
                    }
                    for i in stride(from: 0, to: 1, by: 1) {
                        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: colorintensity*Float(pow(forceoftouch, 0.5)))
                        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(colorpattern[i]))
                        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: Double(intervaltime/4))
                        events.append(event)
                    }
                    do {
                        let pattern = try CHHapticPattern(events: events, parameters: [])
                        player = try engine?.makeAdvancedPlayer(with: pattern)
                        if !inhibittimer {  try player?.start(atTime: 0)}
                        events.removeAll()
                    } catch {
                        print("Failed to play pattern: \(error.localizedDescription).")
                    };
                self.view.isUserInteractionEnabled = true
                
               }
            if let pcolor = color {previousColor = pcolor};
        }
    }
    

    
    
/*
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else {
            
            return
        }
        if (image.imageOrientation.rawValue != UIDevice.current.orientation.rawValue) {AudioServicesPlaySystemSound(4095)}
        let acquiredimage = CIImage(image: image)
        convertedHeatmap.removeAll()
        processaimmagine(cameraImage: acquiredimage!)
        let filteredImagea = UIImage(cgImage: cgImage!)
        filteredImage.image = filteredImagea
            }

   */
    func configureDepthCaptureSession() {
        captureSession.sessionPreset = .vga640x480
      do {let cameraInput = try AVCaptureDeviceInput(device: (self.backCameradepth!))
        captureSession.addInput(cameraInput)} catch {fatalError(error.localizedDescription)}
      let videoOutput = AVCaptureVideoDataOutput()
      videoOutput.setSampleBufferDelegate(self, queue: .main)
      videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
      captureSession.addOutput(videoOutput)
      let videoConnection = videoOutput.connection(with: .video)
      videoConnection?.videoOrientation = .portrait
      let depthOutput = AVCaptureDepthDataOutput()
        depthOutput.setDelegate(self, callbackQueue: .main)
      depthOutput.isFilteringEnabled = true
      captureSession.addOutput(depthOutput)
      let depthConnection = depthOutput.connection(with: .depthData)
      depthConnection?.videoOrientation = .portrait

        do {try self.backCameradepth?.lockForConfiguration();
                    if self.backCameradepth?.isLowLightBoostSupported == true {self.backCameradepth?.automaticallyEnablesLowLightBoostWhenAvailable = true}
                    if backCameradepth?.hasTorch ?? false{if backCameradepth?.isTorchModeSupported(.auto) == true {backCameradepth?.torchMode = .auto}}
                    if self.backCameradepth?.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) == true {self.backCameradepth?.whiteBalanceMode = .continuousAutoWhiteBalance}
                    if self.backCameradepth?.isExposureModeSupported(.continuousAutoExposure) == true {self.backCameradepth?.exposureMode = .continuousAutoExposure}
            } catch {
                print("error")
            }
            if let format = self.backCameradepth?.activeDepthDataFormat,
              let range = format.videoSupportedFrameRateRanges.first  {
              self.backCameradepth?.activeVideoMinFrameDuration = range.minFrameDuration
            }
            self.backCameradepth?.unlockForConfiguration()
        }
    
    func toggleTorch() {
        let device : AVCaptureDevice?
        switch backCameradepth {
        case nil:
            device = currentCamera
        default:
            device = backCameradepth
        }
        if device!.hasTorch {
            do {
                try device?.lockForConfiguration()
                if device?.torchMode.rawValue == 0 {
                    device?.torchMode = .on;AudioServicesPlaySystemSound(4095);
                } else {
                    device?.torchMode = .off;
                }
                device?.unlockForConfiguration()
            } catch {
                print("No torch")
            }
        } else {
            print("No torch")
        }
    }

    func addobserver(){NotificationCenter.default.addObserver(
        self,
        selector: #selector(tempchange),
        name: ProcessInfo.thermalStateDidChangeNotification,
        object: nil
        )}
   @objc func tempchange(){
    let state = ProcessInfo.processInfo.thermalState.rawValue;
    if state == 0 {basecount = 2}
    if state > 2 {basecount = 10}
    if (state < 2 && latoquadratoaudio == 5) || (state > 1 && latoquadratoaudio == 3) || soundstred == false {return}
    //print("obs",state)
    if rengine.isRunning {for i in 0...audioPlayer.count - 1 {rengine.detach(audioPlayer[i])};let a = sounds(environment: environment).endplay();environment.reset();soundstred = a;}
    if state > 1 {latoquadratoaudio = 3} else {latoquadratoaudio = 5}
    sounds(environment: environment).playsounds()
    }
    
}

/*
extension CVPixelBuffer {
func clampfortouch() {
  let width = CVPixelBufferGetWidth(self) // 240
  let height = CVPixelBufferGetHeight(self) // 320
  CVPixelBufferLockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
  let floatBuffer = unsafeBitCast(CVPixelBufferGetBaseAddress(self), to: UnsafeMutablePointer<Float>.self)
    let borderareaoftouch = 15
    let startx = xtouch - borderareaoftouch/2
    let endx = startx + borderareaoftouch
    let starty = ytouch - borderareaoftouch/2
    let endy = starty + borderareaoftouch
    var valuecell : Float = 1
              for x in stride(from: startx, to : endx, by: 1){
                  for y in stride(from: starty, to : endy, by: 1){
                      var value = floatBuffer[y * width + x]
                      
                         
                         
                          }
                          }
              if abs(depthforsound[lx + ly*latoquadratoaudio] - valuecell/Float(dimensioncell)) > 0.1 {depthforsound[lx + ly*latoquadratoaudio] = valuecell/Float(dimensioncell)}
              

      
      CVPixelBufferUnlockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
  return
    }}

*/

extension CVPixelBuffer {
  func clamp() {
    var maxpixel : Float = 0
    var minpixel : Float = 10
    var adjustscale : Float = 1
    let width = CVPixelBufferGetWidth(self) // 240
    let height = CVPixelBufferGetHeight(self) // 320
    CVPixelBufferLockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
    let floatBuffer = unsafeBitCast(CVPixelBufferGetBaseAddress(self), to: UnsafeMutablePointer<Float>.self)
    if soundstred == true{
        let intervaly = Float((height + 1)/latoquadratoaudio)
        let intervalx = Float((width + 1)/latoquadratoaudio)
        for lx in 0...latoquadratoaudio-1 {
            for ly in 0...latoquadratoaudio-1 {
                var valuecell : Float = 1
                var dimensioncell = 1
                for x in stride(from: Int(intervalx*Float(lx)), to : Int(intervalx*Float(lx+1)), by: stepforaudio){
                    for y in stride(from: Int(intervaly*Float(ly)), to : Int(intervaly*Float(ly+1)), by: stepforaudio){
                        var valuetoadd = floatBuffer[y * width + x]
                        if valuetoadd < 0 {valuetoadd = 5 - valuetoadd}
                            valuecell = valuecell + (7 - valuetoadd)
                            dimensioncell += 1
                            }
                            }
                if abs(depthforsound[lx + ly*latoquadratoaudio] - valuecell/Float(dimensioncell)) > 0.1 {depthforsound[lx + ly*latoquadratoaudio] = valuecell/Float(dimensioncell)}
                
            }
                            }
        
        CVPixelBufferUnlockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
    return
    }
    var mediumdistance : Float = 0
    var inclination : Float = 0
    var granulosity : Float = 0
    var prepixel : Float = 0
    
        switch versionanalisys {
        case 2:
            countforbast += 1
            switch typeofcane {
            case true:
                for y in stride(from: 0, to: 320, by: 1) {
                for x in stride(from: 0, to: 240, by: 1) {
                    var pixel = floatBuffer[y * width + x]
                    if pixel < 0 {pixel = 5 - pixel}
                    let corr = Int(x-Int(xtouch/2.6667))
                        if x > 0 {
                            inclination += (pixel-prepixel)*Float(corr.signum())
                                }
                        if x != 240 {prepixel = pixel}
                                                        }
                  };
                let incl = (preinclination*2+inclination)/3
                if sccreentouched == true && countforbast > 15{vibradepthrtbast(vibr: 0.1, inclination: incl)}
                preinclination = incl
            default:
                for y in stride(from: 150, to: 170, by: 1) {
                for x in stride(from: 110, to: 130, by: 1) {
                  var pixel = floatBuffer[y * width + x]
                    if pixel < 0 {pixel = 5 - pixel}
                    mediumdistance += pixel
                    granulosity += abs(pixel-prepixel)
                    if x != 130 {prepixel = pixel}
                }
                  };
                let incl = (preinclination*5+inclination)/6
                var distance = mediumdistance
                if abs(distance - prebastdistance) < 200 {distance = (prebastdistance*3 + mediumdistance)/4}
                prebastdistance = mediumdistance
                if firstcanedistance == true {maxbastonedistance = distance; firstcanedistance = false}
                if distance > maxbastonedistance && countforbast > 15 {vibradepthrtbast(vibr: 0.9, inclination: -(granulosity/abs(mediumdistance)*10000-200))//hapticevent(intensit: granulosity/abs(mediumdistance))
                preinclination = incl
                } else
                {
                    do {
                        try player?.stop(atTime: CHHapticTimeImmediate); vibrating = false
                    } catch let error {
                        print("Error stopping the continuous haptic player: \(error)")
                    }
                }

            }
        case 1:
            if sccreentouched == true && tap == true {vibracolor(color: colortovibr,vibr: (floatBuffer[Int((1280-ytouch)/4) * width + Int(xtouch/3)]))}
        default:
            var x : Int!
            var y : Int!
            
            if sccreentouched == true {
            x = Int(xtouch/2) //Int(1/(Double(forceoftouch ?? 0)-1.5))
            y = Int((640-ytouch)/2) //Int(1/(Float(forceoftouch ?? 0)-1.5))
                let adjustareaforc = (15-Float((forceoftouch)*2.5-2))*15
            let adjustareaforce = Int(adjustareaforc)
            let yareastart = max(0,y-(adjustareaforce))
            let yareaend = min(height,y+(adjustareaforce))
            let xareastart = max(0,x-(adjustareaforce))
            let xareaend = min(width,x+(adjustareaforce))
                
            for y in stride(from: yareastart, to: yareaend, by: 1) {
            for x in stride(from: xareastart, to: xareaend, by: 1) {
               
              var pixel = floatBuffer[y * width + x]
                if pixel < 0 {pixel = 5 - pixel}
              if pixel > maxpixel {maxpixel = pixel}
              if pixel < minpixel {minpixel = pixel}
              //floatBuffer[y * width + x] = min(1.0, max(pixel, 0.0))
            }
                };adjustscale = (maxpixel-minpixel);
        }
            if sccreentouched == true && tap == true {
                var a = (floatBuffer[x * width + y])
                if a < 0 {a = 5 - a}
                vibradepthrt(vibr: a/adjustscale)}
    };

    CVPixelBufferUnlockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
  }
}



func vibradepthrt(vibr: Float) {
    if vibr > previbr + 0.15 {let gen = UIImpactFeedbackGenerator(); gen.impactOccurred(intensity: CGFloat(min(1,vibr - previbr)));}
    let adjustwithforce = Float(forceoftouch)*0.7
    let vibradj = pow(vibr+1,1.3)-1+(vibr-previbr)*pow(adjustwithforce,0.3)*deltamove/20
    print(vibradj)
    previbr=(vibr + previbr*10)/11
    if inhibittimer == true {return}

    let luminosity = 0.3333 + Float(intensitycolorofimage)/1152
    var sha = Float(0)
    if depthpresence {sha = Float(max(0,min(1,1-vibradj)))} else {sha = 1 - Float(gradeofcolor/5)}
    switch vibrating {
    case true:
        let intensityvar = Float(luminosity/contintensity.value)
        let sharpnessvar = sha - contsharpness.value
        let intensityParameter = CHHapticDynamicParameter(parameterID: .hapticIntensityControl,
                                                          value: intensityvar,
                                                          relativeTime: 0)
        
        let sharpnessParameter = CHHapticDynamicParameter(parameterID: .hapticSharpnessControl,
                                                          value: sharpnessvar,
                                                          relativeTime: 0)

        
        do {
            try player?.sendParameters([intensityParameter, sharpnessParameter],
                                                atTime: 0)
        } catch let error {
            print("Dynamic Parameter Error: \(error)")
        };
        
    default:
                contintensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: luminosity)
                contsharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sha)
    do {
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [contintensity, contsharpness], relativeTime:0, duration: 10000)
        let pattern = try CHHapticPattern(events: [event], parameters: [])
        player = try engine?.makeAdvancedPlayer(with: pattern)
        if !inhibittimer {   try player?.start(atTime: 0)}
        vibrating = true;
                
        } catch {
        print("Failed to play pattern: \(error.localizedDescription).")
        }
}
}

func vibradepthrtbast(vibr: Float, inclination: Float) {
    let value = (max(-1,min(1,max(-200,inclination)/200))+1)/2
    let vibrintensity = max(abs(value-0.5)*2,vibr)
                contintensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: max(0.001,vibrintensity))
                contsharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: value)
            do {
                let event = CHHapticEvent(eventType: .hapticTransient, parameters: [contintensity, contsharpness], relativeTime:0)
        let pattern = try CHHapticPattern(events: [event], parameters: [])
        player = try engine?.makeAdvancedPlayer(with: pattern)
                if !inhibittimer {  try player?.start(atTime: 0)}
        vibrating = true
                countforbast = 0
        } catch {
        print("Failed to play pattern: \(error.localizedDescription).")
        }
}


func vibracolor(color: UIColor, vibr: Float) {
    if inhibittimer == true {return}
    var events = [CHHapticEvent]()
    var redval1: CGFloat = 0
    var greenval1: CGFloat = 0
    var blueval1: CGFloat = 0
    var alphaval1: CGFloat = 0
    color.getRed(&redval1, green: &greenval1, blue: &blueval1, alpha: &alphaval1);
    var inte = Float(redval1+greenval1+blueval1)/6 + 0.3
    if CACurrentMediaTime()-timetowave  < patternvibrcolor?.duration ?? 0 && abs(vibr-previbr)<2/abs(previbr){previbr = vibr;return}
    if abs(vibr-previbr)>=2/abs(previbr) {inte=0}
    previbr = vibr
    let arrayvibrcolor = [pow(inte,Float(redval1/(greenval1))),pow(inte,Float(redval1/(blueval1))),pow(inte,Float(greenval1/((redval1+blueval1)/2))),pow(inte,Float(greenval1/((blueval1)))),pow(inte,Float(blueval1/(greenval1))),pow(inte,Float(blueval1/(redval1)))]
        for i in stride(from: 0, to: 6, by: 1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1-arrayvibrcolor[i])
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: arrayvibrcolor[i])
            let intervall : TimeInterval = TimeInterval((arrayvibrcolor[i]/7))
            let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime:0.2*Double(i), duration: 0.1+intervall*Double(i))
    events.append(event)
    }
    do {
        try player?.stop(atTime: CHHapticTimeImmediate)
    } catch let error {
        print("Error stopping the continuous haptic player: \(error)");return
    }
        do {
    patternvibrcolor = try CHHapticPattern(events: events, parameters: [])
    player = try engine?.makeAdvancedPlayer(with: patternvibrcolor!)
            if !inhibittimer {  try player?.start(atTime: 0)}
    timetowave =  CACurrentMediaTime()
    events.removeAll()
            
    } catch {
    print("Failed to play pattern: \(error.localizedDescription).");return
    }
    
}


extension ViewController: AVCaptureDepthDataOutputDelegate {
  func depthDataOutput(_ output: AVCaptureDepthDataOutput,
                       didOutput depthData: AVDepthData,
                       timestamp: CMTime,
                       connection: AVCaptureConnection) {
    guard tap != false else {
      return
    }
    var convertedDepth: AVDepthData
    let depthDataType = kCVPixelFormatType_DisparityFloat32
    if depthData.depthDataType != depthDataType {
      convertedDepth = depthData.converting(toDepthDataType: depthDataType)
    } else {
      convertedDepth = depthData
    }
    let pixelBuffer = convertedDepth.depthDataMap
                    
    DispatchQueue.main.async { if (soundstred == true && (depthforsound[0] != -1 || count < basecount)) || !captureSession.isRunning {count+=1;return}; pixelBuffer.clamp()}
  }
}




extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else {return nil }
        let xcorr = Float(inputImage.extent.width/CGFloat(widthcamera));
        let ycorr = Float(inputImage.extent.height/CGFloat(heightcamera))
        var xforextent : CGFloat?;var yforextent : CGFloat?
        xforextent = CGFloat(xtouch*xcorr) + CGFloat(Int(corrtiltx*1000) - 2); yforextent = (CGFloat(ytouch*ycorr) + CGFloat(Int(corrtilty*1000*ratioadj)-2))
        let extentVector = CIVector(x: xforextent ?? 0, y: (yforextent ?? 0), z: 4, w: 4)
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else {return nil }
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}



extension CIImage {
    var averageColor: Int? {
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: self, kCIInputExtentKey: self.extent]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        let red = bitmap[0]; let blue = bitmap[1]; let green = bitmap[2]
        let valuetoreturn = Int(red)+Int(256*Int(green))+Int(65536*Int(blue))
        return (valuetoreturn)
    }
}


class sounds : AVAudioMix{
    unowned var environment : AVAudioEnvironmentNode
    init(environment: AVAudioEnvironmentNode){self.environment = environment}
    func endplay()-> Bool{
        captureSession.stopRunning()
        rengine.stop()
        rengine.reset()
      //  for i in 0...audioPlayer.count-1 {
            //rengine.disconnectNodeInput(audioPlayer[i])
      //  }
        audioPlayer.removeAll()
        environment.reset()
        if rengine.isRunning == false && audioPlayer.count == 0 {soundstred = false;captureSession.startRunning(); return false}
        return true
    }
    func changeposition(pos: [Float], colors: [Int]){
        if audioPlayer.isEmpty {return}
        if audioPlayer.count != latoquadratoaudio*latoquadratoaudio*2{return}
        if audioPlayer[0].volume < 1 {
            for i in 0...audioPlayer.count - 1 {
                audioPlayer[i].volume += 0.1
            }
        }
        for a in 0...audioPlayer.count - 1 {
           // if let v = audioPlayer[a].lastRenderTime?.hostTime {
                //print(v - lastrendere[a])
            //    lastrendere[a] = v
            //    }
            var i = a
            var sound : Float = 0.1
            if i > latoquadratoaudio*latoquadratoaudio-1 {i -= latoquadratoaudio*latoquadratoaudio;sound = 5}
            if withcolours == true && a < audioPlayer.count/2 {
                
            let basevalue = Float(colors[latoquadratoaudio*latoquadratoaudio-1-i]) //17.2
            
                let rate = max(0.5,min(2,3/(pow(2,2000/basevalue)))) //(pow(0.5,basevalue/12)+0.5*0.12*basevalue)*2-1.5
                //print(rate)
            audioPlayer[a].rate = rate
                audioPlayer[a+audioPlayer.count/2].rate = pow(rate,0.1)
            }
            if updatedepth || depthpresence {
                var t = (pos[i])
                if volumeadjusting < 0 {t = (7 - t)}
                if !depthpresence{t = t*3}
                let newpos = (-pow(1 + abs(t),1 + abs(volumeadjusting/3))*abs(t-sound)/sound) - 1
                if newpos != audioPlayer[a].position.z{
              //      print(a,newpos - audioPlayer[a].position.z)
                    let ratio = t/max(((pos.max() ?? 1)-(pos.min() ?? 1)),0.0001)
                audioPlayer[a].position.z = newpos
                audioPlayer[a].reverbBlend = max(0,min(1,ratio/12)) //valid values is 0.0 (completely dry) to 1.0 (completely wet).
                }}
            
            
        }
        tap = true
        depthforsound[0] = -1
        updatedepth = false
    }
    func playsounds (){
        captureSession.stopRunning()
        if audioPlayer.count != latoquadratoaudio*latoquadratoaudio {resetlatoquadratoaudio(lato: latoquadratoaudio)}
        let filetoplay = ["1","2","3","4","5","6","2","4","6","1","3","5","1","7","8","9","10","11","12","13","14","15","16"]
        if musicfilenumber >= filetoplay.count-1{musicfilenumber = 0}
        //print(musicfilenumber)
    let path1 = Bundle.main.path(forResource: filetoplay[musicfilenumber], ofType: "wav")!
    let path2 = Bundle.main.path(forResource: filetoplay[musicfilenumber + 1], ofType: "wav")!
    let url = [URL(fileURLWithPath: path1),URL(fileURLWithPath: path2)]
        do {try play(url: url)} catch {}}
    func play(url: [URL]) throws {//aggiunta
    let file = try AVAudioFile(forReading: url[0])
    let songLengthSamples = file.length
    let songFormat = file.processingFormat
    let sampleRateSong = Double(songFormat.sampleRate)
    let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(songLengthSamples))!
    do {
        try file.read(into: buffer)
        } catch _ {
        }
    let file2 = try AVAudioFile(forReading: url[1])
    let songLengthSamples2 = file2.length
    let songFormat2 = file2.processingFormat
    let sampleRateSong2 = Double(songFormat2.sampleRate)
    let buffer2 = AVAudioPCMBuffer(pcmFormat: file2.processingFormat, frameCapacity: AVAudioFrameCount(songLengthSamples2))!
    do {
        try file2.read(into: buffer2)
        } catch _ {
        }
    environment.listenerPosition = AVAudio3DPoint(x: 0.0, y: 0.0, z: 0.0);
    environment.listenerVectorOrientation = AVAudioMake3DVectorOrientation(AVAudioMake3DVector(0, 0, -1), AVAudioMake3DVector(0, 0, 0))
    environment.listenerAngularOrientation = AVAudioMake3DAngularOrientation(0.0,0.0, 0.0)
    environment.distanceAttenuationParameters.rolloffFactor = 1
    rengine.attach(environment)
    for i in 0...latoquadratoaudio*latoquadratoaudio-1 {
        
        audioPlayer.append(AVAudioPlayerNode())
        audioPlayer[i].renderingAlgorithm = .HRTFHQ
        audioPlayer[i].volume = 0
        
    //print(audioPlayer[0].position)
    rengine.attach(audioPlayer[i])
    rengine.connect(audioPlayer[i], to: environment, format:  AVAudioFormat.init(standardFormatWithSampleRate: sampleRateSong, channels: 1))
    }
    for i in 0...latoquadratoaudio*latoquadratoaudio-1 {
        audioPlayer.append(AVAudioPlayerNode())
        audioPlayer[i+latoquadratoaudio*latoquadratoaudio].renderingAlgorithm = .HRTFHQ
        audioPlayer[i+latoquadratoaudio*latoquadratoaudio].volume = 0
    //print(audioPlayer[0].position)
    rengine.attach(audioPlayer[i + latoquadratoaudio*latoquadratoaudio])
    rengine.connect(audioPlayer[i + latoquadratoaudio*latoquadratoaudio], to: environment, format:  AVAudioFormat.init(standardFormatWithSampleRate: sampleRateSong2, channels: 1))
    }

    rengine.connect(environment, to: rengine.mainMixerNode, format:  nil)
    rengine.prepare()
    
    do {
          try rengine.start()        } catch {
              print("Unable to start AVAudioEngine: \(error.localizedDescription)")
          }
    for i in 0...latoquadratoaudio*latoquadratoaudio-1 {
        let time = AVAudioTime(hostTime: mach_absolute_time(), sampleTime: AVAudioFramePosition(i), atRate: sampleRateSong)
        let time2 = AVAudioTime(hostTime: mach_absolute_time(), sampleTime: AVAudioFramePosition(i+latoquadratoaudio*latoquadratoaudio), atRate: sampleRateSong2)
        audioPlayer[i].scheduleBuffer(buffer, at: nil, options: AVAudioPlayerNodeBufferOptions.loops, completionHandler: nil)
        audioPlayer[i+latoquadratoaudio*latoquadratoaudio].scheduleBuffer(buffer2, at: nil, options: AVAudioPlayerNodeBufferOptions.loops, completionHandler: nil)
        audioPlayer[i].play(at: time)
        audioPlayer[i+latoquadratoaudio*latoquadratoaudio].play(at: time2)
    }

        let positio : Float = 15/Float(latoquadratoaudio)
    for i in 0...latoquadratoaudio*latoquadratoaudio-1 {
        let position = AVAudio3DPoint(x: positio*(Float(Int((i)%latoquadratoaudio))-Float((latoquadratoaudio-1)/2)),y:  positio*(-Float(Int(((i)/latoquadratoaudio)%latoquadratoaudio))+Float((latoquadratoaudio-1)/2)),z: 0)
        audioPlayer[i].position.x = position.x * 2
        audioPlayer[i].position.y = position.y * 2
        audioPlayer[i].position.z = position.z
        audioPlayer[i+latoquadratoaudio*latoquadratoaudio].position.x = position.x
        audioPlayer[i+latoquadratoaudio*latoquadratoaudio].position.y = position.y
        audioPlayer[i+latoquadratoaudio*latoquadratoaudio].position.z = position.z
    }
    soundstred = true
    count = 0
    captureSession.startRunning()
    }
    
    func resetlatoquadratoaudio(lato: Int) {
         depthforsound.removeAll()
         verticalbands.removeAll()
         horizontalbands.removeAll()
         colorvalues.removeAll()
         depthforsound = Array(repeating: Float(0), count: lato*lato)
         verticalbands = Array(repeating: Int(0), count: lato)
         horizontalbands = Array(repeating: Int(0), count: lato)
         colorvalues = Array(repeating:  90, count: lato*lato)
    }

}

