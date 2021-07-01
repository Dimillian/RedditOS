# RedditOS
A SwiftUI Reddit client for macOS

![Image](Images/image1.png?)

## About

This project is about two things:
1. Building a good Reddit client. 
2. Building a good macOS application using mostly SwiftUI.

You'll need the latest version of Xcode 12 and macOS Big Sur to build it and enjoyt it. 
You can also download a pre built version in the release section if you don't want to build it youself. 

I'm planning to drop Big Sur in the near future to focus execlusively on SwiftUI 3 + macOS Monterey. 
SwiftUI 3 add a ton of features, polish and performance improvements that this application can't live without.

## Dev environment

If you want to login with your Reddit account building the project from the source you'll need to create a file `secrets.plist` in `Packages/Backend/Sources/Backend/Resources` with your Reddit app id as `client_id` key/value. Create an reddit app [here](https://www.reddit.com/prefs/apps) and use `redditos://auth` as redirect url.

