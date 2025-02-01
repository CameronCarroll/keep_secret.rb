# Script File: secrets.rb
# Author: Cameron Carroll; Created in September 2012
# Last Updated: January 2024
# Released under MIT License
#
# Purpose:
#   A small library to encrypt/decrypt a single file using OpenSSL:aes-256-cbc

require 'openssl'
require 'digest/sha1'

ENCRYPTED_EXTENSION = 'enc'
DECRYPTED_EXTENSION = 'dec'

module Secrets

  def Secrets.encrypt(filename, password)
    salt = OpenSSL::Random.random_bytes(16)
    iterations=100000

    key = OpenSSL::PKCS5.pbkdf2_hmac(
      password,
      salt,
      iterations,
      32,
      OpenSSL::Digest.new("SHA256")
    )

    cipher = OpenSSL::Cipher.new('AES-256-CBC')
    cipher.encrypt
    cipher.key = key

    # Old implementation
    # cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    # cipher.encrypt
    #
    # key = Digest::SHA1.hexdigest(password)
    # iv = cipher.random_iv
    #
    # cipher.key = key
    # cipher.iv = iv
    #
    # filename = strip_filename(filename)
    #
    # update_file(cipher, filename, ENCRYPTED_EXTENSION)
    #
    # File.open("#{filename}.iv", "wb") do |iv_file|
    #   iv_file << iv
    # end
  end

  def Secrets.decrypt(filename, password)
    cipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    key = Digest::SHA1.hexdigest(password)
    iv = File.read("#{filename}.iv")
    cipher.decrypt
    cipher.key = key
    cipher.iv = iv

    buffer = ""

    filename = strip_filename(filename)

    update_file(cipher, filename, DECRYPTED_EXTENSION)
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

private

def strip_filename(filename)
  if File.extname(filename) == ".enc" || File.extname(filename) == ".dec"
    filename[0..-5]
  else
    filename
  end
end

def update_file(cipher, filename, extension)
  buffer = ""
  File.open("#{filename}.#{extension}", "wb") do |output_file|
    File.open(filename, "rb") do |input_file|
      while input_file.read(4096, buffer)
        output_file << cipher.update(buffer)
      end
      output_file << cipher.final
    end
  end
end
