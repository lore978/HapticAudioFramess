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

var soundnohaptic = false
let semaphoretoloaddata = DispatchSemaphore(value: 0)
let semaphoreswitchingtap = DispatchSemaphore(value: 0)
var captureSession = AVCaptureSession()
var countforbast = 0
var sccreentouched = false
var previousColor = [0,0,0]
var color = [0,0,0]
var forceoftouch: Float = 0.1
var xtouch : Float = 0
var ytouch : Float = 0
var prextouch : Float = xtouch
var preytouch : Float = ytouch
var screenwidth : Float = 1
var screenheight : Float = 1
var xcorrection : Float = 1
var ycorrection : Float = 1
var widthcamera = 480
var heightcamera = 640
var stoggleTorch = false
var contvibr = false
var tocchi : Set<UITouch>? = nil
var convertedHeatmap: [[Float]] = []
var newdepthframe = false
var tap = true
var touchvibr : Float = 1
var pretouchvibr : Float = 1
var cgImage : CGImage?
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
var engine: CHHapticEngine!
var maxbastonedistance : Float = 2000
var prebastdistance : Float = 0
var depthpresence : Bool = false
var typeofcane : Bool = false
var preinclination : Float = 0
var vibrating : Bool = false
var contintensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0)
var contsharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
var actualintensity = Float(0)
var actualsharpness = Float(0)
var tdtouchabsencedefault : CGFloat = 0
var contintensityctrl : Float = 0
var contsharpnessctrl : Float = 0
var rengine = AVAudioEngine()
var positionztest : Float = 0
var latoquadratoaudio = 5
var audioPlayer : [AVAudioPlayerNode]!
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
var lastwithcolor = false
var differenceincolor : Float = 0
var updatedepth = false
var updatecolors = false
 var intensitycolorofimage = 0
var pauseduration = 0
var gradeofcolor = CGFloat(0)
var ratioadj = Float(0)
var typeplay = false
var hapticinit = false
var devicehapticdevice = -1
var defaultfornohaptics = "Your device doesn't support haptics type used by VibView"
var defaultfornohapticsinstructions = "It has been lauched the audio mode"
var defaultforok = "Ok"
var passtosound = 0

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


