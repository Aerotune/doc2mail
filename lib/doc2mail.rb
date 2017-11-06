# Part of Ruby std-lib
require 'openssl'
require 'base64'
require 'savon'

module Doc2Mail
  require_relative 'doc2mail/rsa_encrypt'
  require_relative 'doc2mail/web_service'
  require_relative 'doc2mail/meta_information'
end
