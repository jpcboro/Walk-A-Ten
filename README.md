# Walk-A-Ten iOS app
iOS app that detects your location, zooms in to your location on the map and shows an alert if you're moving more than 10 meters

<img width="286" height="838" src="https://i.imgur.com/pr9FA1X.png" alt="Walk-A-Ten app screenshot">


**How to Run:**
Clone the repo and then run on a simulator or a device, if using a simulator you can either use City Run, or change locations that is more than 10 meters from starting point in simulator's Features > Location

**Implementation decisions:**
	* I don’t have much architecture knowledge on Swift so I have a single ViewController for a lot of the code esp for getting location permissions, detecting user location, showing user on the map, showing alerts,  etc 

**Architectural considerations:**
	* Added a UserLocationService for mainly checking if the user moved more than 10 meters, for calculating distance and to be used for mocking and testing

**Areas of focus, copied code, etc:**
	* I tried to focus too much on implementing the correct unit tests. This took much of my time since I’m not familiar with removing the CLLocationManager dependency from the ViewController, and instead referenced this article to implement location mocking and unit testing - [Improving code testability with Swift protocols | by Juanpe Catalán | Medium](https://medium.com/@JuanpeCatalan/solving-dependencies-in-swift-9ee6ad4a8941) . My Swift knowledge is lacking, so I copied a lot of the code so that I can implement unit testing and I learned a lot!
	* I wanted a toast like alert (because normal alert dialogs obstruct the view) for the map to show up after moving > 10 meters. I got the idea of the code from this stack overflow question: [ios - How to create a toast message in Swift? - Stack Overflow](https://stackoverflow.com/questions/31540375/how-to-create-a-toast-message-in-swift)

**How long you worked on the app?**
		* Worked on the app for around 20 hours
       
* TODO: refactoring, cleanup, add new features like showing total of meters traveled, pedometer, local notifications, routes, etc