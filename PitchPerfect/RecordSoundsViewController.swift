//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Kumar, Navneet on 2018/12/05.
//  Copyright © 2018 Rakuten. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    var audioFileUrl : URL?
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecording: UIButton!
    @IBOutlet weak var startRecording: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(_ sender: Any) {
        recordingLabel.text = "Recording in progress";
        // enable button
        stopRecording.isEnabled = true;
        startRecording.isEnabled = false;
        
        startAudioRecording();
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        stopRecording.isEnabled = false;
        startRecording.isEnabled = true;
        recordingLabel.text = "Tap to Record";
        stopAudioRecording();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // disable the stop recording button
        stopRecording.isEnabled = false;
    }
    
    func startAudioRecording()
    {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String;
        let recordingName = "recordedVoice.wav";
        let pathArray = [dirPath, recordingName];
        // assign to pass to next view controller
        audioFileUrl = URL(string: pathArray.joined(separator: "/"));
        
        let session = AVAudioSession.sharedInstance();
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker);
        
        try! audioRecorder = AVAudioRecorder(url: audioFileUrl!, settings: [:]);
        audioRecorder.delegate = self;
        audioRecorder.isMeteringEnabled = true;
        audioRecorder.prepareToRecord();
        audioRecorder.record();
    }
    
    func stopAudioRecording(){
        audioRecorder.stop();
        let audioSession = AVAudioSession.sharedInstance();
        try! audioSession.setActive(false);
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag)
        {
           performSegue(withIdentifier: "stopRecording", sender: nil)
        }
        else
        {
            print("failed to record")
        }
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsViewController = segue.destination as! PlaySoundsViewController;
            playSoundsViewController.recordedAudioUrl = audioFileUrl;
        }
    }
}

