# Design Overview

Tensity is implemented in Swift and uses the SwiftUI framework. It follows a standard [model–view–viewmodel](https://en.wikipedia.org/wiki/Model-view-viewmodel) architecture, except that the model and view model have been collapsed into one. The model sits on top of a data access layer.

The guitar string specifications are stored in a read-only [JSON file](Tensity/Resources/StringData.json) that's bundled with the app. [StringData](Tensity/Model/StringData.swift) is the root object responsible for loading this file and providing the data to the rest of the app.

[UserData](Tensity/Model/UserData.swift) handles loading and saving the user's settings to UserDefaults.

[Guitar](Tensity/Model/Guitar.swift) is the main entry point into the model. It maintains an array of [TunedString](Tensity/Model/TunedString.swift) objects corresponding to each string on the instrument.

The [GuitarTraits](Tensity/Model/GuitarTraits.swift) protocol provides the interface for defining instrument types. There is an implementation of the protocol for each type supported by the app (i.e., electric, acoustic, and bass). 

[ContentView](Tensity/View/ContentView.swift) (as you might guess) renders the main screen for the app.

# Common Tasks

Instructions for some common updates to the app.

## Add a new string choice to an existing string type

The string choices are entirely data-driven. You only need to update StringData.json; no code changes are required. The order of the strings in the file doesn't matter, so you can add it anywhere in the existing array. See [StringChoice](Tensity/Model/StringChoices.swift) for details about each field. Make sure you run the automated tests after updating the JSON file. They perform extensive validation of the data file.

## Add a new string type

The string types are entirely data-driven. You only need to update StringData.json; no code changes are required. The order of the types in the file doesn't matter, so you can add it anywhere in the existing array. See [StringType](Tensity/Model/StringData.swift) for details about each field. Make sure you run the automated tests after updating the JSON file. They perform extensive validation of the data file.

## Add a new string count to an existing instrument type

Update validStringCounts in [GuitarTraits](Tensity/Model/GuitarTraits.swift) to add the new string count. Then update all the instance methods in GuitarTraits to return appropriate values for the new count.

## Add a new instrument type

Add a case for the new type to [GuitarType](Tensity/Model/GuitarTraits.swift) and implement the GuitarTraits protocol. You also must add at least one new string type for use by the new instrument type.
