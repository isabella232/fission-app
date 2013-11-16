class Account < ModelBase

  value :name

  index :name, :unique => true
  link :owner
  links :members

end
