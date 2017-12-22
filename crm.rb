require "./contact.rb"

class CRM

  def initialize
    main_menu
  end

  def main_menu
    while true # repeat indefinitely
      print_main_menu
      user_selected = gets.to_i
      call_option(user_selected)
    end
  end

  def print_main_menu
    puts "\n --- Main Menu ---"
    puts '[1] Add a new contact'
    puts '[2] Modify an existing contact'
    puts '[3] Delete a contact'
    puts '[4] Display all the contacts'
    puts '[5] Search by attribute'
    puts '[6] Exit'
    print 'Enter a number: '
  end

  def call_option(opt = nil)
    # binding.pry
    case opt
    when 1
      add_new_contact
    when 2
      modify_existing_contact
    when 3
      delete_contact
    when 4
      display_all_contacts
    when 5
      search_by_attribute
    when 6
      system exit
    else
      puts "Invalid selection"
    end
  end

  def add_new_contact
    puts "\n --- Create New Contact ---"
    print "Please enter first name:"
    first_name = gets.chomp.downcase
    print "Please enter last name:"
    last_name = gets.chomp.downcase
    print "Please enter email (optional):"
    email = gets.chomp.downcase
    print "Please enter notes (optional):"
    notes = gets.chomp.downcase
    # Contact.create(first_name,last_name,email,notes)
    Contact.create(
      first_name: first_name,
      last_name:  last_name,
      email:      email,
      notes:       notes
    )
    puts "\n --- Contact created ---"
  end

  def modify_existing_contact
    # Need to implement checks for inputs
    #   currently wrong inputs should not throw exceptions but not do anything
    count = 1
    puts "\n --- Modify Contact ---"
    print "Please enter search criteria (first name,last name, email, id): "
    attribute = gets.chomp
    case attribute
    when "first name"
      attribute = "first_name = "
    when "last name"
      attribute = "last_name = "
    when "email"
      attribute = "email = "
    when "id"
      attribute = "id = "
    else
      puts "Invalid attribute"
      return nil
    end
    print "Please enter value you want to search (ex. \"john\",\"lopez\", \"john@gmail.com\", 1): "
    val = gets.chomp
    result = Contact.find_by_sql("SELECT * FROM contacts WHERE #{attribute}\"#{val}\"")
    puts "Results:"
    if result.count > 1
      # Count how many results there are
      result.each {|contact|
        print "#{count}. "
        count += 1
        show_contact(contact)
      }
      print "Which contact do you want to delete?(1-#{count - 1}):"
      contact_num_selected = gets.chomp.to_i
      if (contact_num_selected > 0) && (contact_num_selected < count)
        puts "Do you want to delete contact below?:(y/n)"
        show_contact(result[contact_num_selected - 1])
        ans = gets.chomp
        if ans.downcase == 'y'
          # binding.pry
          result[contact_num_selected - 1].delete
          puts "Contact was deleted"
        end
      else
        puts "Contact was not deleted"
      end
    elsif result.count == 1
      show_contact(result.first)
      print "Do you want to delete this contact?(y/n):"
      ans = gets.chomp.downcase
      if ans == 'y'
        result.first.delete
        puts "Contact was deleted"
      else
        puts "Contact was not deleted"
      end
    else
      puts "No contact found"
      return nil
    end
  end

  def delete_contact
    count = 1
    puts "\n --- Delete Contact ---"
    print "Please enter search criteria (first name,last name, email, id): "
    attribute = gets.chomp
    case attribute
    when "first name"
      attribute = "first_name = "
    when "last name"
      attribute = "last_name = "
    when "email"
      attribute = "email = "
    when "id"
      attribute = "id = "
    else
      puts "Invalid attribute"
      return nil
    end
    print "Please enter value you want to search (ex. \"john\",\"lopez\", \"john@gmail.com\", 1): "
    val = gets.chomp
    result = Contact.find_by_sql("SELECT * FROM contacts WHERE #{attribute}\"#{val}\"")
    puts "Results:"
    if result.count > 1
      # Count how many results there are
      result.each {|contact|
        print "#{count}. "
        count += 1
        show_contact(contact)
      }
      print "Which contact do you want to delete?(1-#{count - 1}):"
      contact_num_selected = gets.chomp.to_i
      if (contact_num_selected > 0) && (contact_num_selected < count)
        puts "Do you want to delete contact below?:(y/n)"
        show_contact(result[contact_num_selected - 1])
        ans = gets.chomp
        if ans.downcase == 'y'
          # binding.pry
          result[contact_num_selected - 1].delete
          puts "Contact was deleted"
        end
      else
        puts "Contact was not deleted"
      end
    elsif result.count == 1
      show_contact(result.first)
      print "Do you want to delete this contact?(y/n):"
      ans = gets.chomp.downcase
      if ans == 'y'
        result.first.delete
        puts "Contact was deleted"
      else
        puts "Contact was not deleted"
      end
    else
      puts "No contact found"
      return nil
    end
  end

  def display_all_contacts
    puts "\n --- All Contacts ---"
    Contact.all.each {|contact|
      show_contact(contact)
    }
  end

  def search_by_attribute
    puts "\n --- Search by attribute ---"
    print "Please enter search criteria (first name,last name, email, id): "
    attribute = gets.chomp
    case attribute
    when "first name"
      attribute = "first_name = "
    when "last name"
      attribute = "last_name = "
    when "email"
      attribute = "email = "
    when "id"
      attribute = "id = "
    else
      puts "Invalid attribute"
      return nil
    end
    print "Please enter value you want to search (ex. \"john\",\"lopez\", \"john@gmail.com\", 1): "
    val = gets.chomp
    result = Contact.find_by_sql("SELECT * FROM contacts WHERE #{attribute}\"#{val}\"")
    # p "result is : #{result.first.class}"
    puts "Results:"
    if result.first.class == NilClass
      puts "No contact found"
    else
      result.each {|contact|
          show_contact(contact)
          puts "arrived at loop"
        }
    end
    # result.each {|contact|
    #     show_contact(contact)
    #     puts "arrived at loop"
    #   }
    # if result.class == Array
    #   result.each {|contact|
    #     show_contact(contact)
    #   }
    # else
    #   show_contact(result)
    # end
  end

  def show_contact(contact)
    # puts "test"
    # p "first item class:#{contact.first.class}"
    # if contact.first.class == NilClass
    #   return "No contact found"
    # else
      puts "#{contact.full_name.split.map(&:capitalize).join(' ')} | email:#{contact.email} | notes:#{contact.notes}"
    # end

  end

end

# Contact.create(
#   first_name: "john",
#   last_name:  "lopez",
#   email:      "john@gmail.com",
#   notes:       "made this program"
# )
# Contact.create(
#   first_name: "charlize",
#   last_name:  "lopez",
#   email:      "charlize@gmail.com",
#   notes:       ""
# )
# Contact.create(
#   first_name: "lorem",
#   last_name:  "ipsum",
#   email:      "lee@latin.org",
#   notes:       ""
# )
# Contact.create(
#   first_name: "bob",
#   last_name:  "doel",
#   email:      "bob@usa.gov",
#   notes:       ""
# )
CRM.new

# On exit, close connections automatically opened by Minirecord
at_exit do
  ActiveRecord::Base.connection.close
end
