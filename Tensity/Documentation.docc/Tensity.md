# ``Tensity``

Tensity is an iOS app that calculates the string tension for a guitar.

## Overview

Tensity is implemented in Swift and uses the SwiftUI framework. It follows a standard
[model–view–viewmodel](https://en.wikipedia.org/wiki/Model-view-viewmodel) architecture, except that
the model and view model have been collapsed into one. The model sits on top of a data access layer.

The guitar string specifications are stored in a read-only JSON file that's bundled with the app.
``StringData`` is the root object responsible for loading this file and providing the data to the
rest of the app.

``UserData`` handles loading and saving the user's settings to UserDefaults.

``Guitar`` is the main entry point into the model. It maintains an array of ``TunedString`` objects
corresponding to each string on the instrument.

The ``GuitarTraits`` protocol provides the interface for defining instrument types. There is an
implementation of the protocol for each type supported by the app (i.e., electric, acoustic, and
bass). 

``ContentView`` (as you might guess) renders the main screen for the app.

## Topics

### Getting Started

- <doc:Common-Tasks>

### Data Access

- ``StringData``
- ``GuitarType``
- ``StringChoice``
- ``StringType``
- ``UserData``

### View Model

- ``Guitar``
- ``TunedString``
- ``StringChoices``
- ``PitchClass``
- ``Pitch``
- ``ObservedArray``

### Instrument Definition

- ``GuitarTraits``
- ``ElectricGuitarTraits``
- ``AcousticGuitarTraits``
- ``BassGuitarTraits``

### View

- ``TensityApp``
- ``ContentView``
- ``NavPicker``
- ``ScaleLengthView``
- ``StringTensionTable``
- ``StringTensionColumn``
- ``StringTensionRow``
- ``TotalTensionText``
- ``AboutView``
- ``PdfReader``
- ``PdfView``
- ``ShareSheetView``

### View Previews

- ``AboutView_Previews``
- ``ContentView_Previews``
- ``NavPicker_Previews``
- ``PdfReader_Previews``
- ``ScaleLengthView_Previews``
- ``StringTensionTable_Previews``
