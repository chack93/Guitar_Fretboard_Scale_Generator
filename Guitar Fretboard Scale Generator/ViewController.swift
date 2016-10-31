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
    @IBOutlet weak var intervalNotation: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create A major scale on startup
        self.buildScale();
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func changeKey(_ sender: NSPopUpButton) {
        self.buildScale()
    }
    
    @IBAction func changeScale(_ sender: NSPopUpButton) {
        self.buildScale()
    }
    
    @IBAction func changeIntervalNotation(_ sender: NSPopUpButton) {
        self.buildScale()
    }
    
    func buildScale() {
        let selectedKey = self.keySelection.titleOfSelectedItem!
        let selectedScaleIndex = self.scaleSelection.indexOfSelectedItem
        let majorScale = [2, 2, 1, 2, 2, 2, 1]
        var selectedScale = [Int](repeating: 0, count: majorScale.count)
        
        for i in 0 ..< majorScale.count {
            let shift = (i + selectedScaleIndex) % majorScale.count
            selectedScale[i] = majorScale[shift]
        }
        
        let notation = self.intervalNotation.titleOfSelectedItem!
        self.createScaleWithKey(selectedKey.capitalized, scale: selectedScale, notation: notation)
    }
    
    func createScaleWithKey(_ key: String, scale: [Int], notation: String) {
        let frets = fretboardView.frets
        let notes = ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"]
        var notesInScale = [String](repeating: "-", count: 7)
        var resultScale = Array(repeating: [String](repeating: "-", count: frets), count: 6)
        var lookupTable = [String: String]()
        var _key = key
        
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
            let firstNoteIndex = notes.index(of: firstNote)!
            
            for j in 0..<resultScale[i].count {
                let indexOfNote = (firstNoteIndex + j) % notes.count
                resultScale[i][j] = notes[indexOfNote]
            }
        }
        
        // Get the 7 scale notes
        var indexFromKeyNote = notes.index(of: key)!
        for i in 0..<notesInScale.count {
            notesInScale[i] = notes[indexFromKeyNote % notes.count]
            indexFromKeyNote += scale[i]
        }
        
        // Fill lookuptable if spezified
        switch notation {
        case "Notes":
            break
        case "Interval":
            let keyIndex = notesInScale.index(of: key)
            for i in 0..<notesInScale.count {
                let idx = (keyIndex! + i) % notesInScale.count // 7 Notes in a scale
                lookupTable[notesInScale[idx]] = String(i + 1)
            }
            _key = "1"
            break
        case "Root Note & Interval":
            let keyIndex = notesInScale.index(of: key)
            for i in 0..<notesInScale.count {
                let idx = (keyIndex! + i) % notesInScale.count // 7 Notes in a scale
                if (notesInScale[idx] != key) { // Jump key note
                    lookupTable[notesInScale[idx]] = String(i + 1)
                }
            }
            break
        default:
            break
        }
        
        // Replace all notes that are not whithin the scale notes
        let lookupTableFilled = lookupTable.count > 0
        for i in 0..<resultScale.count {
            for j in 0..<resultScale[i].count {
                if (!notesInScale.contains(resultScale[i][j])) {
                    resultScale[i][j] = "-"
                } else if (lookupTableFilled) {
                    if let replace = lookupTable[resultScale[i][j]] {
                        resultScale[i][j] = replace
                    }
                }
            }
        }
        
        fretboardView.rootNote = _key
        fretboardView.notes = resultScale
    }
}

