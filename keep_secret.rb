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
      keep_secret.rb [options] <filename>
      where [options] are:

    EOS

    opt :encrypt, "Encrypt this file."
    opt :decrypt, "Decrypt this file."
    opt :password, "Password for encryption/decryption. (argument avoids prompt)", :type => :string
    opt :filename, "File in question", :type => :string
  end
  binding.pry
end

main