class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate, AVCaptureDepthDataOutputDelegate  {
    var filteredImage: UIImageView!
    var conf : MLModelConfiguration!
    var accessibilityview = UIView()
    var pinching = false
    var lastpinch : CGFloat = 1
    var cgImagecropped : CGImage?
    var cameraImage : CIImage!
    //var cameraImagecache : CIImage?
    var rectangle : CGRect?
    var backCamera: AVCaptureDevice!
    var backCameradepth: AVCaptureDevice!
    var environment = AVAudioEnvironmentNode()
    @objc func pinch( sender : UIPinchGestureRecognizer) {
        if tap == true {return}
        if sender.state == .ended && newdepthframe == true {pinching = false;view.isUserInteractionEnabled = true}
        if sender.state == .began {
            view.isUserInteractionEnabled = false
            motionManager.stopDeviceMotionUpdates();corrtiltx = 10;corrtilty = 10;prem12 = 0;prem33 = 0;prem23 = 0;prem21 = 0;
            sccreentouched = false;
            if vibrating {
            do {try player?.stop(atTime: CHHapticTimeImmediate);vibrating = false;
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
                let xorigin = (sender.location(in: accessibilityview).x / CGFloat(screenwidth))
                let yorigin = (sender.location(in: accessibilityview).y / CGFloat(screenheight))
                rectangle = CGRect(x: CGFloat(cgImagecropped!.width)*xorigin - width/2, y: CGFloat(cgImagecropped!.height)*yorigin - height/2, width: width, height: height)
                cgImagecropped = cgImagecropped?.cropping(to: rectangle!)
                if cgImagecropped != nil { accodaflusso(filteredImage: UIImage(cgImage: cgImagecropped!))}
            }
            if lastpinch/change > 1.15 && cgImagecropped != nil && change < 1{
                lastpinch = change;let generator = UIImpactFeedbackGenerator();generator.impactOccurred()
                let width = CGFloat(cgImage!.width)/lastpinch
                let height = CGFloat(cgImage!.height)/lastpinch
                let xorigin = (sender.location(in: accessibilityview).x / CGFloat(screenwidth))
                let yorigin = (sender.location(in: accessibilityview).y / CGFloat(screenheight))
                rectangle = CGRect(x: CGFloat(cgImage!.width)*xorigin - width/2, y: CGFloat(cgImage!.height)*yorigin - height/2, width: width, height: height)
                cgImagecropped = cgImage?.cropping(to: rectangle!)
                if cgImagecropped != nil { accodaflusso(filteredImage: UIImage(cgImage: cgImagecropped!))}
            }
        }
        if sender.state == .ended && newdepthframe == true {
           // if cameraImagecache == nil {cameraImagecache = cameraImage}
            newdepthframe = false
            //cameraImagecache = cameraImagecache?.cropped(to: (rectangle)!)
            if let croppedimage = cameraImage?.cropped(to: (rectangle ?? CGRect(x: 0, y: 0, width: 1, height: 1))){
                processaimmaginezoom(cameraImage: croppedimage)}
        }
    }

    var photoOutput: AVCapturePhotoOutput?
    let context = CIContext()
    func playsoundsoraccesslibrary(typplay : Bool){
        typeplay = typplay
        switch typplay {
        case false:
            if versionanalisys == 0 {
                do {
                     try player?.stop(atTime: CHHapticTimeImmediate);vibrating = false
                 } catch let error {
                     print("Error stopping the continuous haptic player: \(error)")
                 };
                withcolours = true
                if audioPlayer.count != 0 {for i in 0...audioPlayer.count - 1 {rengine.detach(audioPlayer[i])};_ = sounds(environment: environment).endplay();environment.reset();}
                if ProcessInfo.processInfo.thermalState.rawValue > 1 {latoquadratoaudio = 3}
                lastwithcolor = true
                sounds(environment: environment).playsounds()
                if let image = UIImage(named: "sfondoaudio.jpg") {filteredImage.image = image}
            }
        default :
            if versionanalisys == 0 && depthpresence{
                
                do {
                     try player?.stop(atTime: CHHapticTimeImmediate);vibrating = false
                 } catch let error {
                     print("Error stopping the continuous haptic player: \(error)")
                 };
                withcolours = false
                if audioPlayer.count != 0  {for i in 0...audioPlayer.count - 1 {rengine.detach(audioPlayer[i])};_ = sounds(environment: environment).endplay();environment.reset()}
                if ProcessInfo.processInfo.thermalState.rawValue > 1 {latoquadratoaudio = 3}
                lastwithcolor = false
                sounds(environment: environment).playsounds()
                if let image = UIImage(named: "sfondoaudiobn.jpg") {filteredImage.image = image}
            }
            if versionanalisys == 0 &&  !depthpresence {
                model = nil
                do {try player?.stop(atTime: CHHapticTimeImmediate);vibrating = false} catch let error {
                     print("Error stopping the continuous haptic player: \(error)")};
                withcolours = false
                if audioPlayer.count != 0  {for i in 0...audioPlayer.count - 1 {rengine.detach(audioPlayer[i])};_ = sounds(environment: environment).endplay();environment.reset()}
                if ProcessInfo.processInfo.thermalState.rawValue > 1 {latoquadratoaudio = 3}
                
                //if rengine.isRunning {_ = sounds().endplay();changesound = true}
                if ProcessInfo.processInfo.thermalState.rawValue > 1 {latoquadratoaudio = 3}
                lastwithcolor = false
                sounds(environment: environment).playsounds()
                //processaimmagine(cameraImage: cameraImage!)
                //captureSession.startRunning()
                //changesound = true
                if let image = UIImage(named: "sfondoaudiobn.jpg") {filteredImage.image = image}
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
        if mode == 3 {if !lastwithcolor {musicfilenumber -= 1};playsoundsoraccesslibrary(typplay : true)}
        if versionanalisys == 2 && maxbastonedistance > 200 && typeofcane == false {maxbastonedistance-=100
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
    
    @objc func swipegdown() {
       if mode == 3 {if lastwithcolor {musicfilenumber += 1};playsoundsoraccesslibrary(typplay : false)}
           if versionanalisys == 2 && maxbastonedistance < 6000 && typeofcane == false  {maxbastonedistance+=100
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



    override func didReceiveMemoryWarning() {
        backCamera.setminframe()
        backCameradepth.setminframe()
    }

     @objc func tapped() {
        xcorrection = Float(widthcamera)/screenwidth
        ycorrection = Float(heightcamera)/screenheight
        if orientationr != 0 && UIDevice.current.orientation.rawValue != 0 {orientationr = UIDevice.current.orientation.rawValue}
        var xpos : Float = 360
        switch orientationr {
        case 0...2:
            xpos = xtouch
        case 5:
            xpos = xtouch
        case 3:
            xpos = Float(heightcamera)*ycorrection - ytouch
        case 4:
            xpos = ytouch
        default:
            xpos = ytouch
        }
        let xextent = Float(widthcamera)*xcorrection
        if !tap{xpos = xextent*0.5}
        switch xpos {
        case 0...xextent*0.2:
            
            previousColor = [255,255,255]
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
                mode = 3
                playsoundsoraccesslibrary(typplay : typeplay)
                
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
            
        case xextent*0.8...xextent:
            
            previousColor = [255,255,255]
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
                mode = 3
                playsoundsoraccesslibrary(typplay : typeplay)
                
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
                if vibrating{
                    do {try player?.stop(atTime: CHHapticTimeImmediate);sccreentouched = false;vibrating = false} catch let error {print("Error stopping the continuous haptic player: \(error)")}
                    }
                tap.toggle()
                switch tap {
                case true:
                    if motionManager.isDeviceMotionActive == true {motionManager.stopDeviceMotionUpdates()}
                        captureSession.sessionPreset = AVCaptureSession.Preset.vga640x480;
                        widthcamera = 480
                        heightcamera = 640
                        xcorrection = Float(widthcamera)/screenwidth
                        ycorrection = Float(heightcamera)/screenheight
                        //captureSession.startRunning();
                        newdepthframe = false;
                    captureSession.startRunning()
                default:
                    captureSession.stopRunning()
                    captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080;
                    widthcamera = 1080
                    heightcamera = 1920
                    cgImagecropped = nil
                    xcorrection = Float(widthcamera)/screenwidth
                    ycorrection = Float(heightcamera)/screenheight
                    captureSession.startRunning()
                    sleep(1)
                }

                }
            
        }
        savevalues()
}

   // override func viewWillAppear(_ animated: Bool) {
  //
  //  }
//    override func viewDidAppear(_ animated: Bool) {
 //
  //  }
    
    override open var shouldAutorotate: Bool {
        return false}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredImage = UIImageView()
        filteredImage.frame = self.view.frame
        view.addSubview(filteredImage)
        captureSession = AVCaptureSession()
        audioPlayer = [AVAudioPlayerNode]()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        if orientationr == 0 {orientationr = UIDevice.current.orientation.rawValue}
        screenwidth = Float(UIScreen.main.bounds.width)
        screenheight = Float(UIScreen.main.bounds.height)
        xcorrection = Float(widthcamera)/screenwidth
        ycorrection = Float(heightcamera)/screenheight
        accessibilityview.frame = self.view.frame
                accessibilityview.isAccessibilityElement = true
                accessibilityview.accessibilityTraits = .allowsDirectInteraction
                let SwiperightGesture = UISwipeGestureRecognizer(target:self,action:#selector(swipegright))
                SwiperightGesture.direction = .right
                SwiperightGesture.cancelsTouchesInView = false
                self.accessibilityview.addGestureRecognizer(SwiperightGesture)
                let SwipeleftGesture = UISwipeGestureRecognizer(target:self,action:#selector(swipegleft))
                SwipeleftGesture.direction = .left
                SwipeleftGesture.cancelsTouchesInView = false
                self.accessibilityview.addGestureRecognizer(SwipeleftGesture)
                let SwipeuptGesture = UISwipeGestureRecognizer(target:self,action:#selector(swipgeup))
                SwipeuptGesture.direction = .up
                SwipeuptGesture.cancelsTouchesInView = false
                self.accessibilityview.addGestureRecognizer(SwipeuptGesture)
                let SwipedownGesture = UISwipeGestureRecognizer(target:self,action:#selector(swipegdown))
                SwipedownGesture.direction = .down
                SwipedownGesture.cancelsTouchesInView = false
                self.accessibilityview.addGestureRecognizer(SwipedownGesture)
                let tapGesture = UITapGestureRecognizer(target:self,action:#selector(tapped))
                tapGesture.numberOfTapsRequired = 2
        tapGesture.requiresExclusiveTouchType = true
                tapGesture.cancelsTouchesInView = false
        tapGesture.delaysTouchesBegan = false
        tapGesture.delaysTouchesEnded = false
        self.accessibilityview.addGestureRecognizer(tapGesture)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        pinchGesture.cancelsTouchesInView = true
        self.accessibilityview.addGestureRecognizer(pinchGesture)
        self.view.addSubview(accessibilityview)
        self.loadvalues()
        semaphoretoloaddata.wait()
        devicehapticdevice = UIDevice.current.value(forKey: "_feedbackSupportLevel") as? Int ?? -1;
        self.checkCameraAccess();
        if soundstred == false && mode == 3 {self.playsoundsoraccesslibrary(typplay : typeplay)}
    }
    
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
    
            self.alertnopermissiontocamera()
        case .restricted:
            print("Restricted, device owner must approve")
            self.alertnopermissiontocamera()
        case .authorized:
            print("Authorized, proceed")
            self.setupDevice()
                
        default:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                    self.setupDevice();
                       
                } else {print("Permission denied")
                    self.alertnopermissiontocamera()
                }
            }
        
            
        }
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [
                                                                        .builtInWideAngleCamera,
                                                                        .builtInUltraWideCamera,
                                                                        .builtInTelephotoCamera,
                                                                        .builtInDualCamera,
                                                                        .builtInDualWideCamera,
                                                                        .builtInTripleCamera
        ], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back)
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if backCameradepth == nil &&
                (device.deviceType == .builtInDualCamera || device.deviceType == .builtInTripleCamera || device.deviceType == .builtInDualWideCamera) {
                do {backCameradepth = device}
                depthpresence = true
                }}
        if !depthpresence {for device in devices {if device.position == .back && device != backCameradepth && backCamera == nil { backCamera = device; break}}}
        if self.backCameradepth != nil{self.configureDepthCaptureSession()} else if self.backCamera != nil {self.setupInputOutput()} else {exit(0)};
            }

    func getLanguageISO() -> String {
      let locale = String(Locale.preferredLanguages[0].prefix(2))
      return locale
    }
    
    func showAlerttoclose(texttoshow: String, acceptstring: String, yes: String) {
        DispatchQueue.main.async{
            let alertController = UIAlertController (title: texttoshow, message: acceptstring, preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: yes, style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)}
    }
    
    func showpopup(texttoshow: String, acceptstring: String, yes: String) {
        let alertController = UIAlertController (title: texttoshow, message: acceptstring, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: yes, style: .default) { (_) -> Void in
            alertController.removeFromParent()
                return
            }
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertnopermissiontocamera() {

        let code = getLanguageISO()
        switch code {
        case "ar":
            showAlerttoclose(texttoshow: "سيقومسيقوم التطبيق بالتسجيل على بيانات جهازك المستخرجة من الصور للمقارنة والعثور على أكثرها تشابهًا. لن يتم مشاركة البيانات بأي شكل من الأشكال. قبوللا يمكن للتطبيق تحليل البيئة إذا لم تمنح الإذن للوصول إلى الكاميرا.",acceptstring: "اذهب للاعدادات؟", yes: "نعم.")
        case "fi":
            showAlerttoclose(texttoshow: "Sovellus ei voi analysoida ympäristöä, jos et anna lupaa käyttää kameraa.",acceptstring: "Mene asetuksiin?", yes: "Joo.")
        case "fr":
            showAlerttoclose(texttoshow: "L'application ne peut pas analyser l'environnement si vous ne donnez pas la permission d'accéder à la caméra.",acceptstring: "Aller aux paramètres?", yes: "Oui.")
        case "ja":
            showAlerttoclose(texttoshow: "カメラへのアクセスを許可しないと、アプリは環境を分析できません。",acceptstring: "設定に移動？", yes: "はい。")
        case "it":
            showAlerttoclose(texttoshow: "L'app non può analizzare l'ambiente se non si autorizza l'accesso alla fotocamera.",acceptstring: "Vai alle impostazioni?", yes: "Sì.")
        case "pt":
            showAlerttoclose(texttoshow: "O aplicativo não pode analisar o ambiente se você não der permissão para acessar a câmera.",acceptstring: "Vá para as configurações?", yes: "Sim.")
        case "es":
            showAlerttoclose(texttoshow: "La aplicación no puede analizar el entorno si no da permiso para acceder a la cámara.",acceptstring: "¿Ir a la configuración?", yes: "Si.")
        case "sv":
            showAlerttoclose(texttoshow: "Appen kan inte analysera miljön om du inte ger behörighet att komma åt kameran.",acceptstring: "Gå till Inställningar?", yes: "Ja.")
        case "de":
            showAlerttoclose(texttoshow: "Die App kann die Umgebung nicht analysieren, wenn Sie keine Berechtigung zum Zugriff auf die Kamera erteilen.",acceptstring: "Gehe zu den Einstellungen?", yes: "Ja.")
        case "ca":
            showAlerttoclose(texttoshow: "L'aplicació no pot analitzar l'entorn si no doneu permís per accedir a la càmera.",acceptstring: "Voleu anar a la configuració?", yes: "Sí.")
        case "cs":
            showAlerttoclose(texttoshow: "Pokud neudělíte přístup k fotoaparátu, aplikace nemůže analyzovat prostředí.",acceptstring: "Jdi do nastavení?", yes: "Ano.")
        case "zh":
            showAlerttoclose(texttoshow: "如果您未授予访问相机的权限，则该应用无法分析环境。",acceptstring: "前往设置？", yes: "是。")
        case "ko":
            showAlerttoclose(texttoshow: "카메라에 대한 접근 권한을 부여하지 않으면 앱에서 환경을 분석 할 수 없습니다.",acceptstring: "설정으로 바로 가기?", yes: "예.")
        case "hr":
            showAlerttoclose(texttoshow: "Aplikacija ne može analizirati okruženje ako ne date dopuštenje za pristup kameri.",acceptstring: "Idite na postavke?", yes: "Da.")
        case "da":
            showAlerttoclose(texttoshow: "Appen kan ikke analysere miljøet, hvis du ikke giver tilladelse til at få adgang til kameraet.",acceptstring: "Gå til indstillinger?", yes: "Ja.")
        case "he":
            showAlerttoclose(texttoshow: "האפליקציה לא יכולה לנתח את הסביבה אם אינך נותן הרשאה לגשת למצלמה.",acceptstring: "?לך להגדרות", yes: "כן.")
        case "el":
            showAlerttoclose(texttoshow: "Η εφαρμογή δεν μπορεί να αναλύσει το περιβάλλον εάν δεν επιτρέψετε την πρόσβαση στην κάμερα.",acceptstring: "Μετάβαση στις ρυθμίσεις?", yes: "Ναί.")
        case "hi":
            showAlerttoclose(texttoshow: "यदि आप कैमरा एक्सेस करने की अनुमति नहीं देते हैं तो ऐप पर्यावरण का विश्लेषण नहीं कर सकता है।",acceptstring: "सेटिंग्स में जाओ?", yes: "हाँ।")
        case "id":
            showAlerttoclose(texttoshow: "Aplikasi tidak dapat menganalisis lingkungan jika Anda tidak memberikan izin untuk mengakses kamera.",acceptstring: "Pergi ke pengaturan?", yes: "Iya.")
        case "ms":
            showAlerttoclose(texttoshow: "Aplikasi tidak dapat menganalisis persekitaran jika anda tidak memberikan kebenaran untuk mengakses kamera.",acceptstring: "Pergi ke tetapan?", yes: "Ya.")
        case "no":
            showAlerttoclose(texttoshow: "Appen kan ikke analysere miljøet hvis du ikke gir tilgang til kameraet.",acceptstring: "Gå til Innstillinger?", yes: "Ja.")
        case "nl":
            showAlerttoclose(texttoshow: "De app kan de omgeving niet analyseren als je geen toestemming geeft voor toegang tot de camera.",acceptstring: "Ga naar Instellingen?", yes: "Ja.")
        case "pl":
            showAlerttoclose(texttoshow: "Aplikacja nie może analizować środowiska, jeśli nie zezwolisz na dostęp do kamery.",acceptstring: "Przejdź do ustawień?", yes: "Tak.")
        case "ro":
            showAlerttoclose(texttoshow: "Aplicația nu poate analiza mediul dacă nu acordați permisiunea de a accesa camera.",acceptstring: "Mergi la Setari?", yes: "Da.")
        case "ru":
            showAlerttoclose(texttoshow: "Приложение не сможет анализировать окружающую среду, если вы не дадите разрешение на доступ к камере.",acceptstring: "Перейти к настройкам?", yes: "Да.")
        case "sk":
            showAlerttoclose(texttoshow: "Ak neposkytnete povolenie na prístup k fotoaparátu, aplikácia nemôže analyzovať prostredie.",acceptstring: "Choď do nastavení?", yes: "Áno.")
        case "th":
            showAlerttoclose(texttoshow: "แอปไม่สามารถวิเคราะห์สภาพแวดล้อมได้หากคุณไม่อนุญาตให้เข้าถึงกล้อง",acceptstring: "ไปที่การตั้งค่า?", yes: "ใช่.")
        case "tr","tk":
            showAlerttoclose(texttoshow: "Kameraya erişim izni vermezseniz uygulama ortamı analiz edemez.",acceptstring: "Ayarlara git?", yes: "Evet.")
        case "uk":
            showAlerttoclose(texttoshow: "Додаток не може аналізувати середовище, якщо ви не даєте дозволу на доступ до камери.",acceptstring: "Перейти до налаштувань?", yes: "Так.")
        case "hu":
            showAlerttoclose(texttoshow: "Az alkalmazás nem tudja elemezni a környezetet, ha nem engedélyezi a kamera elérését.",acceptstring: "Menj a beállításokhoz?", yes: "Igen.")
        case "vi":
            showAlerttoclose(texttoshow: "Ứng dụng không thể phân tích môi trường nếu bạn không cấp quyền truy cập vào máy ảnh.",acceptstring: "Đi tới cài đặt?", yes: "Đúng.")
        default:
            showAlerttoclose(texttoshow: "The app can't analyze the environment if you do not give permission to access the camera.",acceptstring: "Go to settings?", yes: "Yes.")
        }
        return
        
    }
    
    func alertnohaptics() {

        let code = getLanguageISO()
        switch code {
        case "ar":
            defaultfornohaptics = "VibView جهازك لا يدعم نوع اللمسات المستخدم بواسطة "; defaultfornohapticsinstructions = "تم تشغيل وضع الصوت"; defaultforok = "موافق"
        case "fi":
            defaultfornohaptics = "Laitteesi ei tue VibView: n käyttämää haptiikkatyyppiä"
            defaultfornohapticsinstructions = "Äänitila on ylitetty"
            defaultforok = "Ok"
        case "fr":
            defaultfornohaptics = "Votre appareil ne prend pas en charge le type haptique utilisé par VibView"
            defaultfornohapticsinstructions = "Il a été lancé le mode audio"
            defaultforok = "Ok"
        case "ja":
            defaultfornohaptics = "お使いのデバイスはVibViewで使用される触覚タイプをサポートしていません"
            defaultfornohapticsinstructions = "オーディオモードが開始されました"
            defaultforok = "OK"
        case "it":
            defaultfornohaptics = "Il tuo dispositivo non supporta il tipo aptico utilizzato da VibView"
            defaultfornohapticsinstructions = "È stata lanciata la modalità audio"
            defaultforok = "Ok"
        case "pt":
            defaultfornohaptics = "Seu dispositivo não suporta o tipo de sensação tátil usado pelo VibView"
            defaultfornohapticsinstructions = "Foi lançado o modo de áudio"
            defaultforok = "Ok"
        case "es":
            defaultfornohaptics = "Su dispositivo no es compatible con el tipo de háptica que usa VibView"
            defaultfornohapticsinstructions = "Se ha iniciado el modo de audio"
            defaultforok = "Aceptar"
        case "sv":
            defaultfornohaptics = "Enheten stöder inte haptics-typ som används av VibView"
            defaultfornohapticsinstructions = "Det har uppskattats för ljudläget"
            defaultforok = "Ok"
        case "de":
            defaultfornohaptics = "Ihr Gerät unterstützt den von VibView verwendeten Haptiktyp nicht."
            defaultfornohapticsinstructions = "Der Audiomodus wurde gestartet."
            defaultforok = "Ok"
        case "ca":
            defaultfornohaptics = "El vostre dispositiu no admet el tipus d'haptics que utilitza VibView"
            defaultfornohapticsinstructions = "S'ha llançat el mode d'àudio"
            defaultforok = "D'acord"
        case "cs":
            defaultfornohaptics = "Vaše zařízení nepodporuje typ haptiky používaný VibView"
            defaultfornohapticsinstructions = "Byl spuštěn zvukový režim"
            defaultforok = "OK"
        case "zh":
            defaultfornohaptics = "您的设备不支持VibView使用的触觉类型"
            defaultfornohapticsinstructions = "它已经启动了音频模式"
            defaultforok = "确定"
        case "ko":
            defaultfornohaptics = "장치가 VibView에서 사용하는 햅틱 유형을 지원하지 않습니다."
            defaultfornohapticsinstructions = "오디오 모드로 전환되었습니다"
            defaultforok = "확인"
        case "hr":
            defaultfornohaptics = "Vaš uređaj ne podržava tip haptika koji koristi VibView"
            defaultfornohapticsinstructions = "Pokrenut je audio način rada"
            defaultforok = "U redu"
        case "da":
            defaultfornohaptics = "Din enhed understøtter ikke haptics-type, der bruges af VibView"
            defaultfornohapticsinstructions = "Det er blevet lukket for lydtilstanden"
            defaultforok = "Ok"
        case "he":
            defaultfornohaptics = "VibView המכשיר שלך אינו תומך בסוג הפטיקה המשמש את "
            defaultfornohapticsinstructions = "זה הוענק למצב האודיו"
            defaultforok = "בסדר"
        case "el":
            defaultfornohaptics = "Η συσκευή σας δεν υποστηρίζει τύπο haptics που χρησιμοποιείται από το VibView"
            defaultfornohapticsinstructions = "Έχει διαμορφωθεί η λειτουργία ήχου"
            defaultforok = "Εντάξει"
        case "hi":
            defaultfornohaptics = "आपका उपकरण VibView द्वारा उपयोग किए गए हापिक्स प्रकार का समर्थन नहीं करता है"
            defaultfornohapticsinstructions = "यह ऑडियो मोड की सराहना की गई है"
            defaultforok = "ठीक है"
        case "id":
            defaultfornohaptics = "Perangkat Anda tidak mendukung jenis haptics yang digunakan oleh VibView"
            defaultfornohapticsinstructions = "Ini telah meluncurkan mode audio"
            defaultforok = "Ok"
        case "ms":
            defaultfornohaptics = "Peranti anda tidak menyokong jenis haptik yang digunakan oleh VibView"
            defaultfornohapticsinstructions = "Telah disempurnakan mod audio"
            defaultforok = "Ok"
        case "no":
            defaultfornohaptics = "Enheten din støtter ikke haptics-typen som brukes av VibView"
            defaultfornohapticsinstructions = "Det er blitt lovordet lydmodus"
            defaultforok = "Ok"
        case "nl":
            defaultfornohaptics = "Uw apparaat ondersteunt geen haptisch type gebruikt door VibView"
            defaultfornohapticsinstructions = "Het is gestart met de audiomodus"
            defaultforok = "Ok"
        case "pl":
            defaultfornohaptics = "Twoje urządzenie nie obsługuje typu haptyki używanego przez VibView"
            defaultfornohapticsinstructions = "Został uruchomiony tryb audio"
            defaultforok = "Ok"
        case "ro":
            defaultfornohaptics = "Dispozitivul dvs. nu acceptă tipul de haptic folosit de VibView"
            defaultfornohapticsinstructions = "A fost lansat modul audio"
            defaultforok = "Ok"
        case "ru":
            defaultfornohaptics = "Ваше устройство не поддерживает тип тактильных ощущений, используемый VibView"
            defaultfornohapticsinstructions = "Включен аудио режим"
            defaultforok = "Хорошо"
        case "sk":
            defaultfornohaptics = "Vaše zariadenie nepodporuje typ haptiky používaný VibView"
            defaultfornohapticsinstructions = "Bol spustený zvukový režim"
            defaultforok = "Dobre"
        case "th":
            defaultfornohaptics = "อุปกรณ์ของคุณไม่รองรับประเภท haptics ที่ VibView ใช้"
            defaultfornohapticsinstructions = "เปิดโหมดเสียงแล้ว"
            defaultforok = "ตกลง"
        case "tr","tk":
            defaultfornohaptics = "Cihazınız VibView tarafından kullanılan haptik türünü desteklemiyor"
            defaultfornohapticsinstructions = "Ses modu kaldırıldı"
            defaultforok = "Tamam"
        case "uk":
            defaultfornohaptics = "Ваш пристрій не підтримує тип хаптики, що використовується VibView"
            defaultfornohapticsinstructions = "Був запущений аудіорежим"
            defaultforok = "Добре"
        case "hu":
            defaultfornohaptics = "Az Ön készüléke nem támogatja a VibView által használt haptics típust"
            defaultfornohapticsinstructions = "A hangmódot kiírták"
            defaultforok = "Ok"
        case "vi":
            defaultfornohaptics = "Thiết bị của bạn không hỗ trợ loại haptics được VibView sử dụng"
            defaultfornohapticsinstructions = "Chế độ âm thanh đã bị loại bỏ"
            defaultforok = "Ok"
        default:
            defaultfornohaptics = "Your device doesn't support haptics type used by VibView"
            defaultfornohapticsinstructions = "It has been lauched the audio mode"
            defaultforok = "Ok"
        }
        return
        
    }
    
    func loadvalues() {
        do{if let SavedPreferences = UserDefaults.standard.object(forKey: "VibViewSavedpreferences") as? Data{
        if let arrtry = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(SavedPreferences){
         let    savedefault = arrtry as! [Any?]
            typeplay = savedefault[0]! as! Bool
            //firsttouch = savedefault[1]! as! Bool
            typeofcane = savedefault[2]! as! Bool
            musicfilenumber = savedefault[3]! as! Int
            volumeadjusting = savedefault[4]! as! Float
            mode = savedefault[5]! as! Int
            if mode != 0 {sccreentouched = false}
            versionanalisys = savedefault[6]! as! Int
            do{if let SavedPreferences = UserDefaults.standard.object(forKey: "VibViewSavedpreferences1") as? Data{
            if let arrtry = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(SavedPreferences){
                let savedefault = arrtry as! [Any?]
                passtosound = savedefault [0]! as! Int
                print("dafba",passtosound)
                
            }}} catch {print("notsavedpreferences");}
            semaphoretoloaddata.signal()
        }
        } else {semaphoretoloaddata.signal()}
        }catch {print("notsavedpreferences");semaphoretoloaddata.signal()}
    }
    
    func savevalues(){
        saveddefault = [typeplay,false,typeofcane,musicfilenumber,volumeadjusting,mode,versionanalisys]
            print("saving")
        let defaults = UserDefaults.standard
        do {let encodedData = try NSKeyedArchiver.archivedData(withRootObject: (saveddefault ?? [true,true,false,10,Float(1.3),0,false,0]) as Array, requiringSecureCoding: false)
            defaults.set(encodedData, forKey: "VibViewSavedpreferences")} catch {print("not saved")}
        do {let encodedData = try NSKeyedArchiver.archivedData(withRootObject: ([passtosound,0,0,0,0,0,0,0]) as Array, requiringSecureCoding: false)
            defaults.set(encodedData, forKey: "VibViewSavedpreferences1")} catch {print("not saved")}
    }
    
    
    
    @objc func timerusage(){
        if soundnohaptic {return()}
        if mode == 3 || mode == 1 {return}
        switch vibrating {
        case true:
            pauseduration += Int(actualintensity * 45)
            hapticusageseconds += 50 + Int(actualintensity * 65)
            if hapticusageseconds > 1200 {let generator = UINotificationFeedbackGenerator();generator.notificationOccurred(.warning)}
        default:
            hapticusageseconds -= 280
            if hapticusageseconds < 100 {hapticusageseconds = 0}}
        
        switch hapticusageseconds {
        case 1200...:
            hapticusageseconds = 1000 + pauseduration
            inhibittimer = true
            pauseduration = 0;
            if vibrating {do {vibrating=false
                try? player?.stop(atTime: CHHapticTimeImmediate);
            }}
            vibrating = false
            sccreentouched = false
            return
        default:inhibittimer = false}
    }
    
    func createAndStartHapticEngine() -> Bool {
         
        do {engine = try CHHapticEngine()} catch let error {fatalError("Engine Creation Error: \(error)");return false}
        do {try engine.start()
            return true;
        } catch {print("Failed to start the engine: \(error)");return false}
    }
    


    
  /*  func checknewsounds(){
        return
        let downloadTask = URLSession.shared.downloadTask(with: URL(string: "")!) {
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
        do {let captureDeviceInput = try AVCaptureDeviceInput(device: backCamera)
            if captureSession.canSetSessionPreset(.vga640x480) {captureSession.sessionPreset = AVCaptureSession.Preset.vga640x480;heightcamera = 640;widthcamera = 480} else { captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080;heightcamera = 1920;widthcamera = 1080}
            if captureSession.canAddInput(captureDeviceInput) {captureSession.addInput(captureDeviceInput)}
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: .main)
            if captureSession.canAddOutput(videoOutput) {
               captureSession.addOutput(videoOutput)}
            do {try backCamera.lockForConfiguration();
                if backCamera.hasTorch {if backCamera.isTorchModeSupported(.auto) == true {backCamera.torchMode = .auto}}
                if backCamera.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) == true { backCamera.whiteBalanceMode = .continuousAutoWhiteBalance}
                if backCamera.isExposureModeSupported(.continuousAutoExposure) == true {backCamera.exposureMode = .continuousAutoExposure}} catch {print("no lock of camera available")}
            backCamera.unlockForConfiguration();
        } catch {print(error)}
        
        captureSession.startRunning()
        self.addobserver()
        self.view.isUserInteractionEnabled = true
        
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        connection.videoOrientation = .portrait
       
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer){
        cameraImage = CIImage(cvImageBuffer: pixelBuffer)
        
            if cameraImage != nil {DispatchQueue.main.async {
            if soundstred {self.playsounds(colorimage: self.cameraImage)}
                if sccreentouched && versionanalisys == 0{
            let greencolor = color[1] //wl 520 - 565
            let bluecolor = color[2]  //wl 435 - 500
            let redcolor = color[0]  //wl 625 - 740
            intensitycolorofimage = greencolor + bluecolor + redcolor
            let maxcolor = max(greencolor,bluecolor,redcolor)
            let mincolor = min(greencolor,bluecolor,redcolor)
            let diffcolor = max(maxcolor - mincolor, 1)
            if maxcolor == redcolor {gradeofcolor = CGFloat(greencolor - bluecolor)/CGFloat(diffcolor)}
            if maxcolor == greencolor {gradeofcolor = 2 + CGFloat(bluecolor - redcolor)/CGFloat(diffcolor)}
            if maxcolor == bluecolor {gradeofcolor = 4 + CGFloat(redcolor - greencolor)/CGFloat(diffcolor)}
            if gradeofcolor > 5.7 {gradeofcolor = 0}
            self.analizza()
                }}
            if let cimage = self.cameraImage {self.processaimmagine(cameraImage: cimage)
            if let im = cgImage {
                let imui = im.touimage()
                self.accodaflusso(filteredImage: imui)}
                
            }
            }}
            
        }
    func depthDataOutput(_ output: AVCaptureDepthDataOutput,
                         didOutput depthData: AVDepthData,
                         timestamp: CMTime,
                         connection: AVCaptureConnection) {
       
      guard tap != false else {
        return
      }
      var convertedDepth: AVDepthData!
      let depthDataType = kCVPixelFormatType_DisparityFloat32
      if depthData.depthDataType != depthDataType {
        convertedDepth = depthData.converting(toDepthDataType: depthDataType)
      } else {
        convertedDepth = depthData
      }
      let pixelBuffer = convertedDepth.depthDataMap
        if pixelBuffer != nil {
            DispatchQueue.main.async {pixelBuffer.clamp(); if (soundstred == true && (depthforsound[0] != -1 || count < basecount)) {count+=1;return}; }}
    }
    
    
    func accodaflusso(filteredImage: UIImage){
        
        heightcamera = Int(filteredImage.size.height);widthcamera = Int(filteredImage.size.width)
        DispatchQueue.main.async {if soundstred == false {
            self.filteredImage.image = filteredImage
            if sccreentouched && !depthpresence && mode == 0 && captureSession.isRunning {self.vibradepthrt(vibr: 0.5)} else if sccreentouched && mode == 2 && captureSession.isRunning {
                color = filteredImage.averageColor ?? [0,0,0]; self.vibracolor(color: color)
            }
            }
        }
    }
    
    
    func playsounds(colorimage: CIImage){
        if !soundstred {return}
        heightcamera = Int((colorimage.extent.height));widthcamera = Int(colorimage.extent.width)
        DispatchQueue.main.async {if count > basecount && captureSession.isRunning {
            if withcolours == true || !depthpresence{
                self.createcolorframes(baseimag: colorimage);
                count=0;sounds(environment: self.environment).changeposition(pos: depthforsound, colors: colorvalues);
            } else {count=0;sounds(environment: self.environment).changeposition(pos: depthforsound, colors: colorvalues);}}
            if depthpresence == false {count += 1}}
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
            horizontalbands[i]=(baseimage.cropped(to: CGRect(x: 0, y: spessorey*CGFloat(i), width: width, height: spessorey)).averageColor!)}
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
            if !depthpresence {let value = abs(Float(1 + colortoload)/Float(1 + colorvalues[i]))
                differenceincolor += max(value,1/value) - 1}
            if updatecolors || depthpresence {colorvalues[i] = colortoload}}
            updatecolors = false
            if differenceincolor > 1.8 {updatedepth = true;updatecolors = true;depthforsoundml(cameraImage: baseimag)}
    }

    func depthforsoundml(cameraImage: CIImage) {
        print("analyze")
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
        if model == nil {
            conf = MLModelConfiguration()
            conf.allowLowPrecisionAccumulationOnGPU = true
            model = try? VNCoreMLModel(for: FCRNFP16(configuration: conf!).model)}
        let request = VNCoreMLRequest(model: model!)
        let handler = VNImageRequestHandler(cgImage: cgImage2!)
        try? handler.perform([request])
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
                                valuecell += (convertedHeatmap[x][127-y])*7
                                    dimensioncell += 1
                                    }
                                    }
                                    depthforsound[lx + ly*latoquadratoaudio] = valuecell/Float(dimensioncell)
                    }}}
        }}
    
    
    func processaimmagine (cameraImage : CIImage) {
        rect = cameraImage.extent
        switch versionanalisys {
        case 1:
                let comicEffect = CIFilter(name: "CIGaussianBlur") // CIPhotoEffectChrome
                comicEffect?.setDefaults()
                comicEffect?.setValue(cameraImage, forKey: kCIInputImageKey)
                comicEffect?.setValue(max(0,30 - CGFloat((forceoftouch))*15), forKey: "inputRadius")
            guard let image = comicEffect?.outputImage else {return};cgImage = self.context.createCGImage(image, from: rect!)!
        default:
                let comicEffect = CIFilter(name: "CIEdges") // CIPhotoEffectChrome
                comicEffect?.setDefaults()
                comicEffect?.setValue(cameraImage, forKey: kCIInputImageKey)
                comicEffect?.setValue(7, forKey: "inputIntensity")
            let comicEffect2 = CIFilter(name: "CIAdditionCompositing") // CIPhotoEffectChrome
            comicEffect2?.setDefaults()
            comicEffect2?.setValue(comicEffect?.outputImage!, forKey: kCIInputImageKey)
            comicEffect2?.setValue(cameraImage, forKey: kCIInputBackgroundImageKey)
            //comicEffect2!.setValue(7, forKey: "inputIntensity")
            guard let image = comicEffect2?.outputImage else {return};cgImage = self.context.createCGImage(image, from: rect!)!
        }
        
        
        if tap == false {captureSession.stopRunning();newdepthframe = false
        let postprocessor = HeatmapPostProcessor()
        let comicEffect = CIFilter(name: "CINoiseReduction")
        comicEffect?.setDefaults()
        comicEffect?.setValue(cameraImage, forKey: kCIInputImageKey)
        var cgImage2 : CGImage?
            switch orientationr {
            case 3:
                let rotatedImage = comicEffect!.outputImage!.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.right.rawValue))
                let rotaterect = CGRect(x: Int((rect?.origin.y)!), y: Int((rect?.origin.x)!), width: Int(rect!.height), height: Int(rect!.width))
                if let image = self.context.createCGImage(rotatedImage, from: rotaterect) {cgImage2 = image}
                
            case 4:
                let rotatedImage = comicEffect!.outputImage!.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.right.rawValue))
                let rotaterect = CGRect(x: Int((rect?.origin.y)!), y: Int((rect?.origin.x)!), width: Int(rect!.height), height: Int(rect!.width))
                if let image = self.context.createCGImage(rotatedImage, from: rotaterect) {cgImage2 = image}
            default:
                if let image = comicEffect?.outputImage {if let image2 = self.context.createCGImage(image, from: rect!){cgImage2 = image2}}
            }
            if model == nil {
                conf = MLModelConfiguration()
                conf.allowLowPrecisionAccumulationOnGPU = true
                model = try? VNCoreMLModel(for: FCRNFP16(configuration: conf!).model)}
            let request = VNCoreMLRequest(model: model!)
            let handler = VNImageRequestHandler(cgImage: cgImage2!)
        try? handler.perform([request])
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
                
            return
            }
            
            newdepthframe = true
            let generator = UIImpactFeedbackGenerator();generator.impactOccurred()
            }
            
            }
    }

    func processaimmaginezoom (cameraImage : CIImage){
        rect = cameraImage.extent
        if tap == false {captureSession.stopRunning();newdepthframe = false
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
                cgImage2 = self.context.createCGImage(comicEffect!.outputImage!, from: rect!)!}
            if model == nil {
                conf = MLModelConfiguration()
                conf.allowLowPrecisionAccumulationOnGPU = true
                model = try? VNCoreMLModel(for: FCRNFP16(configuration: conf!).model)}
            let request = VNCoreMLRequest(model: model!)
            let handler = VNImageRequestHandler(cgImage: cgImage2!)
        try? handler.perform([request])
        if let observations = request.results as? [VNCoreMLFeatureValueObservation],
            let heatmap = observations.first?.featureValue.multiArrayValue {
            convertedHeatmap = postprocessor.convertTo2DArray(from: heatmap)
            newdepthframe = true
            let generator = UIImpactFeedbackGenerator();generator.impactOccurred()}}
    }
    

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        sccreentouched = false;
        if soundnohaptic {sounds(environment: environment).soundvibrate(inte: 0, sharp: 0.5)}
        if (soundstred == false && (!audioPlayer.isEmpty && !soundnohaptic)) || pinching {return}
        if motionManager.isDeviceMotionActive && tap == true {motionManager.stopDeviceMotionUpdates()
            corrtiltx = 10;corrtilty = 10;prem12 = 0;prem33 = 0;prem23 = 0;prem21 = 0;
        }
        if vibrating {
            do {
                try player?.stop(atTime: CHHapticTimeImmediate);vibrating = false;
            } catch let error {
                print("Error stopping the continuous haptic player: \(error)")
            }
        }
        timetowave = CACurrentMediaTime() - 10000;
    }
    
    
    
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake  {
            let filetoplay = ["1","2","3","4","5","6","2","4","6","1","3","5","1","7","8","9","10","11","12","13","14","15","16","audio1"]
            if passtosound > filetoplay.count - 1 {passtosound = 0;if soundnohaptic {sounds(environment: environment).soundoff()}} else {if passtosound == 0 {passtosound = 10} else {passtosound += 1};if soundnohaptic {sounds(environment: environment).soundoff();sounds(environment: environment).soundon()}}
            savevalues()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if hapticinhibittimer == nil {hapticinhibittimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(timerusage), userInfo: nil, repeats: true)}
        if devicehapticdevice == -1 {return}
        if !soundnohaptic {
        if devicehapticdevice > passtosound {
            if !hapticinit && mode != 3 && !soundnohaptic{if !self.createAndStartHapticEngine() {exit(0)} else {hapticinit = true}}} else {
                if !soundnohaptic {
                    if passtosound == 0 {
                alertnohaptics();
                        showpopup(texttoshow: defaultfornohaptics, acceptstring: defaultfornohapticsinstructions, yes: defaultforok)}
                    sounds(environment: environment).soundon()
                    return}}}
        if motionManager.isDeviceMotionActive && tap {motionManager.stopDeviceMotionUpdates()}
        xcorrection = Float(widthcamera)/screenwidth
        ycorrection = Float(heightcamera)/screenheight
        if (soundstred == false && (!audioPlayer.isEmpty && !soundnohaptic)) || pinching  {return}
            if self.traitCollection.forceTouchCapability == .unavailable {
                tdtouchabsencedefault = 1
            }
        if inhibittimer == true {return}
        sccreentouched = true;
        if let touch = touches.first {
            corrtiltx = 10; corrtilty = 10
            tocchi = touches;
          let location = touch.location(in: self.accessibilityview)
            xtouch = Float(location.x)*xcorrection
            ytouch = (Float(screenheight) - Float(location.y))*ycorrection
            forceoftouch = Float(max(touch.force,tdtouchabsencedefault))
        
        if rengine.isRunning == true && !soundnohaptic{return}
        if versionanalisys == 2 {return}
        if newdepthframe == false && tap == false {return}
        if tap == false && !pinching && !captureSession.isRunning {motion()}
        switch tap {
        case true:
            corrtilty=0;corrtiltx=0; if versionanalisys == 1 {colortovibr = UIColor(displayP3Red: CGFloat(color[0])/255, green: CGFloat(color[1])/255, blue: CGFloat(color[2])/255, alpha: 1)}
        default:
            if newdepthframe == false {return}
            
        }}
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)  {
        if motionManager.isDeviceMotionActive && tap {motionManager.stopDeviceMotionUpdates()}
        if (soundstred == false && (!audioPlayer.isEmpty && !soundnohaptic)) || pinching  {return}
        if rengine.isRunning == true && !soundnohaptic {return}
        if inhibittimer == true {return}
        if versionanalisys == 2 {return}
        prextouch = xtouch;preytouch = ytouch
        if newdepthframe == false && tap == false {return}
        if tap == false && !pinching && !captureSession.isRunning {motion()}
        if let touch = touches.first {tocchi = touches;
            let location = touch.location(in: self.accessibilityview)
            xtouch = Float(location.x)*xcorrection
            ytouch = (Float(screenheight) - Float(location.y))*ycorrection
            deltamove = sqrt(pow(prextouch-xtouch,2)+pow(preytouch-ytouch,2))
            forceoftouch = Float(max(touch.force,tdtouchabsencedefault))
        switch tap {
        case true:
            corrtilty=0;corrtiltx=0;if versionanalisys == 1 {colortovibr = UIColor(displayP3Red: CGFloat(color[0])/255, green: CGFloat(color[1])/255, blue: CGFloat(color[2])/255, alpha: 1)}
        default:
            if newdepthframe == false {return}
            
        }}
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
                self.vibradepth();
                self.analizza()
            }}}
            }
        }
    }
    

    
    
    
    func vibradepth() {
        if !sccreentouched || corrtiltx == 10 || corrtilty == 10 {return}
       //     let rect = rectangle ?? cameraImage!.extent
       //     let correctionx = Float(rect.width/(cameraImage?.extent.width ?? 0))
        //    let correctiony = Float(rect.height/(cameraImage?.extent.height ?? 0))
       //     intensitycolorofimage = cameraImage!.cropped(to: rect).cropped(to: CGRect(x: Int(correctionx*min(Float(cameraImage!.extent.width),max(0,xtouch - 2))), y: Int(correctiony*min(Float(cameraImage!.extent.height),max(0,ytouch - 2))), width: 4,height: 4)).averageColorsum ?? 765}
        intensitycolorofimage = 1
        var xtouchcorr = Float(0)
        var ytouchcorr = Float(0)
        //print(xtouch,xcorrection)

        switch orientationr{
        case 4:
             xtouchcorr = (ytouch - corrtilty*1000)/12
             ytouchcorr = (xtouch - corrtiltx*1000)/8.4375
            if xtouchcorr > 159 || xtouchcorr < 0 || ytouchcorr > 127 || ytouchcorr < 0 {
                do {
                    try player?.stop(atTime: CHHapticTimeImmediate);vibrating=false
                } catch let error {
                    print("Error stopping the continuous haptic player: \(error)")
                }
                return} else { touchvibr = (min(max(0,(1-convertedHeatmap [min(159,Int(xtouchcorr))][min(127,Int(ytouchcorr))])),1))}
        case 3:
             xtouchcorr = (ytouch + corrtilty*1000)/12
             ytouchcorr = (xtouch + corrtiltx*1000)/8.4375
            
      // print(xtouchcorr,ytouchcorr)
            if xtouchcorr > 159 || xtouchcorr < 0 || ytouchcorr > 127 || ytouchcorr < 0 {
                do {
                    try player?.stop(atTime: CHHapticTimeImmediate);vibrating=false
                } catch let error {
                    print("Error stopping the continuous haptic player: \(error)")
                }
                return} else {touchvibr = (min(max(0,(1-convertedHeatmap [min(159,Int(xtouchcorr))][min(127,128-Int(ytouchcorr))])),1))}
            
            
        default:
             xtouchcorr = (xtouch + corrtiltx*1000)/6.75
             ytouchcorr = (ytouch + corrtilty*1000)/16
            
           // print(xtouchcorr,ytouchcorr)
            if xtouchcorr > 159 || xtouchcorr < 0 || ytouchcorr > 127 || ytouchcorr < 0 {
                do {
                    try player?.stop(atTime: CHHapticTimeImmediate);vibrating=false
                } catch let error {
                    print("Error stopping the continuous haptic player: \(error)")
                }
                return} else {touchvibr = (min(max(0,(1-convertedHeatmap [min(159,Int(xtouchcorr))][min(127,128-Int(ytouchcorr))])),1))}
        }
        pretouchvibr = touchvibr
        if touchvibr > pretouchvibr + 0.15 && !soundnohaptic {let gen = UIImpactFeedbackGenerator(); gen.impactOccurred(intensity: CGFloat(min(1,touchvibr - pretouchvibr)));}
        let adjustwithforce = Float(forceoftouch)
        pretouchvibr=(touchvibr + pretouchvibr*10)/11
        if inhibittimer == true {return}
        if newdepthframe == false && tap == false {return}
        let differencetouchvibr = (touchvibr-pretouchvibr)*adjustwithforce*deltamove/6
        let inte = Float(max(0,min(1,touchvibr + differencetouchvibr))); //let sharp = Float(max(0,min(1,1-touchvibr*differencetouchvibr)))
        if soundnohaptic {
            let adjustwithforce = Float(forceoftouch)
            let differencetouchvibr = (touchvibr-pretouchvibr)*adjustwithforce*deltamove/6
            let inte = Float(max(0,min(1,touchvibr + differencetouchvibr)));
            sounds(environment: environment).soundvibrate(inte: 1, sharp: max(0,min(1,1-inte)))
            
            return
        }
        let intensityvar = Float(max(0.01,min(1,pow(inte, 0.7))))
        let sharpnessvar = Float(max(0,min(1,1-inte)))
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
                actualintensity = intensityvar
                actualsharpness = sharpnessvar
                        } catch let error {
                            print("Dynamic Parameter Error: \(error)")}
            default:
                        contintensity = CHHapticEventParameter(parameterID: .hapticIntensity, value:  Float(max(0.01,min(1,pow(inte, 0.7)))))
                        contsharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(max(0,min(1,1-inte))))
                actualintensity = contintensity.value
                actualsharpness = contsharpness.value

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
    
 //   override func didReceiveMemoryWarning() {
 //       if captureSession.isRunning && soundstred {
 //           basecount = 5}
      //  print(basecount)
 //   }
    
    
    func analizza() {
        if soundnohaptic {return}
        if inhibittimer == true {return}
        if sccreentouched {
            color = (filteredImage.image?.averageColor)!
            let redval1 = CGFloat(previousColor[0])/255
            let greenval1 = CGFloat(previousColor[1])/255
            let blueval1 = CGFloat(previousColor[2])/255
            previousColor = color
            let redval = CGFloat(color[0])/255
            let greenval = CGFloat(color[1])/255
            let blueval = CGFloat(color[2])/255
            let sumofdifferences = abs(redval1 - redval) + abs(greenval1 - greenval) + abs(blueval1 - blueval)
            if sumofdifferences*CGFloat(max(1,forceoftouch)) > 0.4 {
                let maxcolor = max(greenval,blueval,redval)
                let mincolor = min(greenval,blueval,redval)
                let diffcolor = min(max(maxcolor - mincolor,0.0001), 1)
                if maxcolor == redval {gradeofcolor = CGFloat(greenval - blueval)/CGFloat(diffcolor)}
                if maxcolor == greenval {gradeofcolor = 2 + CGFloat(blueval - redval)/CGFloat(diffcolor)}
                if maxcolor == blueval {gradeofcolor = 4 + CGFloat(redval - greenval)/CGFloat(diffcolor)}
                if gradeofcolor > 5.7 {gradeofcolor = 0} else if gradeofcolor < 0 {gradeofcolor = 0}
                let colorpattern = Array(repeating: gradeofcolor/5.7, count: 1)
                //print(colorpattern, gradeofcolor,diffcolor,greenval,blueval,redval)
                //let colorintensity = Float((redval + greenval + blueval) - abs(greenval - blueval) - abs(blueval - redval) - abs(redval - greenval))/3
                let intervaltime = 0//((log10(1+(redval/greenval)/blueval))/(redval + greenval + blueval))*100
                var events = [CHHapticEvent]()
                            do {try player?.stop(atTime: CHHapticTimeImmediate); vibrating = false;
                    } catch let error {print("Error stopping the continuous haptic player: \(error)")}
                    for i in stride(from: 0, to: 1, by: 1) {
                        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: min(1,max(0.3,0.5*Float(sumofdifferences)*Float(pow(1+forceoftouch, 0.3)))))
                        //print(sumofdifferences)
                        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(colorpattern[i]))
                        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: Double(intervaltime/4))
                        events.append(event)}
                    do {let pattern = try CHHapticPattern(events: events, parameters: [])
                        player = try engine?.makeAdvancedPlayer(with: pattern)
                        if !inhibittimer {  try player?.start(atTime: 0)}
                        events.removeAll()
                    } catch {
                        print("Failed to play pattern: \(error.localizedDescription).")
                    };
               }
            ;
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
       if captureSession.canSetSessionPreset(.vga640x480) {captureSession.sessionPreset = AVCaptureSession.Preset.vga640x480} else if captureSession.canSetSessionPreset(.hd1920x1080) { captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080} else {captureSession.sessionPreset = AVCaptureSession.Preset.low}
      do {let cameraInput = try AVCaptureDeviceInput(device: (self.backCameradepth))
        captureSession.addInput(cameraInput)} catch {fatalError(error.localizedDescription)}
      let videoOutput = AVCaptureVideoDataOutput()
      videoOutput.setSampleBufferDelegate(self, queue: .main)
      videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
      captureSession.addOutput(videoOutput)
      let videoConnection = videoOutput.connection(with: .video)
        videoConnection!.videoOrientation = .portrait
      let depthOutput = AVCaptureDepthDataOutput()
        depthOutput.setDelegate(self, callbackQueue: .main)
      depthOutput.isFilteringEnabled = true
      captureSession.addOutput(depthOutput)
      let depthConnection = depthOutput.connection(with: .depthData)
        depthConnection!.videoOrientation = .portrait
        do {try self.backCameradepth.lockForConfiguration();
                    if self.backCameradepth.isLowLightBoostSupported == true {self.backCameradepth.automaticallyEnablesLowLightBoostWhenAvailable = true}
                    if backCameradepth.hasTorch {if backCameradepth.isTorchModeSupported(.auto) == true {backCameradepth.torchMode = .auto}}
                    if self.backCameradepth.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) == true {self.backCameradepth.whiteBalanceMode = .continuousAutoWhiteBalance}
                    if self.backCameradepth.isExposureModeSupported(.continuousAutoExposure) == true {self.backCameradepth.exposureMode = .continuousAutoExposure}
            } catch {print("error")}
            if let format = self.backCameradepth.activeDepthDataFormat,
              let range = format.videoSupportedFrameRateRanges.first  {self.backCameradepth.activeVideoMinFrameDuration = range.minFrameDuration}
            self.backCameradepth.unlockForConfiguration()
        self.addobserver()
        captureSession.startRunning()
        self.view.isUserInteractionEnabled = true
        }
    /*
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
*/
    func addobserver(){
        
        NotificationCenter.default.addObserver(self,selector: #selector(tempchange),name: ProcessInfo.thermalStateDidChangeNotification,object: nil)}
    
   @objc func tempchange(){
    do {let state = ProcessInfo.processInfo.thermalState.rawValue
    if state == 0 {basecount = 2}
    if state > 2 {basecount = 10}
    if (state < 2 && latoquadratoaudio == 5) || (state > 1 && latoquadratoaudio == 3) || soundstred == false {return}
    //print("obs",state)
    if rengine.isRunning {for i in 0...audioPlayer.count - 1 {rengine.detach(audioPlayer[i])};let a = sounds(environment: environment).endplay();environment.reset();soundstred = a;}
    if state > 1 {latoquadratoaudio = 3} else {latoquadratoaudio = 5}
    sounds(environment: environment).playsounds()
    }}
    func vibradepthrt(vibr: Float) {
        if soundnohaptic {
            let adjustwithforce = Float(forceoftouch)
            let vibradj = pow(vibr+1,1.3)-1+(vibr-previbr)*pow(adjustwithforce,0.3)*deltamove/50
            var sha = Float(0)
            if depthpresence {sha = Float(max(0,min(1,1-vibradj)))} else {sha = 1 - Float(gradeofcolor/5)}
            sounds(environment: environment).soundvibrate(inte: 1, sharp: sha)
            return
        }
        if vibr > previbr + 0.15 {let gen = UIImpactFeedbackGenerator(); gen.impactOccurred(intensity: CGFloat(min(1,vibr - previbr)));}
        let adjustwithforce = Float(forceoftouch)*0.7
        let vibradj = pow(vibr+1,1.3)-1+(vibr-previbr)*pow(adjustwithforce,0.3)*deltamove/50
        previbr=(vibr + previbr*10)/11
        if inhibittimer == true {return}

        let luminosity = 0.3333 + Float(intensitycolorofimage)/1152
        var sha = Float(0)
        if depthpresence {sha = Float(max(0,min(1,1-vibradj)))} else {sha = 1 - Float(gradeofcolor/5)}
        print(sha)
        switch vibrating {
        case true:
            let intensityvar = Float(luminosity)
            let sharpnessvar = sha
            
            let intensityParameter = CHHapticDynamicParameter(parameterID: .hapticIntensityControl,
                                                              value: intensityvar,
                                                              relativeTime: 0)
            
            let sharpnessParameter = CHHapticDynamicParameter(parameterID: .hapticSharpnessControl,
                                                              value: sharpnessvar,
                                                              relativeTime: 0)
            
            do {
                try player?.sendParameters([intensityParameter, sharpnessParameter],
                                                    atTime: 0)
                actualintensity = intensityvar
                actualsharpness = sharpnessvar
            } catch let error {
                print("Dynamic Parameter Error: \(error)")
            };
            
        default:
            contintensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: luminosity)
            contsharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sha)
            actualintensity = contintensity.value
            actualsharpness = contsharpness.value
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
        if soundnohaptic {
            let value = (max(-1,min(1,max(-200,inclination)/200))+1)/2
            sounds(environment: environment).soundvibrate(inte: 1, sharp: value)
            return
        }
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


    func vibracolor(color: [Int]) {
        if soundnohaptic {
            let redval1 = Float(color[0])/256
            let greenval1 = Float(color[1])/256
            let blueval1 = Float(color[2])/256
            sounds(environment: environment).soundvibrate(inte: 1, sharp: (redval1 + greenval1 + blueval1)/3)
            return
        }
        if inhibittimer || CACurrentMediaTime() < timetowave {return}
        print(color)
        var events = [CHHapticEvent]()
        let redval1 = Float(color[0])/256
        let greenval1 = Float(color[1])/256
        let blueval1 = Float(color[2])/256
        
        let inte = Float(redval1+greenval1+blueval1)/6 + 0.3
        let arrayvibrcolor = [pow(inte,Float(redval1/(max(0.0001,greenval1)))),pow(inte,Float(redval1/(max(0.0001,blueval1)))),pow(inte,Float(greenval1/(max(0.0001,(redval1+blueval1)/2)))),pow(inte,Float(greenval1/((max(0.0001,blueval1))))),pow(inte,Float(blueval1/(max(0.0001,greenval1)))),pow(inte,Float(blueval1/(max(0.0001,redval1))))]
        for i in 0...5 {
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1-(max(0,arrayvibrcolor[i])))
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: max(0,min(1,arrayvibrcolor[i])))
                let intervall : TimeInterval = TimeInterval((arrayvibrcolor[i]/7))
                let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime:0.2*Double(i), duration: 0.1+intervall*Double(i))
        events.append(event)
        }
        if vibrating {
        do {
            try player?.stop(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Error stopping the continuous haptic player: \(error)");return
        }}
            do {
                
        patternvibrcolor = try CHHapticPattern(events: events, parameters: [])
        
        player = try engine?.makeAdvancedPlayer(with: patternvibrcolor!)
                if !inhibittimer {  try player?.start(atTime: 0)}
                timetowave =  CACurrentMediaTime() + patternvibrcolor!.duration
        events.removeAll()
        } catch {
        print("Failed to play pattern: \(error.localizedDescription).");return
        }
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
    func clampforcolor() -> [Int]{
        CVPixelBufferLockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
        let baseAddress = CVPixelBufferGetBaseAddress(self)
        let  width = CVPixelBufferGetWidth(self)
        let  height = CVPixelBufferGetHeight(self)
        var redcell : Float = 0
        var bluecell : Float = 0
        var greencell : Float = 0
        var dimensioncell = 1
        if let byteBuffer = baseAddress?.assumingMemoryBound(to: UInt8.self){
        //let colorSpace = CGColorSpaceCreateDeviceRGB()
        //let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        //let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
            if tap {corrtiltx = 0;corrtilty = 0}
        let extent = Int(pow(1 + forceoftouch,0.7) * 4) + 2
        let startx = max(0,min(width - 1,Int(xtouch + corrtiltx*1000) - extent))
        let endx = min((width - 1),startx + extent)
        let starty = max(0,min(height - 1,height - Int(ytouch + corrtilty*1000) - extent))
        let endy = min((height - 1),starty) + extent
            for x in startx...endx{
            for y in starty...endy {
                let index = (y * width + x) * 4
                bluecell += Float(byteBuffer[index])
                greencell += Float(byteBuffer[index+1])
                redcell += Float(byteBuffer[index+2])
                dimensioncell += 1
                    }
        }
            print(redcell,dimensioncell,greencell,dimensioncell,bluecell,dimensioncell,startx,endx,starty,endy)
        }
        CVPixelBufferUnlockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
        return [Int(redcell/Float(dimensioncell)), Int(greencell/Float(dimensioncell)),Int(bluecell/Float(dimensioncell))]
    }
    
    
  func clamp() {
    var maxpixel : Float = 0
    var minpixel : Float = 10
    var adjustscale : Float = 1
    let width = min(CVPixelBufferGetWidth(self),CVPixelBufferGetHeight(self)) // 240
    let height = max(CVPixelBufferGetWidth(self),CVPixelBufferGetHeight(self)) // 320
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
                        if valuetoadd < 0 {valuetoadd = 7 - valuetoadd}
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
                for y in stride(from: 0, to: height - 1, by: 1) {
                for x in stride(from: 0, to: width - 1 , by: 1) {
                    var pixel = floatBuffer[y * width + x]
                    if pixel < 0 {pixel = 7 - pixel}
                    let corr = Int(x-Int(xtouch/2.6667))
                        if x > 0 {
                            inclination += (pixel-prepixel)*Float(corr.signum())
                                }
                        if x != width - 1  {prepixel = pixel}
                                                        }
                  };
                let incl = (preinclination*2+inclination)/3
                if sccreentouched == true {if countforbast > 15{ViewController().vibradepthrtbast(vibr: 0.1, inclination: incl)}} else {
                    switch soundnohaptic {
                    case true:
                        sounds(environment: ViewController().environment).soundvibrate(inte: 0, sharp: 0)
                    default:
                        if vibrating {
                        do {
                            try player?.stop(atTime: CHHapticTimeImmediate); vibrating = false
                        } catch let error {
                            print("Error stopping the continuous haptic player: \(error)")
                        }}
                    }
                    
                    
                }
                preinclination = incl
            default:
                for y in stride(from: Int(Float(height)/2 - Float(height)/32), to: Int(Float(height)/2 + Float(height)/32), by: 1) {
                for x in stride(from: Int(Float(width)/2 - Float(width)/32), to: Int(Float(width)/2 + Float(width)/32), by: 1) {
                  var pixel = floatBuffer[y * width + x]
                    if pixel < 0 {pixel = 7 - pixel}
                    mediumdistance += pixel
                    granulosity += abs(pixel-prepixel)
                    if x != Int(Float(width)/2 - Float(width)/32) {prepixel = pixel}
                }
                  };
                let incl = (preinclination*5+inclination)/6
                var distance = mediumdistance
                if abs(distance - prebastdistance) < 200 {distance = (prebastdistance*3 + mediumdistance)/4}
                prebastdistance = mediumdistance
                if firstcanedistance == true {maxbastonedistance = distance; firstcanedistance = false}
                if distance > maxbastonedistance && countforbast > 15 {ViewController().vibradepthrtbast(vibr: 0.9, inclination: -(granulosity/abs(mediumdistance)*10000-200))//hapticevent(intensit: granulosity/abs(mediumdistance))
                preinclination = incl
                } else
                {
                    switch soundnohaptic {
                    case true:
                        sounds(environment: ViewController().environment).soundvibrate(inte: 0, sharp: 0)
                    default:
                        if vibrating {
                        do {
                            try player?.stop(atTime: CHHapticTimeImmediate); vibrating = false
                        } catch let error {
                            print("Error stopping the continuous haptic player: \(error)")
                        }}
                    }

                }

            }
        case 1:
            print("refer to accodaflusso")
        default:
            if sccreentouched == true && tap == true { let x = Int(xtouch/2) //Int(1/(Double(forceoftouch ?? 0)-1.5))
            let y = Int((Float(heightcamera)-ytouch)/2) //Int(1/(Float(forceoftouch ?? 0)-1.5))
            if sccreentouched == true {
            let adjustareaforc = (15-Float((forceoftouch)*2.5-2))*30
            let adjustareaforce = Int(adjustareaforc)
            let yareastart = max(0,y-(adjustareaforce))
            let yareaend = min(height - 1,y+(adjustareaforce))
            let xareastart = max(0,x-(adjustareaforce))
            let xareaend = min(width - 1 ,x+(adjustareaforce))
            for y in stride(from: yareastart, to: yareaend, by: 1) {
            for x in stride(from: xareastart, to: xareaend, by: 1) {
              var pixel = floatBuffer[y * width + x]
                if pixel < 0 {pixel = 7 - pixel}
              if pixel > maxpixel {maxpixel = pixel}
              if pixel < minpixel {minpixel = pixel}
              //floatBuffer[y * width + x] = min(1.0, max(pixel, 0.0))
            }
                };adjustscale = (maxpixel-minpixel);
        }
            
                var a = (floatBuffer[x * width + y])
                
                if a < 0 {a = 7 - a}
            
                ViewController().vibradepthrt(vibr: a/adjustscale)}
    };

    CVPixelBufferUnlockBaseAddress(self, CVPixelBufferLockFlags(rawValue: 0))
  }
}












extension UIImage {
    var averageColor: [Int]? {
        guard let inputImage = CIImage(image: self) else {return nil }
        let xcorr = Float(inputImage.extent.width/CGFloat(widthcamera));
        let ycorr = Float(inputImage.extent.height/CGFloat(heightcamera))
        var xforextent : CGFloat?;var yforextent : CGFloat?
        xforextent = CGFloat(xtouch*xcorr) + CGFloat(Int(corrtiltx*1000) - 2); yforextent = (CGFloat(ytouch*ycorr) + CGFloat(Int(corrtilty*1000)-2))
        let extentVector = CIVector(x: xforextent ?? 0, y: (yforextent ?? 0), z: 4, w: 4)
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else {return nil }
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        return [Int(bitmap[0]),Int(bitmap[1]),Int(bitmap[2])]
    }
}

extension CGImage {
    func touimage() -> UIImage {
        UIImage(cgImage: self)
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
        soundnohaptic = false
        if rengine.isRunning == false && audioPlayer.count == 0 {soundstred = false;captureSession.startRunning(); return false}
        return true
    }
    
    func changeposition(pos: [Float], colors: [Int]){
        if audioPlayer.isEmpty {return}
        if audioPlayer.count != latoquadratoaudio*latoquadratoaudio*2{return}
        if audioPlayer[0].volume < 0.9 {
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
    
    func soundon() {
        let filetoplay = ["1","2","3","4","5","6","2","4","6","1","3","5","1","7","8","9","10","11","12","13","14","15","16","audio1"]
        let path1 = Bundle.main.path(forResource: filetoplay[max(0,passtosound - 10)], ofType: "wav")!
        let url = URL(fileURLWithPath: path1)
        do{
            let file = try AVAudioFile(forReading: url)
            let songLengthSamples = file.length
            let songFormat = file.processingFormat
            let sampleRateSong = Double(songFormat.sampleRate)
            let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(songLengthSamples))!
            do {
                try file.read(into: buffer)
                } catch _ {
                }
        
        environment.listenerPosition = AVAudio3DPoint(x: 0.0, y: 0.0, z: 0.0);
        environment.listenerVectorOrientation = AVAudioMake3DVectorOrientation(AVAudioMake3DVector(0, 0, -1), AVAudioMake3DVector(0, 0, 0))
        environment.listenerAngularOrientation = AVAudioMake3DAngularOrientation(0.0,0.0, 0.0)
        environment.distanceAttenuationParameters.rolloffFactor = 1
        rengine.attach(environment)
        audioPlayer.append(AVAudioPlayerNode())
            audioPlayer[0].renderingAlgorithm = .auto
        audioPlayer[0].volume = 0
        rengine.attach(audioPlayer[0])
        rengine.connect(audioPlayer[0], to: environment, format:  AVAudioFormat.init(standardFormatWithSampleRate: sampleRateSong, channels: 1))
            rengine.connect(environment, to: rengine.mainMixerNode, format:  nil)
            rengine.prepare()
            
            do {
                  try rengine.start()        } catch {
                      print("Unable to start AVAudioEngine: \(error.localizedDescription)")
                  }
        
        let time = AVAudioTime(hostTime: mach_absolute_time(), sampleTime: AVAudioFramePosition(0), atRate: sampleRateSong)
        audioPlayer[0].scheduleBuffer(buffer, at: nil, options: AVAudioPlayerNodeBufferOptions.loops, completionHandler: nil)
        audioPlayer[0].play(at: time)
        } catch {}
        soundnohaptic = true
        audioPlayer[0].position = AVAudio3DPoint(x: 0, y: 0, z: -10)
    }
    
    func soundoff(){
        rengine.stop()
        rengine.reset()
        audioPlayer.removeAll()
        environment.reset()
        soundnohaptic = false
    }
    
    func soundvibrate(inte: Float,sharp:Float){
        audioPlayer[0].rate = sharp*1.5 + 0.5
        audioPlayer[0].volume = inte
        print("sharp",audioPlayer[0].rate)
        audioPlayer[0].reverbBlend = sharp
    }
    
    func playsounds(){
        print("playsound")
        captureSession.stopRunning()
        if soundnohaptic {soundoff()}
        if audioPlayer.count != latoquadratoaudio*latoquadratoaudio {resetlatoquadratoaudio(lato: latoquadratoaudio)}
        let filetoplay = ["1","2","3","4","5","6","2","4","6","1","3","5","1","7","8","9","10","11","12","13","14","15","16"]
        if musicfilenumber >= filetoplay.count-1{musicfilenumber = 0}
        if musicfilenumber < 0 {musicfilenumber = 0}
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

extension AVCaptureDevice {
    func setminframe() {
        if let range = activeFormat.videoSupportedFrameRateRanges.first
    {do {
        activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: Int32(range.minFrameRate))
       
    }
    }}
}

