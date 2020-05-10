# Playgrounds

This repo is used as a single point for storing Playgrounds.

# How to use it

- First off make sure you have Swift version 5.1 (at minimum) installed and selected:
```
swift --version
> Apple Swift version 5.1.3 (swiftlang-1100.0.282.1 clang-1100.0.33.15)
> Target: x86_64-apple-darwin19.4.0
````

- Then genereta `.xcodeproj` file using the following command:
```
swift package generate-xcodeproj
```

- Once you've generated the `.xcodeproj`  **open the workspace** (`Playgrounds.xcworkspace`).

- Once the workspace is open make sure to build the Target `Playgrounds-Packages` so all the packages are compiled and ready to be used.

- All Playgrounds should be listed/added to the workspace.

# Adding dependencies

- Open `Package.swift`

- On `dependencies: []`, add your dependency.

- On the `Playgrounds` target, add the library names from your dependencies.

# FAQ

- If auto complete is not working on the playground, make sure you compile `Playground-Packages` for MacOS and close/re-open the workspace.
