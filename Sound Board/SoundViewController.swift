//
//  SoundViewController.swift
//  Sound Board
//
//  Created by Luis Medinelli on 3/2/17.
//  Copyright © 2017 iBeacon Solutions. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var audioRecorder : AVAudioRecorder?  = nil
    var audioPlayer : AVAudioPlayer? = nil
    var audioUrl : URL?
    
    @IBOutlet weak var soundTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
        
    }
    
    
    func setUpRecorder(){
        do{
            // create audio session
            
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            // create url for audio file
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath,"audio.m4a"]
            audioUrl = NSURL.fileURL(withPathComponents: pathComponents)!
            //print(audioURL)
            
            // create setting to audio recording
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
            settings[AVSampleRateKey] = 44100.0 as AnyObject
            settings[AVNumberOfChannelsKey] = 2 as AnyObject
            
            // create audiorecorder object
            audioRecorder = try AVAudioRecorder(url: audioUrl!, settings: settings)
            audioRecorder?.prepareToRecord()
        }catch let error as NSError {
            
            print(error)
            
        }
        
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        
        //print("Record button tapped")
        
        if audioRecorder!.isRecording{
            //print("Stoping recording")
            // stop recording
            audioRecorder!.stop()
            
            // change button to Record
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled=true
            addButton.isEnabled=true

            
        }else{
            //print("Starting recording")
            // stsrt recording
            audioRecorder!.record()
            
            // chage button title to stop
            recordButton.setTitle("Stop Recording", for: .normal)
            
        }
    }
    

    
    @IBAction func playTapped(_ sender: Any) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: audioUrl!)
            audioPlayer!.play()
        }catch let error as NSError{
            print(error)
        }
    }
    
    
    @IBAction func addTapped(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let sound = Sound(context: context)
        
        sound.name = soundTextField.text!
        sound.audio = NSData(contentsOf: audioUrl!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}
