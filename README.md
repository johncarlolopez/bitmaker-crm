![Bitmaker](https://github.com/johncarlolopez/bitmaker-reference/blob/master/bitmakerlogo.svg)
# CRM
###

## Part 2

### Continued from [CRM assignment 1](https://github.com/johncarlolopez/bitmaker-d13a2-crm) , [CRM assignment 2](https://github.com/johncarlolopez/bitmaker-d15a2-crm) , and [CRM assignment 3](https://github.com/johncarlolopez/bitmaker-d18a4-crm)

Your goal is to make your CRM look like the screenshot below using your knowledge of the box model. You will also need to look up a few new properties in the docs. Make sure you're using semantic HTML elements such as header, footer, nav, and main

![Bitmaker](https://github.com/bitmakerlabs/crm-web-assignment/blob/master/mockup.png)

## Part 3 CRM Web : Dynamic Routes

### Showing a single contact
___
Our goal is to enable users to view the details of any individual contact on its own page. To do this, we can add a dynamic route that contains the id of the contact that the user wants to view. No two contacts have the same id, so this is the best attribute to use to allow us to understand what contact the user wants to see.  

Defining the new route  

You can define a dynamic route in Sinatra by describing the pattern of the URLs that this route should handle, which means identifying the part of the URL that will change from request to request with a colon (:) and a name. In this case, we'll identify that the end of these URLs will contain an id:

```
get '/contacts/:id' do
  # instructions for how to handle requests to this route will go here
end
```
This route will match get requests to any URL that matches this format, including loalhost:4567/contacts/1, loalhost:4567/contacts/1234567, loalhost:4567/contacts/55, etc. It will also match URLs that don't contain valid ids, such as loalhost:4567/contacts/mittens, so eventually we'll have to consider what to do if that's the case. For now we'll make the route work with the assumption that the id in the URL refers to a real contact's id.  

Adding a new view  

Create a new view called show_contact.erb and render it as the response from the route we just made. Put a heading in the view so you can test to make sure it's rendering properly.

To test it, try going to localhost:4567/contacts/1, or a URL with any other id in it. Try changing the id.  

Showing the right data  

Our strategy for displaying the right contact data will be to retrieve the contact from the database, store it in an instance variable, and use that variable in the view.

The id in the URL tells us which contact we need to retrieve from the database. But how can we access the id part of the URL from our Sinatra code? When handling requests to dynamic routes, Sinatra stores the dynamic part of the URL (in this case, the id) in the params hash under a key that matches the name we gave to that part of the URL. Meaning that in our route block we can access the specific id for that request by writing params[:id]

You may recall from past assignments that our contact class's find_by method allows us to retrieve contacts from the database. If we pass in a hash where the key is the name of a database column (such as "id") and the value is the actual value to search for in the database (the actual id in this case), then find_by will return the contact that matches that id.

Putting all these ideas together, we can finish writing our route code:

```
get '/contacts/:id' do
  # params[:id] contains the id from the URL
  @contact = Contact.find_by({id: params[:id].to_i})
  erb :show_contact
end
```

Your challenge: complete show_contact.erb using ```@contact``` to display all the attributes of this contact. As always, you should be thinking about what semantic HTML markup to use when doing this.

Once you can go to localhost:4567/contacts/1 and see contact 1 (or whatever ids currently exist in your database - you might not have a contact with id 1 at this point), you've succeeded! Don't forget to make a celebratory commit.  

Navigation  

Now it's time to return to the /contacts page that we made when we were first moving our CRM into Sinatra. This page should contain a list of all the contacts in our database.

Your task is to add a link for each contact in this list that will take the user from the /contacts page to the specific page for that individual contact (HINT: use embedded Ruby to make sure the href of the links contain the correct id).

Test your links our and commit once they're working.  

What about invalid ids?  

What happens currently if you try to visit a contact page that doesn't exist, such as localhost:4567/mittens? You should be getting a similar error to this:

NoMethodError at /contacts/mittens
undefined method 'first_name' for nil:NilClass
This is because when we can't find the contact matching the id in the request (there is no contact with mittens as its id), which means ```@contact``` is nil, and our view can't handle nil values.

We should do what a typical web application does in these circumstances and return a 404 Not Found response status code if we can't find what the user is asking for:

```
get '/contacts/:id' do
  @contact = Contact.find_by(id: params[:id].to_i)
  if @contact
    erb :show_contact
  else
    raise Sinatra::NotFound
  end
end
```

After adding that code, if you try an id that you know doesn't exist in your database you should get a 404 page back saying "Sinatra doesn't know this ditty...".


# 02 - CRM Web Part 4: HTML Forms
### Monday, Jan 8th

## Creating a new contact
___
Let's say you just met somebody new. You want to add this person to your CRM. How? We need a form to let us enter their information.

This particular feature is going to require two new routes: a GET route to display the page with the form, and a POST route that will handle the requests generated by submitting that form.

### Your first challenge
___
1. Create a new file called new.erb in the views directory (this is where our HTML form will go later).
2. Add a new route for the URL localhost:4567/contacts/new that renders that new view.
3. Test your work by adding a heading to your new view that says "Add a new contact" or something similar, then go to the new URL we just set up (don't forget to restart your server first). If you see that heading you just added, you've succeeded! That calls for a commit.

###Making our first form
___
Now we're ready to add a form to our new view.
```
<h1>Create new Contact</h1>

<form action='/contacts' method='post'>
  <input type='text' name='first_name'>
  <input type='text' name='last_name'>
  <input type='text' name='email'>
  <input type='text' name='note'>
  <input type='submit' value='New Contact'>
</form>
```
Run the program and try it out. If it works, commit everything you've got so far.

Now let's move on to handle the form request.

### Using POST and the params hash
___
If you try to submit this form right now by filling it out at http://localhost:4567/contacts/new, you should get an error, because we haven't actually set up a route to handle the submission.

If you take a look at the code of our newly-created form, we're using the POST method so that we can submit data to our server. When the server responds to the POST request, our program needs to take care of creating a new contact with the submitted data.

To simplify things for now, we won't create a new contact, we'll just inspect the data submitted by the form. In order to do this, we'll do a puts statement on the params hash, which is where Sinatra stores the form data for us.

At the end of crm.rb, add the following route:
```
...

get '/' do
  ...
end

get '/contacts' do
  ...
end

get '/contacts/new' do
  ...
end

get '/contacts/:id' do
  ...  
end

post '/contacts' do
  puts params
end
```
After you save this, try filling out the form at http://localhost:4567/contacts/new again. You should no longer get an error, and your log output should look something like this:
```
{"first_name"=>"Betty", "last_name"=>"Maker", "email"=>"bettymakes@bitmaker.co", "note"=>"loves Pokemon", "Submit"=>"Submit Query"}
::1 - - [19/Jan/2016:01:21:08 -0800] "POST /contacts HTTP/1.1" 200 - 0.0004
localhost - - [19/Jan/2016:01:21:08 PST] "POST /contacts HTTP/1.1" 200 0
```
This is just a the params hash being printed to the log using puts.

With the params hash, we can now create a new contact.

Inside your crm.rb, update the post '/contacts' route:
```
post '/contacts' do
  Contact.create(
    first_name: params[:first_name],
    last_name:  params[:last_name],
    email:      params[:email],
    note:       params[:note]
  )
end
```
One last thing. If you save this file and retry submitting, you'll notice that you end up on a blank page. That's because our route's response isn't actually returning a page. Ultimately, the best thing to do in this case is redirect back to the View all contacts page so that we can view our latest addition.

This is a very common pattern:

  * GET request to display form
  * POST data upon submitting the form
  * REDIRECT to a different page  

Modify crm.rb and update the post '/contacts' route again:
```
post '/contacts' do
  Contact.create(
    first_name: params[:first_name],
    last_name:  params[:last_name],
    email:      params[:email],
    note:       params[:note]
  )
  redirect to('/contacts')
end
```
Try filling out the form and make sure the new contact gets added to the list of all contacts. Don't forget to commit if it's working!

## Editing a contact
___
Just like adding a new contact, in order to edit a contact, we need two new routes: the first to display the edit form and the second to handle the form submission.

Let's start with the first route and view. Unlike the "create" form, when we edit a contact, we need to find it first and pre-fill the data inside the form.

Given that we now know how to view a single contact, we can use a similar approach when it comes to editing, by using a route pattern.

Let's define a new route at the bottom of your application. Modify crm.rb:
```
...
get '/contacts/:id/edit' do
  erb :edit_contact
end
```
Now create a new corresponding view called views/edit_contact.erb.

Just like our contact show page, we will need to find our corresponding contact object and put it in a variable so that our view can access it.

Modify the new route in crm.rb:
```
get '/contacts/:id/edit' do
  @contact = Contact.find_by(id: params[:id].to_i)
  if @contact
    erb :edit_contact
  else
    raise Sinatra::NotFound
  end
end
```
The views/edit_contact.erb view will be very similar to the views/new_contact.erb view, but there are a few main differences.

  * The first is that because we're updating data, we need to tell our form to use the method PUT. However, as you can see in our form, it's not as simple as setting up "post". HTML Forms only support GET and POST as request methods.
For this reason, Sinatra, Rails, and many other web frameworks provide a workaround convention: by adding an extra hidden field called "\_method" that contains the real value of the request (in this case we're working with PUT so that value will be put).

As we'll see later on, there are other ways to submit data over the web that fully support all request methods, so it's still important to take advantage of them.

Try adding and removing the hidden field and keep an eye on the terminal server logs, you'll see that when it is present, our form makes a PUT request and without it, it should be a POST.

  * The second difference is that we will have to set default values in the form that currently belong to the \@contact.

  * Thirdly, we also have a special form action: we want to do a "put" request to "/contacts/:id", so we'll add the value of the contact's id in our action.

Modify view/edit_contact.erb (Take note of the hidden field):
```
<h1>Edit a Contact</h1>

<form action='/contacts/<%= @contact.id %>' method='post'>
  <input type='hidden' name='_method' value='put'>
  <input type='text' name='first_name' value='<%= @contact.first_name %>'>
  <input type='text' name='last_name' value='<%= @contact.last_name %>'>
  <input type='text' name='email' value='<%= @contact.email %>'>
  <input type='text' name='note' value='<%= @contact.note %>'>
  <input type='submit' value='Edit Contact'>
</form>
```
Run the program and take a look at the edit form for one of your contacts.

If you go to the edit form of a contact that doesn't exist, what happens?

Commit your changes before we move on to handling the form submission.

Handling the put form submission
Once we submit the form that we just created, our server will receive a put request to '/contacts/:id', we should create a route to handle this request.

Add the following to the bottom of crm.rb:
```
put '/contacts/:id' do
  @contact = Contact.find_by(id: params[:id].to_i)
  if @contact
    @contact.update(
    first_name: params[:first_name],
    last_name:  params[:last_name],
    email:      params[:email],
    note:       params[:note]
    )

    redirect to('/contacts')
  else
    raise Sinatra::NotFound
  end
end
```
Let's look at this new route step-by-step:

  * This route handles a put request about a particular id. Inside the block, the params hash will contain the id along with any of information we submitted in the form.

  * With the id from the params, we try to find the contact. If there's ever any reason we don't find it, we raise the 404 Not Found error.

  * If the contact is found, we need to update it. Once it's updated, we want to redirect to our main contacts page.

Run the program and try submitting an edit to a contact.

Before we continue on to the next step, create a commit.

## Removing a contact
___
Though removing a contact and making a request for the DELETE action requires a form, it doesn't actually need any more inputs than a submit button and a hidden "\_method" field, because the DELETE action and the URL that represents the contact resource are sufficient. We don't need additional input from the user.

Your challenge: Add a delete form and submit button to the bottom of your views/show_contact.erb view.

Remember: when you're using PUT and DELETE, you must include the additional "\_method" hidden field that contains the method as a value. The form's actual method must also be "post". It won't work if you set it to get.

As per usual, with every new request must come a route that handle it.

Inside crm.rb, create a route that can handle your new DELETE '/contacts/:id' request. Inside this block, you'll need to remove a contact.
```
...

delete '/contacts/:id' do
  \@contact = Contact.find_by(params[:id].to_i)
  if \@contact
    \@contact.delete
    redirect to('/contacts')
  else
    raise Sinatra::NotFound
  end
end
```
If the contact exists, it should be removed and redirect back to the '/contacts' main page. Otherwise, it should raise a 404.

Try it out and then commit your changes, you're almost done!

## Navigation
___
1. On the individual show contact page, add a link to that contact's edit page.
2. On the edit page for an individual contact, add a link that takes the user back to the show contact page.
3. On the main /contacts page add a link to the edit page for each contact in the list.

# Done
___
You made your first web app complete with all four CRUD actions! Congratulations!
