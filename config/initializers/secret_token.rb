# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
FissionApp::Application.config.secret_key_base = 'db37f4b42aaf64e476236f038e50594563289196ffc90ac7e667d422f4e77acabba592f4bfcf39419aa479d58471776dde9e7ec8995f7925396bed0a38715fd5'
