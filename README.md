# Apollon - UML Modeling Editor

A UML modeling editor application for iOS written in Swift and SwiftUI.

## Main Features
### Easy to use Editor
The user interface of Apollon iOS is simple to use. 
-   Select the diagram type you want to draw or choose to import a file.
-   Adding an element is as easy as choosing the desired element from the elements menu by clicking the `+` button at the bottom of the screen.
-   Drawing a connection between elements is done by selecting one element and dragging a path to another.
-   Edit the text of any element by selecting it and clicking the menu button. An easy-to-use menu will allow you to do so.
-   Elements can be moved and resized by holding the move or resize button on the selected element.
-   Supports dark and light appearances.
-   Diagrams are saved locally on your device.

<img src="/docs/Apollon-iOS-Demo.gif" alt="Apollon iOS features" width="300"/>

### Import and Export
Apollon iOS allows importing JSON files for diagrams created on [Apollon Standalone](https://apollon.ase.cit.tum.de) or from other users. Diagrams created and edited on the Apollon iOS application can also be exported to JSON, PNG, and PDF, allowing you to share and save your diagrams easily.

### UML Diagram Types
Currently, Apollon iOS supports creating multiple UML diagrams, with more types to be added.

The list of UML diagram types includes:
-   `Class Diagram`
-   `Object Diagram`
-   `Activity Diagram`
-   `Use Case Diagram`
-   `Component Diagram`

## Screenshots
| Diagrams | Editor | Select Element |
|    :---:    |    :---:    |    :---:    |
| <img src="/docs/images/Diagrams-Screenshot.png" width="300"/> | <img src="/docs/images/Editor-Screenshot.png" width="300"/> | <img src="/docs/images/SelectElement-Screenshot.png" width="300"/> |

| Edit Element | Export | Dark Mode |
|    :---:    |    :---:    |    :---:    |
| <img src="/docs/images/EditElement-Screenshot.png" width="300"/> | <img src="/docs/images/Share-Screenshot.png" width="300"/> | <img src="/docs/images/DarkMode-Screenshot.png" width="300"/> |

## Usage
### Download
You can install the app on your iPhone or iPad from the App Store:
- [Apollon - UML Modeling Editor](https://apps.apple.com/de/app/apollon-uml-modeling-editor/id6474762031?l=en-GB)

### Local
1. Clone the repository
```
git clone https://github.com/ls1intum/apollon-ios.git
```
2. Open the project in Xcode
3. Compile and run the application in your simulator

## Technical
The app was created as a native iOS implementation of the [Apollon Standalone](https://apollon.ase.cit.tum.de) web client. We employ the MVVM design pattern as the general architectural pattern. The main modeling functionality is imported from the [Apollon-iOS-Module](https://github.com/ls1intum/apollon-ios-module) SPM package and utilizes the `ApollonEdit` module to enable users to create, modify, and interact with UML diagrams. The previews on the home screen utilize the `ApollonView` module to allow users to see a preview of their diagram. Further, the diagrams are saved locally on the device using SwiftData, so no internet connection is needed.

## Contact
For issues or questions regarding the app, please contact [Support](mailto:ios-support.ase@xcit.tum.de).
