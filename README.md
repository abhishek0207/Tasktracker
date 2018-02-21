# Tasktracker

the tasktracker is a simple application for tracking tasks with some basic operations : <br/>
1.) User registeration : A user needs to register in order to create tasks in the system and be assigned a particular task. <br />
2.) Once registerd , the user needs to login with the email he /she provided during registeration.<br />
3.) Once logged in, the user can create new tasks, create new users, assign task to himself or to other users.<br />
4.) the welcome page after login is a dashboard, which gives user a brief insight into the status such as how many tasks have been assigned to him. how many have been lodged in the system, how many users are there in the system. A user can also open a new task from dashboard to itself.<br />
5.) once a task is assigned, it can be marked as complete after entering the time taken to complete this task. Note that time has to be entered in minutes and the minutes needs to be in an increment of 15 minutes. <br />
6.) if a user adds invalid time then the app will throw an error stating that the time should be in increments of 15 minutes. <br />
7.) if a user tries to access a URL from address bar for which he/she is not permitted or a non logged in user tries to access login area, the app will redirect him/her back to the login page. <br />
8.) In order to logout, a logout button has been provided to the user. A logout can occur in the following scenarios :  <br />
      <ul>
 <li>
  if a user presses the logout link on the top right side</li>
 <li>if a user closes his/her browser without logging out manually</li>

