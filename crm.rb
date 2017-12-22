require "./contact.rb"
require "pry"
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
    puts '[5] Search all attributes'
    puts '[6] Search by attribute'
    puts '[7] Exit'
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
        search_all
      when 6
        search_by_attribute
      when 7
        system exit
      else
    end
  end

  def add_new_contact
    puts "\n --- Create New Contact ---"
    print "Please enter first name:"
    first_name = gets.chomp
    print "Please enter last name:"
    last_name = gets.chomp
    print "Please enter email (optional):"
    email = gets.chomp
    print "Please enter notes (optional):"
    notes = gets.chomp
    Contact.create(first_name,last_name,email,notes)
    puts "\n --- Contact created ---"
  end

  def modify_existing_contact
    # Need to implement checks for inputs
    #   currently wrong inputs should not throw exceptions but not do anything
    count = 1
    puts "\n --- Modify Contact ---"
    print "Please enter search criteria:"
    result = Contact.find(gets.chomp)
    puts "Results:"
    # If there are mutliple results
    if result.class == Array
      # Count how many results there are
      result.each {|contact|
        print "#{count}. "
        count += 1
        show_contact(contact)
      }
      print "Which contact do you want to modify?(1-#{count-1}):"
      contact_num_selected = gets.chomp.to_i
      if (contact_num_selected > 0) && (contact_num_selected < count)
        puts "Do you want to modify contact below?:(y/n)"
        show_contact(result[contact_num_selected-1])
        ans = gets.chomp
        if ans.downcase == 'y'
          print "What would you like to modify?(first name,last name,email,notes): "
          attribute = gets.chomp
          print "What would you like to set it to?: "
          val = gets.chomp
          result[contact_num_selected-1].update(attribute,val)
          puts "Contact was updated"
        end
      else
        puts "Contact was not updated"
      end
    else
      show_contact(result)
      print "Do you want to modify this contact?(y/n):"
      ans = gets.chomp.downcase
      if ans == 'y'
        print "What would you like to modify?(first name,last name,email,notes): "
        attribute = gets.chomp
        print "What would you like to set it to?: "
        val = gets.chomp
        result.update(attribute,val)
        puts "Contact was updated"
      else
        puts "Contact was not updated"
      end
    end
  end

  def delete_contact
    count = 1
    puts "\n --- Delete Contact ---"
    print "Please enter search criteria:"
    result = Contact.find(gets.chomp)
    puts "Results:"
    # If there are mutliple results
    if result.class == Array
      # Count how many results there are
      result.each {|contact|
        print "#{count}. "
        count += 1
        show_contact(contact)
      }
      print "Which contact do you want to delete?(1-#{count-1}):"
      contact_num_selected = gets.chomp.to_i
      if (contact_num_selected > 0) && (contact_num_selected < count)
        puts "Do you want to delete contact below?:(y/n)"
        show_contact(result[contact_num_selected-1])
        ans = gets.chomp
        if ans.downcase == 'y'
          # binding.pry
          result[contact_num_selected-1].delete
          puts "Contact was deleted"
        end
      else
        puts "Contact was not deleted"
      end
    else
      show_contact(result)
      print "Do you want to delete this contact?(y/n):"
      ans = gets.chomp.downcase
      if ans == 'y'
        result.delete
        puts "Contact was deleted"
      else
        puts "Contact was not deleted"
      end
    end
  end

  def display_all_contacts
    puts "\n --- All Contacts ---"
    Contact.all.each {|contact|
      show_contact(contact)
    }
  end

  def search_all
    puts "\n --- Search Contact ---"
    print "Please enter search criteria:"
    result = Contact.find(gets.chomp)
    puts "Results:"
    if result.class == Array
      result.each {|contact|
        show_contact(contact)
      }
    else
      show_contact(result)
    end
  end

  def search_by_attribute
    puts "\n --- Search by attribute ---"
    print "Please enter search criteria (first name,last name, email, id): "
    criteria = gets.chomp
    print "Please enter value you want to search (ex. \"john\",\"lopez\", \"john@gmail.com\", 1): "
    val = gets.chomp
    result = Contact.find_by(criteria,val)
    puts "Results:"
    if result.class == Array
      result.each {|contact|
        show_contact(contact)
      }
    else
      show_contact(result)
    end
  end

  def show_contact(contact)
    puts "#{contact.full_name.split.map(&:capitalize).join(' ')} | email:#{contact.email} | notes:#{contact.notes}"
  end

end

Contact.create("john","lopez","john@gmail.com","made this program")
Contact.create("dave","smith","dave@gmail.com")
Contact.create("charlize","lopez","charl@gmail.com")
Contact.create("bob","doel","bob@usa.gov")
Contact.create("lorem","ipsum","lee@latin.org")



CRM.new
