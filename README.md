# Monster Ranker App

For turn in at the sHCI exam 2024-01-29.

Authors:
- Anders Malta Jakobsen, 20230644, amja23@student.aau.dk
- Daniel Runge Petersen, 20205006, dpet20@student.aau.dk

## Materials
Outside of the sourcecode, the description and motivation for the application as presented here in the README is available as a PDF, as well as a short screen-capture of the app in use can be found in the `/exam` folder.  
The application can be run either by downloading and running the release, or cloning this repository and running the application in Android Studio or IntelliJ.

# Monster Energy App description
The required text for the exam turn in.

## Motivation
The inspiration for the app is a discussion of the which energy drink is the best within our project group. What better way than to rank them based on several people's opinions?

We do realise that the purpose of doing it as a mobile app is entirely overkill, and serves no practical purpose outside of as a project for the exam. Based on this we iterated on other features we could create within the confines of 5 ECTS and the learning goals.

### Use case
We developed the mobile app with two use cases in mind. Letting people vote for Monster Energy drinks, and letting users keep track of the total standing of the drinks.

We wanted to gamify the application a little, and therefore we chose to make the voting mechanism a versus battle; two randomly chosen energy drink, which the user then chooses one of as the winner.

## Description
This app is a Monster Energy drink ranker. The application is developed using Flutter and the Android SDK v. 34.

We opted to use Firebase to store the app data. The reason is that it's a simple way to create a working prototype without worrying much about the architectural design of the underlying system necessary for an application like this.

The primary feature is a global leaderboard with all the Monster Energy drinks ranked top to bottom depending on the votes of the application users. To allow the users to vote we use the second primary feature, which is a scoring mechanism in the style of a "versus battle" between two energy drinks.

Then we chose to extend the application with the option of having local leaderboards. We imagined that there could be a single, global leaderboard, much like a global leaderboard in sports, for example tennis players, and then local leaderboards that individuals could create and join. This would allow for the creation of an AAU wide leaderboard, for example.

## Future work
There are a number of features that we would have wanted to develop, but which we could not due to the highly constrained scope of this project.

The three most important features which we wanted to develop, but didn't get actually implement are:

1. Using the phone's inertia sensors to allow a user to swish the phone to the left or the right to vote for their favourite Monster. This would works somewhat similarly to swiping left or right in apps like Tinder, but rather than yay/nay, it would be a decision for a winner. For discoverability a small tutorial or permanent, slowly blinking images of a phone being swiped would make sense. (IMU sensor, usability)
2. Using the phone's camera to allow users to take pictures of monsters they drink, to add votes to their favourite Monsters. This would require further elaborating the scoring mechanism to be based not just on the battle system, but also based on popularity as a measurement. (Camera)
3. Create the complete user interface for starting and joining local "multiplayer" leaderboards. Currently, the local leaderboard only tracks your own votes, but combining this with new, local leagues would allow us to have a university wide rank of the most popular monsters. (internet++)

Aside from those three major features, several other features were considered. All of these have been prioritised very low for now. These are features of no real value in regards to Human-Computer Interaction of the app.

1. To fetch the data; images and information of the energy drinks from the monster website either by webscraping or by using an official API (if it exists)
2. Implement a full ELO system for the internal battling system. A popular drink winning against an unpopular drink should probably have very little say in the total rankings.
3. Location-based search for local leaderboards to join. This would be really cool, but would require at least the complete implementation of the local leaderboard feature. (GPS usage)
4. Similar, location-based price information. The app would be moving into a secondary purpose with this, but we're students; we're always trying to save some money.
