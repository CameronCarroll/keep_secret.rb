
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

    buffer = ""
    File.open("#{filename}.enc", "wb") do |output_file|
      File.open(filename, "rb") do |input_file|
        while input_file.read(4096, buffer)
          output_file << cipher.update(buffer)
        end
        output_file << cipher.final
      end
    end

    puts "iv: #{iv}"
  end

  def Secrets.decrypt(filename, password, iv)
    cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    key = Digest::SHA1.hexdigest(password)
    cipher.decrypt
    cipher.key = key
    cipher.iv = iv

    buffer = ""
    File.open("#{filename}.dec", "wb") do |output_file|
      File.open("#{filename}.enc", "rb") do |input_file|
        while input_file.read(4096, buffer)
          output_file << cipher.update(buffer)
        end
        output_file << cipher.final
      end
    end
    puts "decrypted: #{decrypted_data} \n"
  end

end