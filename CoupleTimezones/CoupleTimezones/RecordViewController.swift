//
//  RecordViewController.swift
//  CoupleTimezones
//
//  Created by Ant on 26/02/2017.
//  Copyright © 2017 Ant. All rights reserved.
//

import UIKit
import AudioKit

class RecordViewController: UIViewController {
    
    var recorder: AKNodeRecorder?
    var player: AKAudioPlayer?
    var tape: AKAudioFile?
    var micBooster: AKBooster?
    var moogLadder: AKMoogLadder?
    var delay: AKDelay?
    
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var inputPlot: AKNodeOutputPlot!
    @IBOutlet weak var outputPlot: AKOutputWaveformPlot!
    
    var state = State.readyToRecord
    var recordedDuration: Double = 0
    enum State {
        case readyToRecord
        case recording
        case readyToPlay
        case playing
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Clean tempFiles !
        AKAudioFile.cleanTempDirectory()
        
        // Session settings
        AKSettings.bufferLength = .medium
        
        do {
            try AKSettings.setSession(category: .playAndRecord, with: .defaultToSpeaker)
        } catch { print("Errored setting category.") }
        
        // Patching
        let mic = AKMicrophone()
        inputPlot.node = mic
        let micMixer = AKMixer(mic)
        micBooster = AKBooster(micMixer)
        
        // Will set the level of microphone monitoring
        micBooster!.gain = 0
        recorder = try? AKNodeRecorder(node: micMixer)
        player = try? AKAudioPlayer(file: (recorder?.audioFile)!)
        player?.looping = false
        player?.completionHandler = playingEnded
        
        moogLadder = AKMoogLadder(player!)
        
        let mainMixer = AKMixer(moogLadder!, micBooster!)
        
        AudioKit.output = mainMixer
        AudioKit.start()
    }
    
    func playingEnded() {
        DispatchQueue.main.async {
            self.state = .readyToPlay
            self.statusLbl.text = "Recorded: \(self.recordedDuration)"
            self.startBtn.setTitle("Play", for: .normal)
        }
    }

    @IBAction func startBtnOnClick(sender: UIButton) {
        switch state {
        case .readyToRecord :
            statusLbl.text = "Recording"
            startBtn.setTitle("Stop", for: .normal)
            state = .recording
            // microphone will be monitored while recording
            // only if headphones are plugged
            if AKSettings.headPhonesPlugged {
                micBooster!.gain = 1
            }
            do {
                try recorder?.record()
            } catch { print("Errored recording.") }
            
        case .recording :
            // Microphone monitoring is muted
            micBooster!.gain = 0
            do {
                try player?.reloadFile()
            } catch { print("Errored reloading.") }
            
            let recordedDuration = player != nil ? player?.audioFile.duration  : 0
            if recordedDuration! > 0.0 {
                recorder?.stop()
                player?.audioFile.exportAsynchronously(name: "TempTestFile.m4a", baseDir: .documents, exportFormat: .aif) {_, error in
                    if error != nil {
                        print("Export Failed \(error)")
                    } else {
                        print("Export succeeded")
                    }
                }
                self.recordedDuration = recordedDuration!
                self.statusLbl.text = "Recorded: \(recordedDuration!)s"
                self.startBtn.setTitle("Play", for: .normal)
                
                self.state = .readyToPlay
            }
        case .readyToPlay :
            player!.play()
            statusLbl.text = "Playing..."
            startBtn.setTitle("Stop", for: .normal)
            state = .playing
        case .playing :
            player?.stop()
            state = .readyToPlay
            self.statusLbl.text = "Recorded: \(self.recordedDuration)s"
            self.startBtn.setTitle("Play", for: .normal)
        }
    }
    
    @IBAction func resetBtnOnClick(sender: UIButton) {
        player!.stop()
        do {
            try recorder?.reset()
            self.state = .readyToRecord
        } catch { print("Errored resetting.") }
    }

    @IBAction func dismissBtnOnClick(_ sender: UIButton) {
        print("dismiss")
    }
    @IBAction func saveBtnOnClick(_ sender: UIButton) {
        print("save")
    }
}
