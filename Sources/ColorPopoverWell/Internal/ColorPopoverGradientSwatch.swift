//
//  ColorPopoverGradientSwatch.swift
//  ColorPopoverWellDemo
//
//  Created by Karl Kraft on 2/1/14.
//  Copyright 2014-2022 Karl Kraft. All rights reserved.
//

import Cocoa

internal class ColorPopoverGradientSwatch: NSView {

  var controller: NSViewController?

  @IBInspectable var leftColor: NSColor = .clear

  @IBInspectable var rightColor: NSColor = .clear

  var gradient: NSGradient?

  var tracking: Bool = false
  var trackOffset = 0.0

  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect);
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func draw(_ dirtyRect: NSRect) {

    gradient = NSGradient.init(starting: leftColor, ending: rightColor)

    gradient?.draw(in: bounds, angle: 0.0)

    NSColor.lightGray.set()
    bounds.frame(withWidth: 0.5, using: .sourceOver)

    if (tracking) {
      if #available(macOS 10.14, *) {
        NSColor.controlAccentColor.set()
      } else {
        NSColor.highlightColor.set()
      }
      let lineRect = NSMakeRect(trackOffset - 1.0, bounds.origin.y, 2.0, bounds.size.height)
      lineRect.frame(withWidth: 2.0, using: .sourceOver)
    }
  }

  override func mouseDown(with startEvent: NSEvent) {

    var trackedColor = NSColor.clear
    var loopEvent: NSEvent? = startEvent
    var currentPoint = convert(loopEvent!.locationInWindow, from: nil)
    var delta = currentPoint.x - bounds.origin.x;
    delta = delta / bounds.size.width;
    trackOffset = currentPoint.x
    tracking = true;
    needsDisplay = true

    repeat {
      loopEvent = window?.nextEvent(matching: [.leftMouseDragged, .leftMouseUp], until: .distantFuture, inMode: .default, dequeue: true)
      if (loopEvent != nil) {
        currentPoint = convert(loopEvent!.locationInWindow, from: nil)
        delta = currentPoint.x - bounds.origin.x;
        delta = delta / bounds.size.width;
        needsDisplay = true
        trackedColor = gradient!.interpolatedColor(atLocation: delta)
        trackOffset = currentPoint.x
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
      well.selectedColor(trackedColor)
    }
    tracking = false
    needsDisplay = true
  }
}

