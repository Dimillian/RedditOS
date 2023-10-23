# RedditOS
A SwiftUI Reddit client for macOS

![Image](Images/image1.png?)

## About

This project is about two things:
1. Building a good Reddit client. 
2. Building a good macOS application using mostly SwiftUI.

You'll need the latest version of Xcode 12 and macOS Big Sur to build and enjoy it. 
You can also download a pre-built version in the release section if you don't want to build it yourself. 

I'm planning to drop Big Sur in the near future to focus exclusively on SwiftUI 3 + macOS Monterey. 
SwiftUI 3 adds many features, polish, and performance improvements that this application can't live without.

## Dev environment

If you want to log in with your Reddit account to build the project from the source, you'll need to create a file `secrets.plist` in `Packages/Backend/Sources/Backend/Resources` with your Reddit app id as `client_id` key/value. Create a Reddit app [here](https://www.reddit.com/prefs/apps) and use `redditos://auth` as the redirect URL.

