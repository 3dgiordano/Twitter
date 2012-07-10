
module Utils

  def self.get_links(text)
    url_regexp = /(ht|f)tp(s?):\/\/\w/
    text.split.grep(url_regexp)
  end

  def self.ask_number(from, to, prompt)
    option_selected = -1
    while true
      print "#{prompt} [#{from}..#{to}]: "
      option_selected = gets.strip.to_i
      if option_selected.between?(from, to)
        return option_selected
      end
    end
  end

end
