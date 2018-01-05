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
