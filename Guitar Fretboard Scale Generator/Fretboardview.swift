//
//  Fretview.swift
//  Guitar Fretboard Scale Generator
//
//  Created by Christian Hackl on 24.09.16.
//  Copyright © 2016 Christian Hackl. All rights reserved.
//

import Cocoa

struct NoteDot {
    var dotColor: NSColor
    var fontColor: NSColor
    var size: NSRect
    var note: NSString
    var bezierPath: NSBezierPath
    
    init (size: NSRect, note: NSString, isRootNote: Bool = false) {
        if isRootNote {
            self.dotColor = NSColor.init(calibratedRed: 237/255, green: 38/255, blue: 38/255, alpha: 1)
        } else {
            self.dotColor = NSColor.init(calibratedRed: 241/255, green: 217/255, blue: 132/255, alpha: 1)
        }
        self.fontColor = NSColor.blackColor()
        self.size = size
        self.note = note
        self.bezierPath = NSBezierPath(ovalInRect: size)
    }
}

@IBDesignable
class Fretboardview: NSView {
    /// Frets to be drawn
    let frets = 16
    
    /// Root note will be drawn red
    var rootNote = "A"
    
    /// The scale to be drawn  
    /// Format: [6 string to 1st (high e][note on 1 fret]
    /// Notes that are not whithin the cromatic scale won't be displayed.
    /// Use sharp instead of flat for half notes. Example: C#, D#, ...
    var notes = [[String]]() {
        didSet {
            self.needsDisplay = true
        }
    }
    
    private var noteDots = [NoteDot]()
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        drawFretboard()
        
        drawNotes()
    }
    
    func drawFretboard() {
        let fretboardColor = NSColor(calibratedRed: 174/255, green: 134/255, blue: 108/255, alpha: 1)
        let fretColor = NSColor(calibratedRed: 107/255, green: 117/255, blue: 138/255, alpha: 1)
        let viewSize = self.bounds
        
        let nutWidth = viewSize.width * 0.02
        let nutRect = NSRect(x: 0, y: 0, width: nutWidth, height: viewSize.height)
        let nut = NSBezierPath(roundedRect: nutRect, xRadius: nutWidth/2, yRadius: nutWidth/2)
        
        let fretWidth = viewSize.width * 0.012
        let fretRect = NSRect(x: 0, y: 0, width: fretWidth, height: viewSize.height)
        
        let paddingY = CGFloat(fretWidth)
        let fretboard = NSBezierPath(rect: viewSize.insetBy(dx: nutWidth/4, dy: paddingY).offsetBy(dx: nutWidth/8, dy: 0))
        
        NSColor.blackColor().set()
        fretboard.stroke()
        fretboardColor.set()
        fretboard.fill()
        
        fretColor.set()
        nut.fill()
        
        fretColor.set()
        let leftPadding = viewSize.width / CGFloat(self.frets)
        for nFret in 1...self.frets {
            let totalLeftPadding = leftPadding * CGFloat(nFret)
            let nFretRect = fretRect.offsetBy(dx: totalLeftPadding, dy: 0).insetBy(dx: 0, dy: paddingY/4)
            let fret = NSBezierPath(roundedRect: nFretRect, xRadius: fretWidth/2, yRadius: fretWidth/2)
            
            fret.fill()
        }
    }
    
    func drawNotes() {
        let paddingY = self.bounds.width * 0.012
        let fretDistance = self.bounds.width / CGFloat(self.frets)
        let dotHeight = CGFloat((self.bounds.height - paddingY) / 6)
        let allowedNotes = ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"]
        
        for i in 0..<self.notes.count {
            for j in 0..<self.notes[i].count {
                // Jump over empty notes
                if (!allowedNotes.contains(notes[i][j])) {
                    continue
                }
                let leftPadding = fretDistance * CGFloat(j)
                let dotRect = NSRect(x: leftPadding,
                                     y: dotHeight * CGFloat(i),
                                     width: dotHeight,
                                     height: dotHeight)
                let isRootNote = notes[i][j] == rootNote
                let dot = NoteDot.init(size: dotRect, note: notes[i][j], isRootNote: isRootNote)
                drawNote(dot)
            }
        }
    }
    
    func drawNote(note: NoteDot) {
        
        note.dotColor.set()
        note.bezierPath.fill()
        
        let charRect = note.size.insetBy(dx: note.size.width * 0.1, dy: note.size.height * 0.1)
        note.fontColor.set()
        note.note.drawInRect(charRect, withAttributes: nil)
    }
    
}
