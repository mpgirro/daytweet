#!/usr/bin/env ruby
# -*- encoding : utf-8 -*-

require 'rubygems' 
require 'icalendar'
require 'date'
require 'twitter'
require 'shorturl'
require 'parseconfig'


# location of config file
CONFIG_FILE = "daytweet.conf" # you may want to change this


# returns array of all events happening today
# (= date of running program)
def today_events

    # open icalendar file
    cal_file = nil
    begin
        cal_file = File.open(@ICAL_FILE, "r")
    rescue
        puts "Error trying to open ical file: #{$!.message}" 
        return []
    end
    
    # get the calendar object
    cals = Icalendar.parse(cal_file)
    cal = cals.first
    
    # make array of all the events that are today
    events = []
    cal.events.each do |event|
        events << event if event.dtstart.to_s == DateTime.now.strftime("%Y-%m-%d")
    end
    
    return events
end


# reads the config params from the config file
def parse_configs

    config = ParseConfig.new(CONFIG_FILE)
    
    @CONSUMER_KEY        = config['consumer_key']
    @CONSUMER_SECRET     = config['consumer_secret']
    @OAUTH_TOKEN         = config['oauth_token']
    @OAUTH_TOKEN_SECRET  = config['oauth_token_secret']
    @ICAL_FILE           = config['ical_file']
end


# tweets msg using the keys and tokens from config file
def tweet(msg)

    Twitter.configure do |config|
      config.consumer_key       = @CONSUMER_KEY
      config.consumer_secret    = @CONSUMER_SECRET
      config.oauth_token        = @OAUTH_TOKEN
      config.oauth_token_secret = @OAUTH_TOKEN_SECRET
    end

    Twitter.update(msg)
end


# makes a message string fitting the 140 character limit
# if an event has a url attached, it will be appended, if 
# it does not supersize 140. if it does, it will be shortened.
# if this fails, the url will not be appended
def tweet_msg(event)

    msg = "Today is " + event.summary
    if event.url != nil
        
        url_msg = msg + " • " + event.url.to_s
        
        # if url makes tweet to long, try url shortening
        if url_msg.length > 140
            
            url_msg = msg # remove this after fix!
            
            """ SyntaxError on LINUX systems with ShortURL gem
            begin 
                url_msg = msg + ' • ' + ShortURL.shorten(event.url, :tinyurl)
            rescue  # the url shortener broke. again...
                url_msg = msg
            else # hey it worked
                if url_msg.length > 140
                    url_msg = msg # still too long
                end
            end
            """
        end
        
        msg = url_msg
    end

    return msg
end


# program entry point
# - - - - - - - - - - 

parse_configs

events = today_events 

# tweet every event of today
if events.empty? == false
    events.each do |e|
        msg = tweet_msg(e)
        puts msg
        tweet(msg)
    end
else
    puts "No events today"
end




