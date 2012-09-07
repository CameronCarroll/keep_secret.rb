#!/usr/bin/ruby

# Script File: keep_secret
# Purpose: 
#   Interface script for secrets.rb
#
#
# Usage:
#   See options definition in main()

# Modifications:
#   09/06/12 -- Initial Creation

require 'rubygems'
require 'bundler/setup'

require 'trollop'
require 'pry'
VERSION = '0.0.1'


def main
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
  Trollop::die :encrypt, "must reference an existing file" unless File.exist?(opts[:encrypt]) if opts[:encrypt]
  Trollop::die :decrypt, "must reference an existing file" unless File.exist?(opts[:decrypt]) if opts[:decrypt]

end

main