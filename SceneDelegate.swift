//
//  SceneDelegate.swift
//  VibView
//
//  Created by Lorenzo Giannantonio on 20/01/2020.
//  Copyright © 2020 Lorenzo Giannantonio. All rights reserved.
//

import UIKit
import AVFoundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
   // var environment = AVAudioEnvironmentNode()
   // var audioPlayer = [AVAudioPlayerNode]()
    var window: UIWindow?
    var activeornot : Bool = false
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        activeornot = false
        engine?.stop()
        if captureSession.isRunning {
        captureSession.stopRunning()
        }

        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
 //  let defaults = UserDefaults.standard
 //  do {let encodedData = try NSKeyedArchiver.archivedData(withRootObject: (saveddefault ?? [true,true,false,10,Float(1.3),0,0]) as Array, requiringSecureCoding: false)
 //             defaults.set(encodedData, forKey: "VibViewSavedpreferences")} catch {print("not saved")}
                do{
            
            if let SavedPreferences = UserDefaults.standard.object(forKey: "VibViewSavedpreferences") as? Data{
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
                }
                
            }
        }catch {print("notsavedpreferences")}
        
        if captureSession.isRunning == false {captureSession.startRunning()}
        activeornot = true
        
        if soundstred == true {
            do {
                try rengine.start()
            } catch {
                print("There was an error creating the engine: \(error.localizedDescription)")
            }
        }
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        if (versionanalisys == 2 && mode == 1) || (versionanalisys == 0 && mode == 3) || (versionanalisys == 0 && mode == 0) || (versionanalisys == 1 && mode == 2)
        {saveddefault = [typeplay,false,typeofcane,musicfilenumber,volumeadjusting,mode,versionanalisys]
            print("saving")
        let defaults = UserDefaults.standard
        do {let encodedData = try NSKeyedArchiver.archivedData(withRootObject: (saveddefault ?? [true,true,false,10,Float(1.3),0,false,0]) as Array, requiringSecureCoding: false)
            defaults.set(encodedData, forKey: "VibViewSavedpreferences")} catch {print("not saved")}}
        activeornot = false
        engine?.stop()
        if captureSession.isRunning {
                captureSession.stopRunning()
            
            
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        if captureSession.isRunning == false {captureSession.startRunning()}
        activeornot = true
        do {
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
        
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {

        engine?.stop()
        if captureSession.isRunning {
                captureSession.stopRunning()
        }
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

