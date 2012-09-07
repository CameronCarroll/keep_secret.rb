
# Script File: secrets.rb
# Purpose: A simple library for encrypting files or bits of text at a time.

# Modifications:
# 09/06/12 -- Initial Creation

require 'openssl'
require 'digest/sha1'

module Secrets
  
  def Secrets.encrypt(filename, password)
    cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    cipher.encrypt

    key = Digest::SHA1.hexdigest(password)
    iv = cipher.random_iv

    cipher.key = key
    cipher.iv = iv

    encrypted_data = cipher.update(raw_data)
    encrypted_data << cipher.final

    puts "encrypted: #{encrypted_data}\n"
  end

  def Secrets.decrypt(filename, password, iv)
    cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    cipher.decrypt
    cipher.key = key
    cipher.iv = iv

    decrypted_data = cipher.update(encrypted_data)
    decrypted_data << cipher.final
    puts "decrypted: #{decrypted_data} \n"
  end

end