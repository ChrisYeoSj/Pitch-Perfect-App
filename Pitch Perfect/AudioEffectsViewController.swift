//
//  AudioEffectsViewController.swift
//  Pitch Perfect
//
//  Created by Christopher on 20/7/15.
//  Copyright (c) 2015 Nox. All rights reserved.
//

import UIKit
import AVFoundation

class AudioEffectsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var audioPlayerEcho : AVAudioPlayer!
    var recordedAudio : RecordedAudio!
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!
    var audioPlayerNode : AVAudioPlayerNode!

    @IBOutlet var echoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recordedAudio.filePath, error: nil)
        audioPlayerEcho = AVAudioPlayer(contentsOfURL: recordedAudio.filePath, error: nil)
        audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio.filePath, error: nil)
        audioPlayer.prepareToPlay()
        audioPlayer.enableRate = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func PlaySoundSlowly(sender: UIButton) {
        regulateRateAndPlay(0.5) // slow speed - rate = 0.5
    }
    @IBAction func playAudioQuickly(sender: UIButton) {
        regulateRateAndPlay(2.0) // top speed - rate = 2.0
    }
    @IBAction func stopAudio(sender: UIButton) {
       stopAll()
    }
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    @IBAction func playEchoButton(sender: UIButton) {
        
        var playTime : NSTimeInterval = 0
        
        stopAll()
        audioPlayer.rate = 1.0 // default standard rate
        audioPlayer.play()
        
        let delay : NSTimeInterval = 0.2 // delay of 200ms to hear an effective echo
        playTime = audioPlayerEcho.deviceCurrentTime + delay
        audioPlayerEcho.stop()
        audioPlayerEcho.currentTime = 0.0
        audioPlayerEcho.volume = 0.8
        audioPlayerEcho.playAtTime(playTime)
    }


    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1100)
    }
    
    func regulateRateAndPlay(rate: Float){
        ///Plays Audio at a specified rate (Float)
        stopAll()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    func stopAll(){
        /// Stop all audio
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0
        audioPlayer.stop()
        if audioPlayerNode != nil {
            audioPlayerNode.stop()
        }
        if audioPlayerEcho != nil{
            audioPlayerEcho.stop()
        }
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        /// Plays Audio With a Specified Variable Pitch
        stopAll()
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
}
