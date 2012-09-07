#!/usr/bin/ruby

# Script File: keep_secret
# Purpose: 
#   Interface script for secrets.rb
#
#
# Ideas:
# 1. 'update' mode which decrypts a file, allows the user to update the contents and then re-encrypts the file and deletes
# the temporary working file.
# 2. automatically delete source file when encrypting after doing a checksum between a decrypted test and the raw file.

# Usage:
#   See options definition in main() or use keep_secret.rb --help

# Modifications:
#   09/06/12 -- Initial Creation

require 'rubygems'
require 'bundler/setup'

require 'trollop'
require 'pry'
require 'highline/import'

require './secrets.rb'
VERSION = '0.0.6'

def parse_options
  opts = Trollop::options do
    version "keep_secret 0.0.1 (c) 2012 Cameron Carroll"
    banner <<-EOS
keep_secret is a simple program to encrypt/decrypt a single file. By default, decrypted files
are deleted after 10 minutes so that you don't have to worry about manually re-encrypting your
data unless updating it.

Usage:
      keep_secret.rb [options] --encrypt/--decrypt <filename>
      
      Examples:
        keep_secret.rb --password applebees --encrypt ~/secret_applebees_menu.txt
        keep_secret.rb --decrypt ./nuclear_lunch_codes

    EOS

    opt :encrypt, "File to encrypt.", :type => :string
    opt :decrypt, "File to decrypt.", :type => :string
    opt :password, "Password for encryption/decryption. (argument avoids prompt)", :type => :string
  end
  # opts.encrypt or opts.decrypt contains the filename string
  # opts.password contains the (optional) password argument.
  Trollop::die "must select either encryption or decryption and specify a file" unless opts[:encrypt] || opts[:decrypt]
  Trollop::die "cannot select both encryption and decryption" if opts[:encrypt] && opts[:decrypt]
  Trollop::die :encrypt, "must reference an existing file" unless File.exist?(opts[:encrypt]) if opts[:encrypt]
  Trollop::die :decrypt, "must reference an existing file" unless File.exist?(opts[:decrypt]) if opts[:decrypt]

  return opts
end

def prompt_for_password(operation)
  inflection_flag = true if operation == :encrypt
  puts 
  password = ask("Please enter #{inflection_flag ? "a" : "the"} password for this volume:") { |q| 
    q.echo = "*"
  }
  return password
end

def main()
  opts = parse_options()
  if opts[:encrypt]
    filename = opts[:encrypt]
    password = prompt_for_password(:encrypt) unless opts[:password]
    Secrets::encrypt(filename, password)

  elsif opts[:decrypt]
    filename = opts[:decrypt]
    password = prompt_for_password(:decrypt) unless opts[:password]
    Secrets::decrypt(filename, password)
    unless Secrets::files_equal?(filename, "#{filename}.dec")
      warning "Original file and decrypted file have different checksums."
    end
  end



end #main()

main