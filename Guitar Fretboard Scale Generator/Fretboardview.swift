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
        self.fontColor = NSColor.black
        self.size = size
        self.note = note
        self.bezierPath = NSBezierPath(ovalIn: size)
    }
}

@IBDesignable
class Fretboardview: NSView {
    /// Frets to be drawn
    let frets = 16
    private var nutWidth:CGFloat = 0.0;
    private var fretWidth:CGFloat = 0.0;
    private var strokeWidth:CGFloat = 0.0;
    
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
    
    fileprivate var noteDots = [NoteDot]()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        drawFretboard()
        
        drawNotes()
    }
    
    func drawFretboard() {
        self.strokeWidth = 1.0;
        let fretboardColor = NSColor(calibratedRed: 174/255, green: 134/255, blue: 108/255, alpha: 1)
        let fretColor = NSColor(calibratedRed: 107/255, green: 117/255, blue: 138/255, alpha: 1)
        let viewSize = self.bounds
        
        // Nut
        self.nutWidth = viewSize.width * 0.02
        let nutRect = NSRect(x: 0, y: 0, width: nutWidth, height: viewSize.height)
        let nutPath = NSBezierPath(roundedRect: nutRect, xRadius: nutWidth/2, yRadius: nutWidth/2)
        
        // Frets
        self.fretWidth = viewSize.width * 0.012
        let fretRect = NSRect(x: 0, y: 0, width: fretWidth, height: viewSize.height)
        
        // Fretboard
        let fbXPadding:CGFloat = nutWidth / 4 // Place left border in center of the nut
        let fretboardRect = viewSize.insetBy(dx: fbXPadding, dy: 0).offsetBy(dx: fbXPadding, dy: 0).insetBy(dx: self.strokeWidth, dy: strokeWidth)
        let fretboardPath = NSBezierPath(rect: fretboardRect)
        
        
        NSColor.black.set()
        fretboardPath.lineWidth = strokeWidth
        fretboardPath.stroke()
        fretboardColor.set()
        fretboardPath.fill()
        
        fretColor.set()
        nutPath.fill()
        
        let leftPadding = viewSize.width / CGFloat(self.frets)
        for nFret in 1...self.frets {
            let totalLeftPadding = leftPadding * CGFloat(nFret)
            let nFretRect = fretRect.offsetBy(dx: totalLeftPadding, dy: 0)
            let fret = NSBezierPath(roundedRect: nFretRect, xRadius: fretWidth/2, yRadius: fretWidth/2)
            
            fret.fill()
        }
    }
    
    func drawNotes() {
        let fbWidth = self.bounds.width
        let fbHeight = self.bounds.height
        
        let fretDistance = fbWidth / CGFloat(self.frets)
        var dotDiameter = (fretDistance - self.fretWidth) * 0.8
        if ((dotDiameter * (6 / 0.8)) > fbHeight) {
            dotDiameter = fbHeight / (6 / 0.8) // Limit dot size
        }
        
        let dotPosY = fbHeight / 6
        let dotPaddingY = (dotPosY - dotDiameter) / 2 // Space between dots
        let dotPaddingX = fretDistance - dotDiameter // Position dot on edge of a fret
        
        let allowedNotes = ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"]
        
        for i in 0..<self.notes.count {
            for j in 0..<self.notes[i].count {
                // Jump over empty notes
                if (!allowedNotes.contains(notes[i][j])) {
                    continue
                }
                
                let x = fretDistance * CGFloat(j) + dotPaddingX
                let y = (dotPosY) * CGFloat(i) + dotPaddingY
                
                let dotRect = NSRect(x: x,
                                     y: y,
                                     width: dotDiameter,
                                     height: dotDiameter)
                let isRootNote = notes[i][j] == rootNote
                let dot = NoteDot.init(size: dotRect, note: notes[i][j] as NSString, isRootNote: isRootNote)
                drawNote(dot)
            }
        }
    }
    
    func drawNote(_ note: NoteDot) {
        
        note.dotColor.set()
        note.bezierPath.fill()
        let charWidth = note.size.width / 2
        let charHeight = note.size.height / 2
        let font = NSFont.init(name: "Helvetica Neue", size: 13)
        let color = NSColor.darkGray
        let shadow = NSShadow.init()
        shadow.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        shadow.shadowColor = NSColor.black
        shadow.shadowBlurRadius = 1.0
        let style = NSMutableParagraphStyle.init()
        style.alignment = NSTextAlignment.center
        
        
        let charRect = note.size.insetBy(dx: charWidth / 2, dy: charHeight / 2)
        note.fontColor.set()
        note.note.draw(in: charRect, withAttributes: [
            "NSFontAttributeName": font,
            "NSForegroundColorAttributeName": color,
            "NSShadowAttributeName": shadow,
            "NSParagraphStyleAttributeName": style])
    }
    
}
