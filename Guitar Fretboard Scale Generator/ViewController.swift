//
//  ViewController.swift
//  Guitar Fretboard Scale Generator
//
//  Created by Christian Hackl on 24.09.16.
//  Copyright © 2016 Christian Hackl. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    // Outlets
    @IBOutlet weak var fretboardView: Fretboardview!
    @IBOutlet weak var keySelection: NSPopUpButton!
    @IBOutlet weak var scaleSelection: NSPopUpButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func changeKey(sender: NSPopUpButton) {
        let selectedKey = self.keySelection.titleOfSelectedItem!
        let selectedScaleIndex = self.scaleSelection.indexOfSelectedItem
        let majorScale = [2, 2, 1, 2, 2, 2, 1]
        var selectedScale = [Int](count: majorScale.count, repeatedValue: 0)
        
        for i in 0 ..< majorScale.count {
            let shift = (i + selectedScaleIndex) % majorScale.count
            selectedScale[i] = majorScale[shift]
        }
        self.createScaleWithKey(selectedKey.capitalizedString, scale: selectedScale)
    }
    
    @IBAction func changeScale(sender: NSPopUpButton) {
        let selectedKey = self.keySelection.titleOfSelectedItem!
        let selectedScaleIndex = self.scaleSelection.indexOfSelectedItem
        let majorScale = [2, 2, 1, 2, 2, 2, 1]
        var selectedScale = [Int](count: majorScale.count, repeatedValue: 0)
        
        for i in 0 ..< majorScale.count {
            let shift = (i + selectedScaleIndex) % majorScale.count
            selectedScale[i] = majorScale[shift]
        }
        self.createScaleWithKey(selectedKey.capitalizedString, scale: selectedScale)
    }
    
    func createScaleWithKey(key: String, scale: [Int]) {
        let frets = fretboardView.frets
        let notes = ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"]
        var notesInScale = [String](count: 7, repeatedValue: "-")
        var resultScale = Array(count: 6, repeatedValue: [String](count: frets, repeatedValue: "-"))
        // Start at the 1st fret at each string
        resultScale[0][0] = "F"
        resultScale[1][0] = "A#"
        resultScale[2][0] = "D#"
        resultScale[3][0] = "G#"
        resultScale[4][0] = "C"
        resultScale[5][0] = "F"
        
        // Add all notes up to 16nd string
        for i in 0..<resultScale.count {
            let firstNote = resultScale[i][0]
            let firstNoteIndex = notes.indexOf(firstNote)!
            
            for j in 0..<resultScale[i].count {
                let indexOfNote = (firstNoteIndex + j) % notes.count
                resultScale[i][j] = notes[indexOfNote]
            }
        }
        
        // Get the 7 scale notes
        var indexFromKeyNote = notes.indexOf(key)!
        for i in 0..<notesInScale.count {
            notesInScale[i] = notes[indexFromKeyNote % notes.count]
            indexFromKeyNote += scale[i]
        }
        
        // Replace all notes that are not whithin the scale notes
        for i in 0..<resultScale.count {
            for j in 0..<resultScale[i].count {
                if (!notesInScale.contains(resultScale[i][j])) {
                    resultScale[i][j] = "-"
                }
            }
        }
        
        fretboardView.rootNote = key
        fretboardView.notes = resultScale
    }
}

