# Tasktracker

the tasktracker is a simple application for tracking tasks with some basic operations : <br/>
<ul>
<li>User registeration : A user needs to register in order to create tasks in the system and be assigned a particular task. </li>
<li> Once registered , the user needs to login with the email he /she provided during registeration.</li>
<li> Once logged in, the user can create new tasks, create new users, assign task to himself or to other users.</li>
<li>the welcome page after login is a dashboard, which gives user a brief insight into the status such as how many tasks have been assigned to him. how many have been lodged in the system, how many users are there in the system. A user can also open a new task from dashboard to itself.</li>
<li> once a task is assigned, it can be marked as complete after entering the time taken to complete this task. Note that time has to be entered in minutes and the minutes needs to be in an increment of 15 minutes.</li>
<li> if a user adds invalid time then the app will throw an error stating that the time should be in increments of 15 minutes.</li>
<li> if a user tries to access a URL from address bar for which he/she is not permitted or a non logged in user tries to access login area, the app will redirect him/her back to the login page. </li>
<li>In order to logout, a logout button has been provided to the user. A logout can occur in the following scenarios :  <br />
      <ul>
 <li>
  if a user presses the logout link on the top right side</li>
 <li>if a user closes his/her browser without logging out manually</li>
            </ul>
      </li>
</ul>
