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
    private var nutWidth:CGFloat = 0.0
    private var fretWidth:CGFloat = 0.0
    private var strokeWidth:CGFloat = 0.0
    private var fretboardRect:CGRect = CGRect()
    
    /// Root note will be drawn red
    var rootNote = "A"
    
    enum FretPositionMarkers {
        case dots
        case digits
        case romanDigits
        case none
    }
    
    /// Signs to draw for 3, 5, 7, 9, 12 & 15 position
    /// Will be set to digits if not defined
    var fretPositionMarker:FretPositionMarkers = .digits
    
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
        let fretPositionMarkerHeight = viewSize.height * 0.1
        
        // Nut
        self.nutWidth = viewSize.width * 0.02
        let nutRect = NSRect(x: 0, y: fretPositionMarkerHeight, width: nutWidth, height: viewSize.height - fretPositionMarkerHeight)
        let nutPath = NSBezierPath(roundedRect: nutRect, xRadius: nutWidth/2, yRadius: nutWidth/2)
        
        // Frets
        self.fretWidth = viewSize.width * 0.012
        let fretRect = NSRect(x: 0, y: fretPositionMarkerHeight, width: fretWidth, height: viewSize.height - fretPositionMarkerHeight)
        
        // Fretboard
        let fbLeftPadding:CGFloat = nutWidth / 2 // Place left border in center of the nut
        self.fretboardRect = CGRect(x: 
            fbLeftPadding, 
            y: fretPositionMarkerHeight, 
            width: viewSize.width - fbLeftPadding, 
            height: viewSize.height - fretPositionMarkerHeight).insetBy(dx: self.strokeWidth, 
            dy: self.strokeWidth)
        
        // Paint fret position marker rect
        let fretPositionMarkerRect = CGRect(x: 0, y: 0, width: viewSize.width, height: fretPositionMarkerHeight)
        let fretPosPath = NSBezierPath(roundedRect: fretPositionMarkerRect, xRadius: 5.0, yRadius: 5.0)
        NSColor.black.set()
        fretPosPath.fill()
        
        // create fret position markers
        self.createMarkers(markerRect: fretPositionMarkerRect, selectedMarkers: self.fretPositionMarker)
        
        // Paint fretboard
        let fretboardPath = NSBezierPath(rect: self.fretboardRect)
        fretboardPath.lineWidth = strokeWidth
        NSColor.black.set()
        fretboardPath.stroke()
        fretboardColor.set()
        fretboardPath.fill()
        
        // Paint nut
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
    
    func createMarkers(markerRect: CGRect, selectedMarkers: FretPositionMarkers) {
        // create rect's for each position
        
        let markerWidth = markerRect.height * 0.8
        let bottomPadding = (markerRect.height - markerWidth) / 2
        let x = markerRect.width / CGFloat(self.frets)
        let posRightPadding = markerWidth + (x - markerWidth - self.fretWidth) / 2
        
        let pos1 = CGRect.init(x: x * 3 - posRightPadding,
                               y: bottomPadding,
                               width: markerWidth,
                               height: markerWidth)
        let pos2 = CGRect.init(x: x * 5 - posRightPadding,
                               y: bottomPadding,
                               width: markerWidth,
                               height: markerWidth)
        let pos3 = CGRect.init(x: x * 7 - posRightPadding,
                               y: bottomPadding,
                               width: markerWidth,
                               height: markerWidth)
        let pos4 = CGRect.init(x: x * 9 - posRightPadding,
                               y: bottomPadding,
                               width: markerWidth,
                               height: markerWidth)
        let pos5 = CGRect.init(x: x * 12 - posRightPadding,
                               y: bottomPadding,
                               width: markerWidth,
                               height: markerWidth)
        let pos6 = CGRect.init(x: x * 15 - posRightPadding,
                               y: bottomPadding,
                               width: markerWidth,
                               height: markerWidth)
        
        NSColor.white.set()
        
        let font = NSFont.boldSystemFont(ofSize: markerRect.height * 0.6)
        let color = NSColor.white
        let style = NSMutableParagraphStyle.init()
        style.alignment = NSTextAlignment.center
        let attributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color,
            NSStrokeWidthAttributeName: 0.0,
            NSParagraphStyleAttributeName: style
            ] as [String : Any]
        
        // create path according to selected marker
        switch selectedMarkers {
        case .dots:
            NSBezierPath.init(ovalIn: pos1).fill()
            NSBezierPath.init(ovalIn: pos2).fill()
            NSBezierPath.init(ovalIn: pos3).fill()
            NSBezierPath.init(ovalIn: pos4).fill()
            NSBezierPath.init(ovalIn: pos5).fill()
            NSBezierPath.init(ovalIn: pos6).fill()
        case .digits:
            "3".draw(in: pos1, withAttributes: attributes)
            "5".draw(in: pos2, withAttributes: attributes)
            "7".draw(in: pos3, withAttributes: attributes)
            "9".draw(in: pos4, withAttributes: attributes)
            "12".draw(in: pos5, withAttributes: attributes)
            "15".draw(in: pos6, withAttributes: attributes)
        case .romanDigits:
            "III".draw(in: pos1, withAttributes: attributes)
            "V".draw(in: pos2, withAttributes: attributes)
            "VII".draw(in: pos3, withAttributes: attributes)
            "IX".draw(in: pos4, withAttributes: attributes)
            "XII".draw(in: pos5, withAttributes: attributes)
            "XV".draw(in: pos6, withAttributes: attributes)
        case .none:
            return
        }
    }
    
    func drawNotes() {
        let fbWidth = self.bounds.width
        let fbHeight = self.fretboardRect.height
        
        let fretDistance = fbWidth / CGFloat(self.frets)
        var dotDiameter = (fretDistance - self.fretWidth) * 0.8
        if ((dotDiameter * (6 / 0.8)) > fbHeight) {
            dotDiameter = fbHeight / (6 / 0.8) // Limit dot size
        }
        
        let bottomPadding = fretboardRect.origin.y
        let dotMaxHeight = fbHeight / 6
        let dotPaddingY = (dotMaxHeight - dotDiameter) / 2 + bottomPadding // Space between dots
        let dotPaddingX = fretDistance - dotDiameter // Position dot on edge of a fret
        
        for i in 0..<self.notes.count {
            for j in 0..<self.notes[i].count {
                // Jump over empty notes
                if (notes[i][j] == "-" || notes[i][j] == "") {
                    continue
                }
                
                let x = fretDistance * CGFloat(j) + dotPaddingX
                let y = (dotMaxHeight) * CGFloat(i) + dotPaddingY
                
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
        let font = NSFont.systemFont(ofSize: note.size.height / 2)
        let color = note.fontColor
        let shadow = NSShadow.init()
        shadow.shadowOffset = CGSize.init(width: 1.0, height: -1.0)
        shadow.shadowColor = NSColor.gray
        shadow.shadowBlurRadius = 1.0
        let style = NSMutableParagraphStyle.init()
        style.alignment = NSTextAlignment.center
        
        let charX = note.size.origin.x + note.size.width / 4
        let charY = note.size.origin.y + note.size.height / 4
        let charPos = NSPoint(x: charX, y: charY)
        let attributes = [
                NSFontAttributeName: font,
                NSForegroundColorAttributeName: color,
                NSStrokeWidthAttributeName: 0.0,
                NSShadowAttributeName: shadow,
                NSParagraphStyleAttributeName: style
            ] as [String : Any]
        note.note.draw(at: charPos, withAttributes: attributes)
    }    
}
