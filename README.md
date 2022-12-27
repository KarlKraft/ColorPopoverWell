# ColorPopoverWell
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License](https://img.shields.io/badge/Platform-macOS-green.svg)](https://opensource.org/licenses/macOS)
[![License](https://img.shields.io/badge/Language-Swift-orange.svg)](https://opensource.org/licenses/Apache-2.0)


ColorPopoverWell is a drop in replacement for NSColorWell that allows users to either select a color from the color panel in the same was as NSColorWell or from a series of convient swatches.

<figure>
<img src="README_images/screenshot.png" alt="Sample Board" width="100%"/>
<figcaption align = "center"><b>Screenshot with swatch view displayed</b></figcaption>
</figure>


To upgrade from the plain boring NSColorWell to ColorPopoverWell you only need to change the custom class in the Xcode Interface Builder and add the Swift package to your project.  How easy is that?

| Before      | After |
| ----------- | ----------- |
| <img src="README_images/custom_class_before.png" alt="Sample Board" width="100%"/>      | <img src="README_images/custom_class_after.png" alt="Sample Board" width="100%"/>       |




## Features
* Sublassed from NSColorWell, so can be used as a drop in replacement.
* Full cooperation with NSColorWell
* Drawn in vectors for full retina support and any size (66x23 is the "default" size)
* Drag and drop of color swatches with feedback on drops
* Gradient selection

