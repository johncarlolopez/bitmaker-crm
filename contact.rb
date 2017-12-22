gem "activerecord", "=4.2.10"
require "mini_record"
require "active_record"

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'crm.sqlite3')

# Contact class
class Contact < ActiveRecord::Base

  # Database columns
  field :first_name, as: :string
  field :last_name, as: :string
  field :email, as: :string
  field :notes, as: :text

  def full_name
    return "#{first_name} #{last_name}"
  end
end
# Takes care of making any changes to the structure of tables or columns
Contact.auto_upgrade!

# On exit, close connections automatically opened by Minirecord
at_exit do
  ActiveRecord::Base.connection.close
end
