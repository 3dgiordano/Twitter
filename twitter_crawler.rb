require "net/http"
require 'nokogiri'

module TwitterCrawler

  def self.get_crawled_body(from_url)

    result = self.get_http_response(from_url)

    response = result["response"]
    to_url = result["url"]

    doc = Nokogiri::HTML(response.body)
    host = URI.parse(to_url).host

    case host
    when "yfrog.com" 
         image = doc.xpath("//meta[@property='og:image']").first['content']
         self.get_image2text(image)
    when "instagr.am"
         image = doc.xpath("//img[@class='photo']").first['src']
         self.get_image2text(image)
    #when Twitvid Twitpic MobyPicture Lockerz <- others services to analize
    else
        self.get_html2text(to_url)
    end
  end

  def self.get_image2text(image)
    result = self.get_http_response("http://skeeter.blakesmith.me/?image_url=#{URI.escape(image)}&width=80") 
    puts "\nImage URL:\n#{image}\n"
    result["response"].body
  end

  def self.get_html2text(url)
    result = self.get_http_response("http://html2text.theinfo.org/?url=#{URI.escape(url)}")
    puts "\nHTML URL:\n#{url}\n"
    return result["response"].body if result["response"].body.strip.length > 0
    self.get_http_response(url)["response"].body
  end

  def self.get_http_response(url)
    
    found = false 
    until found
      response = Net::HTTP.get_response(URI.parse(URI.encode(url.strip))) 
      response.header['location'] ? url = response.header['location']: 
      found = true 
    end 

    return {"url" => url, "response" => response}
  end

end
