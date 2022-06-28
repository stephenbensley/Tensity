# Common Tasks

Instructions for some common updates to the app.

## Add a new string choice to an existing string type

The string choices are entirely data-driven. You only need to update StringData.json; no code
changes are required. The order of the strings in the file doesn't matter, so you can add it
anywhere in the existing array. See ``StringChoice`` for details about each field. Make sure
you run the automated tests after updating the JSON file. They perform extensive validation of the
data file.

## Add a new string type

The string types are entirely data-driven. You only need to update StringData.json; no code
changes are required. The order of the types in the file doesn't matter, so you can add it
anywhere in the existing array. See ``StringType`` for details about each field. Make sure you run
the automated tests after updating the JSON file. They perform extensive validation of the data
file.

## Add a new string count to an existing instrument type

Update ``GuitarTraits/validStringCounts`` to add the new string count. Then update all the
instance methods in ``GuitarTraits`` to return appropriate values for the new count.

## Add a new instrument type

Add a case for the new type to ``GuitarType`` and implement the ``GuitarTraits`` protocol. You also
must add at least one new string type for use by the new instrument type.
