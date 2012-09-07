
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

    File.open("#{filename}.iv", "wb") do |iv_file|
      iv_file << iv
    end

    puts "encrypted #{filename}"
  end

  def Secrets.decrypt(filename, password)
    cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    key = Digest::SHA1.hexdigest(password)
    iv = File.read("#{filename}.iv")
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


    puts "decrypted: #{filename} \n"
  end

  def Secrets.files_equal?(filename1, filename2)
    file1_digest = Digest::SHA1.hexdigest(File.read(filename1))
    file2_digest = Digest::SHA1.hexdigest(File.read(filename2))

    if file1_digest == file2_digest
      true
    else
      false
    end
  end

end