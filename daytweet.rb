#!/usr/bin/env ruby
# -*- encoding : utf-8 -*-

# author: Maximilian Irro <max@disposia.org>, 2012-2014

begin
  require 'icalendar'
  require 'date'
  require 'twitter'
  require 'optparse'
  require 'parseconfig'
rescue LoadError
  puts "Some gems seem to be not installed. You need to do that first: #{$!.message}"
  exit
end

DEFAULT_CONFIG_FILE = "daytweet.conf" 
USAGE = "Usage: daytweet.rb [options]"

options = {}
OptionParser.new do |opts|
  opts.banner = USAGE
  opts.separator ""
  opts.separator "Specific options:"

  opts.on("-c", "--config FILE", "Use a different config file than the default #{DEFAULT_CONFIG_FILE}") do |config_file|
    options[:config] = true
    options[:config_file] = config_file
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse! # do the parsing. do it now!


options[:config_file] = DEFAULT_CONFIG_FILE unless options[:config]

# reads the config params from the config file
begin
  configs = ParseConfig.new(options[:config_file])
rescue
  puts "error reading config file: #{options[:config_file]}"
  exit
end

CONSUMER_KEY        = configs['consumer_key']
CONSUMER_SECRET     = configs['consumer_secret']
OAUTH_TOKEN         = configs['oauth_token']
OAUTH_TOKEN_SECRET  = configs['oauth_token_secret']
ICAL_FILE           = configs['ical_file']


# open icalendar file
cal_file = nil
begin
    cal_file = File.open(ICAL_FILE, "r")
rescue
    puts "Error trying to open ical file: #{$!.message}" 
    exit
end

# get the calendar object
cals = Icalendar.parse(cal_file)
cal = cals.first

today_date_str = DateTime.now.strftime("%Y-%m-%d")

# make array of all the events that are today
todays_events = []
cal.events.each do |event|
    todays_events << event if event.dtstart.to_s == today_date_str
end


unless todays_events.empty?
  
  Twitter.configure do |config|
    config.consumer_key       = @CONSUMER_KEY
    config.consumer_secret    = @CONSUMER_SECRET
    config.oauth_token        = @OAUTH_TOKEN
    config.oauth_token_secret = @OAUTH_TOKEN_SECRET
  end
  
  todays_events.each do |event|
    tweet_msg = compose_tweet(event)
    
    tweet_msg = "[#{today_date_str}] Today is #{event.summary}"
    tweet_msg = tweet_msg + " • " + event.url.to_s if !event.url.nil? && (tweet_msg + " • " + event.url.to_s).length <= 140    
    puts tweet_msg
    #Twitter.update(tweet_msg)
  end
else  
  puts "No events today"
end









