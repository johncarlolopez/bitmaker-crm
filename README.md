![Bitmaker](https://github.com/johncarlolopez/bitmaker-reference/blob/master/bitmakerlogo.svg)
# 02 - CRM: Saving your Datas
### Friday, Dec 22nd

### Continued from [CRM assignment](https://github.com/johncarlolopez/bitmaker-d13a2-crm)

1. Moving to ActiveRecord
With our database now setup, we now need to modify our Contact class and get it working with a database.

Transforming the Contact class into an ActiveRecord Model
Next we're going to transform our Contact class into an ActiveRecord model by inheriting from ActiveRecord::Base.

As soon we inherit from this Base class, we'll have access to all the special ActiveRecord methods that allow us to interface with the database.

Open up contact.rb and do the following:

Delete all the reader and writer methods. ActiveRecord will automatically provide those methods for us without us having to define them.
Delete all the class variables (@@contacts, @@id). The database is going to take care of storing the contacts and assigning IDs to new contacts when we save them.
Delete all the methods except for the full_name method. ActiveRecord is going to provide us with all of the methods for interacting with the database in the next step.
Finally, the Contact class should inherit from ActiveRecord::Base.
After all those steps, your contact.rb file should now look like this:

require 'active_record'
require 'mini_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'crm.sqlite3')

class Contact < ActiveRecord::Base

  def full_name
    "#{ first_name } #{ last_name }"
  end

end
As soon as we inherit from ActiveRecord::Base, ActiveRecord will also start to consider this class to represent a single database table. That means that every time we create a new Contact record, it will automatically be inserted into the contacts database table.

However, it still doesn't know which columns belong to this contacts table, so we'll need to define properties for each column we want. This is where MiniRecord will help us along.

The columns we want to store are identical to the instance variables that we defined inside our Contact class, so this makes things easy.

Open up contact.rb and add some fields to the table.

...
class Contact < ActiveRecord::Base

  field :first_name, as: :string
  field :last_name,  as: :string
  field :email,      as: :string
  field :note,       as: :text

  def full_name
    "#{ first_name } #{ last_name }"
  end

end
Note that this automatically sets up reader and writer methods for each of these fields, which is why we deleted them from the class a few minutes ago.

When you define a field, you need to provide the name of the column as a symbol, and then the data type the field will store. :string should be straightforward, but :text maybe not so much. Basically you can store more characters in a :text field than a :string field, which is limited to 256 characters. (You might want to write an extensive file on each contact!)

One thing you might notice is that we do not have to define a field for :id anymore. ActiveRecord will take care of creating an :id field that automatically increments!

Once the database fields are defined, we must add the following statement Contact.auto_upgrade! after the end of the class definition. This one takes care of effecting any changes to the underlying structure of the tables or columns.

All in all, this is what your setup is going to look like inside contact.rb. An entire database for a few lines of code? Not bad at all!

require 'active_record'
require 'mini_record'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'crm.sqlite3')

class Contact < ActiveRecord::Base

  field :first_name, as: :string
  field :last_name,  as: :string
  field :email,      as: :string
  field :note,       as: :text

  def full_name
    "#{ first_name } #{ last_name }"
  end

end

Contact.auto_upgrade!
Normally we would ask you to commit here, but before you do that, just one more thing to take care of...

Ensuring the database connection is closed
By default, SQLite allows 5 concurrent connections. Unfortunately, MiniRecord will open connections, but it won't close them automatically. What this means is that every 6th time you restart your CRM, there won't be any connections left and you'll get a mysterious Timeout error.

To fix this, add the following snippet of code to the bottom of your crm.rb file:

at_exit do
  ActiveRecord::Base.connection.close
end
This will ensure that as long as your program shuts down gracefully, it'll close the connection to the database.

Using .gitignore to avoid committing the database
If you're able to start your CRM, you'll see that ActiveRecord has automatically created a new file called crm.sqlite3 in your project folder. There are two things to know about this file:

crm.sqlite3 is your actual database. If you look inside, it's just a bunch of numbers, and that's because the data has been encoded as bytes.

You should tell git to ignore this file. (Databases and other non-text files should never be inside of git repositories!)

Create a .gitignore file and add the following lines:
```
# Ignore the default SQLite database.
*.sqlite3
*.sqlite3-journal
```
Now commit all of your changes. You'll notice when you run git status before you commit, the database file won't be included (but .gitignore will!). That means .gitignore is working.

2. Creating a Contact
Now that we've got our database and contacts table set up, we can start adding data to it.

Thankfully we can reuse the majority of our CRM code, but there are a couple small changes we have to make. ActiveRecord automatically provides us with a variety of methods that we can use to create records, one of which is the class method create, which we had previously implemented in our Contact class and used in our CRM.

However, the arguments this method takes is slightly different than what we implemented. ActiveRecord's create method expects a hash containing the keys and values of each property in the model, where each key should be the name of a property. In this case, that's first_name, last_name, email, and note. This is different than how we implemented it, as a separate argument for first_name, last_name, email, and note.

So now, we'll have to go through our crm.rb file, and anywhere we've used Contact.create like this:

Contact.create(first_name, last_name, email, note)
We'll have to do something like this:
```
contact = Contact.create(
  first_name: first_name,
  last_name:  last_name,
  email:      email,
  note:       note
)
```
Note that you may not have named your parameters first_name, last_name, email, and note, so just replace the values, not the keys, of your hash with whatever you did call them.

Go ahead and try to create some contacts through your CRM now. If you get stuck, take a step back from your CRM, and just load your contact.rb file into IRB, and try creating a couple contacts through IRB first. This is a great debugging technique that you should get into the habit of doing.

Once you're satisfied, don't forget to make a commit!

3. Fetching a Contact
Because ActiveRecord objects have similar properties to our previous Contact class, we will continue to be able to have a unique identifier for our resources. Better yet, it's still called id!

In addition, ActiveRecord also uses Contact.find to return the contact object.

All of this to say, we shouldn't actually need to change any of our calls to Contact.find in our CRM: it should work out of the gate.

Let's move on to updating and deleting contacts!

4. Updating and Deleting a Contact
Now that you're familiar with the different ActiveRecord methods you can use, the next step is for you to make sure the code in the rest of your CRM is up to date. Consult the ActiveRecord cheatsheet shown earlier in this assignment to figure out what the new methods are and how to use them.

Some hints:
Wherever you're updating fields of @contact, you'll need to make sure you save the record to the database. It's no longer enough to simply update a record in our program's memory, we also need to make sure that change is saved back to the database.
Try out your code and commit frequently, as often as every time you get one of your ActiveRecord method calls working properly. Lean towards committing too much instead of too little.
That's it! Success!


Don't forget to push the code to your GitHub account and submit your assignment.
