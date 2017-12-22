# require "pry"
# Contact class
class Contact
  # Class variables
  @@contacts = []
  @@id = 1

  # This method should initialize the contact's attributes
  def initialize(first_name, last_name, email = '', notes = '')
    @first_name = first_name.downcase
    @last_name = last_name.downcase
    @email = email.downcase
    @notes = notes
    @id = @@id
    @@id += 1
  end

  # Readers
  def first_name
    return @first_name
  end

  def last_name
    return @last_name
  end

  def email
    return @email
  end

  def notes
    return @notes
  end

  def id
    return @id
  end

  # Writers
  def first_name=(first_name)
    @first_name = first_name
  end

  def last_name=(last_name)
    @last_name = last_name
  end

  def email=(email)
    @email = email
  end

  def notes=(notes)
    @notes = notes
  end

  # This method should call the initializer,
  # store the newly created contact, and then return it
  def self.create(first_name,last_name,email ='',notes = '')
    new_contact = Contact.new(first_name,last_name,email,notes)
    @@contacts << new_contact
    return new_contact
  end

  # This method should return all of the existing contacts
  def self.all
    return @@contacts
  end

  # This method should accept an id as an argument
  # and return the contact who has that id
  def self.find(criteria)
    # extended
    matches = []
    # binding.pry
    # puts criteria.class
    if criteria.class == String
      @@contacts.each {|contact|
        if contact.full_name.include?(criteria.downcase)
          matches << contact
        elsif contact.email.include?(criteria.downcase)
          matches << contact
        elsif (contact.notes)
          # Only run if there are notes otherwise it will show exception
          if contact.notes.include?(criteria.downcase)
            matches << contact
          end
        end
      }
    elsif criteria.class == Fixnum
      @@contacts.each {|contact|
        if contact.id == criteria.to_i
          matches << contact
        end
      }
    end
    return match_result(matches)
  end

  # This method should allow you to specify
  # 1. which of the contact's attributes you want to update
  # 2. the new value for that attribute
  # and then make the appropriate change to the contact
  def update(attribute,val)
    case attribute
    when "first name"
      self.first_name = val.to_s
    when "last name"
      self.last_name = val.to_s
    when "email"
      self.email = val.to_s
    when "notes"
      self.notes = val.to_s
    end
  end

  # This method should work similarly to the find method above
  # but it should allow you to search for a contact using attributes other than id
  # by specifying both the name of the attribute and the value
  # eg. searching for 'first_name', 'Betty' should return the first contact named Betty
  def self.find_by(attribute,val)
    matches = []
    case attribute.downcase
    when "first name"
      @@contacts.each {|contact|
        if contact.first_name == val.downcase
          matches << contact
        end
      }
    when "last name"
      @@contacts.each {|contact|
        if contact.last_name == val.downcase
          matches << contact
        end
      }
    when "email"
      @@contacts.each {|contact|
        if contact.email == val.downcase
          matches << contact
        end
      }
    when "id"
      @@contacts.each {|contact|
        if contact.id == val.to_i
          matches << contact
          # puts "WORKED"
        end
        # puts "contact.id:#{contact.id}//val#{val}"
      }
    end
    return match_result(matches)
  end

  # This method should delete all of the contacts
  def self.delete_all
    @@contacts = []
  end

  def full_name
    return "#{first_name} #{last_name}"
  end

  # This method should delete the contact
  # HINT: Check the Array class docs for built-in methods that might be useful here
  def delete
    # puts "deleted #{self}"
    @@contacts.delete(self)
  end

  def self.delete(criteria)
    matches = []
    # binding.pry
    # Might need changing as this is a wide delete
    if criteria.class == String
      @@contacts.each {|contact|
        if contact.full_name.include?(criteria.downcase)
          matches << contact
          contact.delete
        elsif contact.email == criteria.downcase
          matches << contact
          contact.delete
        end
      }
    elsif criteria.class == Fixnum
      @@contacts.each {|contact|
        if contact.id == criteria
          matches << contact
          contact.delete
        end
      }
    end
    return match_result(matches)
  end

  # returns in nicer format
  def self.match_result(matches)
    if matches.count == 1
      return matches.first
    elsif matches.count == 0
      return nil
    else
      return matches
    end
  end
  # Feel free to add other methods here, if you need them.

end

# john = Contact.create("john","lopez","john@gmail.com")
# dave = Contact.create("dave","smith","dave@gmail.com")
# charl = Contact.create("charl","lopez","charl@gmail.com")

# p Contact.all

# p charl.full_name
# p Contact.find("charl")
# p Contact.find(1)
# puts "find:"
# p Contact.find("lopez")
# p Contact.find("lul")

# p Contact.delete("charl")
# p Contact.all

# charl.update("first_name","charle")
# p charl.first_name
# p Contact.find_by("first name","charl")
# p Contact.find_by("last name","lopez")
