#!/usr/bin/ruby

# Script File: keep_secret.rb
# Author: Cameron Carroll; Created September 2012
# Last Updated: July 2014
# Released under MIT License
#
# Purpose: 
#   An interface to secrets.rb, which uses OpenSSL to encrypt/decrypt single files at a time.
#   Features timed decryption so you don't have to worry about re-encrypting your working file.
#
# Usage:
#   See options definition below or invoke keep_secret.rb --help

require 'rubygems'
require 'bundler/setup'

require 'trollop'
require 'highline/import'
require 'fileutils'

require 'pry'

require_relative 'secrets.rb'
VERSION = '1.0.1'

def parse_options
  opts = Trollop::options do
    version "keep_secret #{VERSION} (c) 2014 Cameron Carroll"
    banner <<-EOS
Usage:
keep_secret.rb [options] --encrypt/--decrypt/--update <filename>
      
Examples:
    keep_secret.rb --password <password> --encrypt <filepath>
    keep_secret.rb --decrypt <filepath>
    -or-
    keep_secret.rb --update <filepath> --password <password> --length <minutes>
    (Proceed to work with file... after given time, file is re-encrypted.)


    EOS

    opt :encrypt, "File to encrypt.", :type => :string
    opt :decrypt, "File to decrypt.", :type => :string
    opt :update, "File to decrypt temporarily.", :type => :string
    opt :length, "Length of time file should be decrypted. (Default 10)", :type => :string, :default => '10'
    opt :password, "Password for encryption/decryption. (avoids prompt)", :type => :string
  end
  # opts.encrypt or opts.decrypt contains the filename string
  # opts.password contains the (optional) password argument.
  Trollop::die "must select either encryption or decryption and specify a file" unless opts[:encrypt] || opts[:decrypt] || opts[:update]
  Trollop::die "must either encrypt or decrypt" if opts[:encrypt] && opts[:decrypt] && opts[:update]
  Trollop::die :encrypt, "must reference an existing file" unless File.exist?(opts[:encrypt]) if opts[:encrypt]
  Trollop::die :decrypt, "must reference an existing file" unless File.exist?(opts[:decrypt]) if opts[:decrypt]
  Trollop::die :length, "must be a positive integer time (in minutes)" unless opts[:length].to_i > 0 || opts[:length].to_i.modulo(1) != 0

  opts[:filename] = opts[:encrypt] || opts[:decrypt] || opts[:update]

  return opts
end

# HELPER METHODS:
# --------------

def get_password(opts, operation)
  if opts[:password]
    opts[:password]
  else
    prompt_for_password operation
  end
end

def prompt_for_password(operation)
  inflection_flag = true if operation == :encrypt
  puts 
  password = ask("Please enter #{inflection_flag ? "a" : "the"} password for this volume:") { |q| 
    q.echo = "*"
  }
  return password
end

def file_summary(filename)
  say "Encrypted #{filename}."
  say "File Summary:"
  say "#{filename} --> encrypted version of original file"
  say "#{filename}.iv --> initialization vector (required for decryption)"
end

# APPLICATION LOGIC:
# ------------------
opts = parse_options

if opts[:encrypt]
  operation = :encrypt
elsif opts[:decrypt]
  operation = :decrypt
elsif opts[:update]
  operation = :decrypt
  length = opts[:length] ? opts[:length] : '10'
end

filename = opts[:filename]
password = get_password(opts, operation)
Secrets.send(operation, filename, password)

if opts[:encrypt]
  FileUtils.rm filename if File.exist?("#{filename}.enc") && File.exist?("#{filename}.iv")
  FileUtils.mv "#{filename}.enc", filename
  file_summary(filename)
elsif opts[:decrypt]
  say "Decrypted volume (#{filename}) permanently."
elsif opts[:update]
  say "Decrypted volume (#{filename}) for #{length} minutes."
  say "Please edit your file now..."
  say "(But don't interrupt this terminal process!)"
  sleep length.to_f/2 * 60
  say "#{length.to_f/2} minutes before automatic re-encryption"
  sleep length.to_f/2 * 60
  say "Locking volume: #{filename}..."
  Secrets::encrypt "#{filename}.dec", password
  FileUtils::rm filename if File.exist?("#{filename}.enc") && File.exist?("#{filename}.iv") && File.exist?("#{filename}")
  FileUtils::rm "#{filename}.dec" if File.exist?("#{filename}.dec")
  FileUtils::mv "#{filename}.enc", filename
  file_summary(filename)
end