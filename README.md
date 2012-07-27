# daytweet

daytweet is a Twitter Bot that informs you of (maybe unofficial or fictional) observances/holidays and awareness days

You definitely should [follow it on Twitter](http://twitter.com/daytweet).

This programs repository may be found on [github](http://github.com/mpgirro/daytweet).

## Database

In order to make some dates easy to save it does not use an ordenary database. Instead the events are stored in an iCalendar (daytweet.ics) file. It makes life with stuff like "last friday in November" much easier. You can use the file and add it to your favourite calendar program if you want to look ahead what is comming next. Every date has a URL attached if found any useful. They are mainly Wikipedia articles.

## Tweet Style

The Tweets appear in the syntax 'Today is {event name} [• event url]'
Not every event has a URL provided. If the URL would extend the tweets over 140 characters, daytweet trys to use an URL Shortener. If, however improbable, this would still supersize 140 characters, the URL would not be appended to the event notification.

## Requirements

There are a few Ruby Gems that needs to be installed before daytweet can be run. 

The required gems are: twitter, shorturl, icalendar, parseconfig
They may be installed with these commands:

    sudo gem install icalendar
    sudo gem install twitter
    sudo gem install shorturl
    sudo gem install parseconfig
    
## Configuration file

In order to post stuff in Twitter, an application needs consumer and oauth token/secrets. See [Twitter Developer](http://dev.twitter.com) for information on how you can get those.

daytweet expects those information in a configuration file called daytweet.conf. See the provided example.conf on how this file should look like. The file is expected in the same directory as daytweet.rb. This can be changed by altering the constant CONFIG_FILE within daytweet.rb.

## Operation

    ./daytweet.rb
    
This will post all todays events on Twitter. Therefore this program must be run once a day, every day. It should not take more than a moment. In order to do this automatically, it is recommended to use a [cronjob](http://en.wikipedia.org/wiki/Cron) or a [runwhen entry](http://code.dogmap.org/runwhen/).

