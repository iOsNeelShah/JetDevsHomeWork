
## Description

The JetDevsHomeWork project is designed to handle user authentication through a  **Login API**. When the user logs in with their email and password, the app makes a POST request to the API. Upon success, the app saves **user information locally**, then navigates to the user's profile page. In case of failure, the app shows an error message.

The project uses  **RxSwift**  for managing asynchronous data streams and implements the  **MVVM architecture**  for separation of concerns.



## Features

-   **User Login**: Allows users to log in using their email and password.
-   **Successful API Call**: On a successful login, saves the user information locally and navigates to the profile page.
-   **Failed API Call**: If the API call fails, an error message is displayed to the user.
-   **Profile Page**: Displays the user's profile information after a successful login.


## Installation

To get this project up and running on your local machine, follow these steps:

### Prerequisites

Ensure you have the following installed:

-   **Xcode**  (latest version) with support for Swift 5.
-   **CocoaPods** managing dependencies.

### Clone the repository

```bash
git clone https://github.com/iOsNeelShah/JetDevsHomeWork.git
cd JetDevsHomeWork
```

### Install dependencies

Using  **CocoaPods**, run:

```bash
pod install
```


### Open the Xcode workspace

```bash
open JetDevsHomeWork.xcworkspace
```

### Running the application

You can run the application on a simulator or real device via Xcode's run button.

-   Select the target device and click the run button in Xcode to start the app.
