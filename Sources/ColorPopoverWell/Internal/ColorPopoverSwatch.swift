//
//  ColorPopoverSwatch.swift
//  ColorPopoverWellDemo
//
//  Created by Karl Kraft on 2/1/14.
//  Copyright 2014-2022 Karl Kraft. All rights reserved.
//

import Cocoa

class ColorPopoverSwatch: NSView {

  @IBInspectable var color: NSColor = .clear
  var tracking: Bool = false
  var controller: NSViewController?

  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect);
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func draw(_ dirtyRect: NSRect) {
    color.set()
    color.drawSwatch(in: bounds)

    NSColor.init(calibratedWhite: 0.0, alpha: 0.1).set()
    bounds.frame(withWidth: 1.0, using: .plusDarker)

    if (tracking) {
      if #available(macOS 10.14, *) {
        NSColor.controlAccentColor.set()
      } else {
        NSColor.highlightColor.set()
      }
      bounds.frame(withWidth: 2.0, using: .sourceOver)
    }
  }

  override func mouseDown(with startEvent: NSEvent) {
    tracking = true
    needsDisplay = true

    var loopEvent: NSEvent? = startEvent
    repeat {
      loopEvent = window?.nextEvent(matching: [.leftMouseDragged, .leftMouseUp],
          until: .distantFuture,
          inMode: .default,
          dequeue: true)
      if (loopEvent != nil) {
        let currentPoint = convert(loopEvent!.locationInWindow, from: nil)
        if NSMouseInRect(currentPoint, bounds, isFlipped) {
          if (!tracking) {
            tracking = true
            needsDisplay = true
          }
        } else if (tracking) {
          tracking = false
          needsDisplay = true
        }
      }
    } while (loopEvent != nil && loopEvent!.type != .leftMouseUp)

    if (tracking) {
      let well = controller?.representedObject as! ColorPopoverWell
      well.selectedColor(color)
    }
    tracking = false
    needsDisplay = true
  }

}
