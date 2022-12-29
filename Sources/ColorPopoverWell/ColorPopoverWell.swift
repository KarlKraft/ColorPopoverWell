//
//  ColorPopoverWell.swift
//  ColorPopoverWell
//
//  Created by Karl Kraft on 2/1/14.
//  Copyright 2014-2022 Karl Kraft. Licensed under Apache License, Version 2.0
//

import Cocoa

public class ColorPopoverWell: NSColorWell {
  // 66 x 23
  var wheelRect: NSRect {
    get {
      return NSMakeRect(0.6969 * bounds.size.width, 0, 0.3030 * bounds.size.width, bounds.size.height)
    }
  }

  var colorRect: NSRect {
    get {
      return NSMakeRect(0, 0, 0.6969 * bounds.size.width, bounds.size.height)
    }
  }

  var acceptingDrag: Bool = false
  var showColorHover: Bool = false
  var showColorTrack: Bool = false
  var showWheelHover: Bool = false
  var showWheelTrack: Bool = false

  lazy var popover: NSPopover = {
    popover = NSPopover.init()

    popover.contentViewController = NSViewController.init(nibName: "ColorPopoverWell", bundle: .module)
    popover.behavior = .transient
    popover.contentViewController?.representedObject = self
    return popover
  }()

  public override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)
    postSetup()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    postSetup()
  }

  func postSetup() {

    let track = NSTrackingArea.init(rect: bounds,
        options: [.mouseEnteredAndExited, .mouseMoved, .activeInKeyWindow, .inVisibleRect],
        owner: self,
        userInfo: nil)
    addTrackingArea(track)
  }

  func updateTrack(with event: NSEvent) {
    let currentPoint = convert(event.locationInWindow, from: nil)
    if (NSMouseInRect(currentPoint, wheelRect, isFlipped)) {
      showColorHover = false
      showWheelHover = true
    } else if (NSMouseInRect(currentPoint, colorRect, isFlipped)) {
      showColorHover = true
      showWheelHover = false
    } else {
      showColorHover = false
      showWheelHover = false
    }
    needsDisplay = true
  }

  public override func mouseEntered(with event: NSEvent) {
    updateTrack(with: event)
  }

  public override func mouseMoved(with event: NSEvent) {
    updateTrack(with: event)
  }

  public override func mouseExited(with event: NSEvent) {
    updateTrack(with: event)
  }

  public override func deactivate() {
    super.deactivate()
    needsDisplay = true
  }

  func showColorPopop() {
    popover.show(relativeTo: colorRect, of: self, preferredEdge: .minY)
  }

  public override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
    acceptingDrag = true
    needsDisplay = true
    return super.draggingEntered(sender)
  }

  public override func draggingExited(_ sender: NSDraggingInfo?) {
    acceptingDrag = false
    needsDisplay = true
    return super.draggingExited(sender)
  }

  public override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
    acceptingDrag = false
    needsDisplay = true
    return super.prepareForDragOperation(sender)
  }

  public override func mouseDown(with startEvent: NSEvent) {
    let startPoint = convert(startEvent.locationInWindow, from: nil)

    if (NSPointInRect(startPoint, wheelRect)) {
      showWheelTrack = true
      needsDisplay = true;
    } else if (NSPointInRect(startPoint, colorRect)) {
      showColorTrack = true
      needsDisplay = true
    } else {
      return
    }

    var loopEvent: NSEvent? = startEvent

    repeat {
      loopEvent = window?.nextEvent(matching: [.leftMouseDragged, .leftMouseUp], until: .distantFuture, inMode: .default, dequeue: true)
      if (loopEvent != nil) {
        let currentPoint = convert(loopEvent!.locationInWindow, from: nil)
        if (abs(currentPoint.x - startPoint.x) > 3.0 || abs(currentPoint.y - startPoint.y) > 3.0) {
          needsDisplay = true
          NSColorPanel.dragColor(color, with: loopEvent!, from: self)
          break;
        } else {
          if (loopEvent?.type == .leftMouseUp) {
            if (NSMouseInRect(currentPoint, wheelRect, isFlipped)) {
              if (isActive) {
                deactivate()
              } else {
                activate(!(loopEvent!.modifierFlags.contains(.shift)))
              }
            } else if (NSMouseInRect(currentPoint, colorRect, isFlipped)) {
              showColorPopop()
            }
            needsDisplay = true
          }
        }
      }
    } while (loopEvent != nil && loopEvent!.type != .leftMouseUp)
    showWheelTrack = false
    showColorTrack = false
    needsDisplay = true
  }

  func selectedColor(_ newColor: NSColor?) {
    if (newColor != nil) {
      color = newColor!
      sendAction(action, to: target)
    }
    popover.performClose(nil)
  }

  public override func draw(_ dirtyRect: NSRect) {
    if #available(macOS 10.14, *) {
      PaintCode.drawPopoverWell(frame: bounds, accentColor: .controlAccentColor, color: color, showDropIndicator: acceptingDrag, showColorHover: showColorHover, showColorTrack: showColorTrack, showWheelHover: showWheelHover, showWheelTrack: showWheelTrack, showWheelActive: isActive)
    } else {
      PaintCode.drawPopoverWell(frame: bounds, accentColor: .highlightColor, color: color, showDropIndicator: acceptingDrag, showColorHover: showColorHover, showColorTrack: showColorTrack, showWheelHover: showWheelHover, showWheelTrack: showWheelTrack, showWheelActive: isActive)
    }
  }

}

