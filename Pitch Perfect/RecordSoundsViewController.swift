//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Christopher on 12/7/15.
//  Copyright (c) 2015 Nox. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet var resumeButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var recordingProgressLabel: UILabel!
    @IBOutlet var stopButton: UIButton!
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordingProgressLabel.text = "Tap to Record"
    }
    
    override func viewDidAppear(animated: Bool) {
    recordingProgressLabel.hidden = false
    recordingProgressLabel.text = "Tap to Record"
    stopButton.hidden = true
    resumeButton.hidden = true
    pauseButton.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        /// initiates recording
        recordingProgressLabel.text = "Recording ..."
        stopButton.hidden = false
        pauseButton.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]        //array of Directory Path and Name of recorded file
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag){
            recordedAudio = RecordedAudio(filePath: recorder.url, title: recorder.url.pathExtension!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    @IBAction func pauseRecordingButton(sender: UIButton) {
        ///Pause Recording
        pauseButton.hidden = true
        resumeButton.hidden = false
        audioRecorder.pause()
    }
    
    @IBAction func resumeRecordingButton(sender: UIButton) {
        ///Resume Recording from Paused
        resumeButton.hidden = true
        pauseButton.hidden = false
        audioRecorder.record()
    }
    
    
    @IBAction func stopButton(sender: UIButton) {
        ///Stop Recording
        recordingProgressLabel.hidden = true
        stopButton.hidden = false
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC: AudioEffectsViewController = segue.destinationViewController as! AudioEffectsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.recordedAudio = data
        }
    }
}

