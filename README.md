![Bitmaker](https://github.com/johncarlolopez/bitmaker-reference/blob/master/bitmakerlogo.svg)
# 04 - CRM Web
### Thursday, Jan 4th

### Continued from [CRM assignment 1](https://github.com/johncarlolopez/bitmaker-d13a2-crm) and [CRM assignment 2](https://github.com/johncarlolopez/bitmaker-d15a2-crm)

Getting Started
Make a new directory and git repo for this assignment.
Move or copy the file containing your Contact class from the previous CRM assignments into this directory.
Using your command line CRM interface, make sure that there are at least a few contacts in your database and then copy the .sqlite3 database file into this new project directory, to make sure we have some data to work with.
Create a new file called crm.rb. This will be where you write the code for your Sinatra server.
In crm.rb, require both the sinatra gem and the file containing your Contact class.
require_relative 'contact'
require 'sinatra'
Create a sub-directory (at the same level as crm.rb and the file containing your Contact class) called views to put your ERB files in later on.
Guide
Home page
Let's start by creating a landing page for our app:

Create a new ERB file in views called index.erb.
 In crm.rb define a "root" route (for get requests to the URL localhost:4567/) that renders this new view.
 Add a heading to index.erb (such as "Welcome to My CRM", or whatever you like).
Start your server and go to localhost:4567 in your web browser to see if your heading shows up.
Don't forget to commit once that much is working.
An annoying chore
Before we take the next step and start displaying the data from our database of contacts, we need to add this bit of code to the bottom of our crm.rb file:

after do
  ActiveRecord::Base.connection.close
end
Here's why: MiniRecord (which we're using to connect our Contact class to the database) has a bad habit of opening connections to the database without closing them. After this happens five times (five being the maximum number of connections that SQLite allows to be open at once), you'll get a mysterious Timeout error if you don't have this bit of code telling Sinatra to close its database connections after each request it handles.

Contacts page
Our next goal is to add a second page to our CRM that displays all of our contacts:

Add a new route to your app that handles get requests to localhost:4567/contacts.
Make a new view called contacts.erb and have your new route render this as its response.
In this new route, create an instance variable containing a collection of all the contacts in your database.
In contacts.erb use this instance variable to iterate through the collection and display the first name, last name, email, and notes for each contact. What semantic HTML elements make sense to use when displaying this data?
Restart your server and go to this page to see if your contacts appear.
On the index.erb landing page we made, add a link to the contacts page.
On the contacts page, also add a link back to the landing page.
Add an "about" page
For further practice, add a new route and view for an "about" page, where you can display a message about who made this app (you!).

Done (for now)!
That's all we're able to do with our current skills, but we're going to continue to implement the rest of the CRM in the upcoming assignments.
