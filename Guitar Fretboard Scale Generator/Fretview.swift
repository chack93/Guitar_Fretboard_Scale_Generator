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
class Fretview: NSView {
    var noteDots = [NoteDot]() {
        didSet {
            self.needsDisplay = true
        }
    }
    
    /*
    element.color!.set()
    element.bezierPath!.fill()
    element.bezierPath!.stroke()
    */
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        drawFretboard()
        
        for dot in noteDots {
            drawNote(dot)
        }
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
        
        let frets = 16
        fretColor.set()
        let leftPadding = viewSize.width / CGFloat(frets)
        for nFret in 1...frets {
            let totalLeftPadding = leftPadding * CGFloat(nFret)
            let nFretRect = fretRect.offsetBy(dx: totalLeftPadding, dy: 0).insetBy(dx: 0, dy: paddingY/4)
            let fret = NSBezierPath(roundedRect: nFretRect, xRadius: fretWidth/2, yRadius: fretWidth/2)
            
            fret.fill()
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
