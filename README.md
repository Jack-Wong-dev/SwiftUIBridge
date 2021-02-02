# SwiftUIBridge
Sample Project to test out SwiftUI Views in a UIKit hosted environment.

## Lessons learned ##

* Use UIHostingController is required to bring SwiftUI views to UIKit
* To extract it as an UIView, use the view property of the UIHostingController.
* Passing data via dependency injection works when initializing new views.
* Sending data from SwiftUI view back to the UIKit controls requires the use of callback methods.
* Cleanest way of passing and retreiving data from UIKit controls to SwiftUI views is using Combine's Observable object.
