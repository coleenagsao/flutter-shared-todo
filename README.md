### Student information

- **Name**: Coleen Therese A. Agsao
- **Student Number**: 2020-07885
- **Section**: CMSC 23 D5L
- **App Description**: The project is a Flutter mobile application composed of a sign in, sign-up and a shared todo list features with a user’s friends.

### Screenshots

![Login page](loginsc.png)
Exhibit A: Login Page

### Things you did in the code (logic, solutions)

- **Validators**. The e.code catched from the `firebase_user_api.dart` is passed to `auth_provider` until used in the `login.dart` and `signin.dart`. The return value of the signUp function from the mentioned files will be passed to a function `extractErrorMessage` which willl return the appropriate error message depending on the e.code returned.
- **Friends and Users Fetch**. A snapshots of the data collection got from the firebase collection `users` and `todos` are fetched. Then, this will be iterated using the stream builder.
- **Permissions on Add, Edit, and Delete**. 2 pages exist in the shared todo page. One of which is for the user's tasks, while the other one is for its friends. In the user's tasks page, the add button, edit, and delete button is visible, hence giving them the persmission to do such. With the friends, it is only the edit button that is clickable. The toggle status is also not changable in this page.

### Challenges faced when developing the app

- **Passing of the e.code until the UI**. It took me a while to figure out how to make the usual print errors to display in the actual UI, specifically below the specific field.
- **Displaying of User's Info in the Todo**. I had a difficulty in fetching the user's info based on the todo user id to make the user experience better. However, I just ended up using the userid instead.

### Test Cases

##### Happy paths - the expected outputs that your application produces

- When user signed up with a password less than 8 characters, it should display an error message that the password's requirements are the following.
- When user signs out, the context must be popped, and it must return the login page.
- When the user edits their friend's task, the text widget shall now display their user id and the timestamp of edit.

##### Unhappy paths - the expected errors/ways that a user can break your app

- When the user does not add any date in the selected dates part by incorrectly exiting the date/time picker. An error will be displayed in the terminal
