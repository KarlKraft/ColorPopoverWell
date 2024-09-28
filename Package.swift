// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  Package.swift
//  ColorPopoverWell
//
//  Created by Karl Kraft on 12/25/22
//  Copyright 2022-2023 Karl Kraft. Licensed under Apache License, Version 2.0
//

import PackageDescription

let package = Package(
  name: "ColorPopoverWell",
  platforms: [
    .macOS(.v10_13),
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "ColorPopoverWell",
      targets: ["ColorPopoverWell"]),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "ColorPopoverWell",
      dependencies: [],
      resources: [
        .process("Resources"),
      ]),
    .testTarget(
      name: "ColorPopoverWellTests",
      dependencies: ["ColorPopoverWell"]),
  ])
