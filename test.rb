require_relative 'twitter_api'
require_relative 'twitter_crawler'
require_relative 'utils'
require_relative 'twitter'
require_relative 'user'
require_relative 'twit'

print "\n\nTwitter Trends Topics - David Giordano\n\n"

puts "-------------\n"

twitter = Twitter.new
trends = twitter.get_trends

trends.each{|e|
  e["trends"].each_with_index.map{|t, index|
    print "  #{index} : Name:#{t["name"]}\n"
  }
  option = ask_number(0, e["trends"].length-1, "\nSelect Trend Topic:")

  puts "-------------\n\n"
 
  twitts_trend = TwitterAPI.get_twits_for_trend(e["trends"][option]["query"])

  twitts_trend["results"].each_with_index.map{|r, index|
    print "  #{index} : Twitt: #{r["text"][0,60]}...\n"
  }

  option = ask_number(0, twitts_trend["results"].length-1, "\nSelect Twitt:")

  puts "-------------\n\n"

  twit = Twit.new(twitts_trend["results"][option]["id"])
  user = User.new(twit.user_id)

  puts "@#{user.screen_name} \"#{user.name}\" Followers[#{user.followers_count}] #{twit.created_at}\n"
  puts "\n#{twit.text}\n"

  links = twit.links
  if links.length > 0
    puts "\nLinks:\n"

    links.each_with_index.map{|l, index|
       print "  #{index} : #{l[0,60]}\n"
    }
    option = ask_number(0, links.length-1, "\nSelect Link:")

    puts "\nLink selected:", links[option], "\n"
    puts "-------------\n\n"
    puts TwitterCrawler.get_crawled_body(links[option])

  end
  puts "-------------\n\n"

}

