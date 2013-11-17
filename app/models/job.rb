class Job < ModelBase
  bucket :jobs

  link :user, User
  link :account, Account
end
