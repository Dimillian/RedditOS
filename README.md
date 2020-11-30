# RedditOS
A SwiftUI Reddit client for macOS

You'll need Xcode 12 and macOS Big Sur 12 to build & run the app. 
This is quite bleeding edge, the performances are not quite there yet as SwiftUI higher order components on macOS (like `List` and `NavigationView`) are not really very smooth yet. I hope it'll improve during Big Sur update cycle and I exept a big boost with SwiftUI 3 next summer. (One can hope)

But I'll continue to work on this application, add features, optimize it and eventually release it on the Mac App Store.
![Image](Images/image1.png?)

If you want to login with your Reddit account building the project from the source you'll need to create a file `secrets.plist` in `Packages/Backend/Sources/Backend/Resources` with your Reddit app secret as `client_id` key/value.

I'll periodically release pre built version of the app in the repository. 

The app is still early and SwiftUI on macOS is not that fast (yet) but I'm planning to release it on the Mac App Store with the release of Big Sur. 
