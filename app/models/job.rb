class Job < ModelBase
  bucket :jobs

  link :user
  link :account
end
