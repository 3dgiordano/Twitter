require_relative 'twitter_api'
require_relative 'twitter_crawler'

def get_links(text)
  url_regexp = /(ht|f)tp(s?):\/\/\w/
  text.split.grep(url_regexp)
end

def ask_number(from, to, prompt)
  option_selected = -1
  while true
    print "#{prompt} [#{from}..#{to}]: "
    option_selected = gets.strip.to_i
    if option_selected.between?(from, to)
      return option_selected
    end
  end
  
end

trends = TwitterAPI.get_trends
print "\n\nTwitter Trends Topics - David Giordano\n\n"

puts "-------------\n"

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

  twit_info = TwitterAPI.get_twit_by_id(twitts_trend["results"][option]["id"])
  user_info = TwitterAPI.get_user_information_by_id(twit_info["user"]["id"])

  puts "@#{user_info["screen_name"]} \"#{user_info["name"]}\" Followers[#{user_info["followers_count"]}] #{twit_info["created_at"]}\n"
  puts "\n#{twit_info["text"]}\n"

  links = get_links(twit_info["text"])
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

