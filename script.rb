require './htmlentities'
require './commands'
# require './related_words'

def item_xml(options = {})
  <<-ITEM
  <item arg="#{options[:arg]}" uid="#{options[:uid]}">
    <title>#{options[:title]}</title>
    <subtitle>#{options[:subtitle]}</subtitle>
  </item>
  ITEM
end

def match?(word, query)
  word.match(/#{query}/i)
end

query = Regexp.escape(HTMLEntities.new.decode(ARGV.first))

# matches = RELATED_WORDS.select { |k, v| match?(k, query) || v.any? { |r| match?(r, query) } }
matches = COMMANDS.select { |k, v| match?(k, query) || match?(v, query) }

items = matches.sort.map do |key, value|
  title = "#{key}: #{value}"
  arg = ARGV.size > 1 ? COMMANDS.fetch(key, command) : value
  #item_xml({ :arg => arg, :uid => value, :title => title, :subtitle => "Copy #{arg} to clipboard" })
  item_xml({ :arg => arg, :uid => value, :title => title, :subtitle => value })
end.join

output = "<?xml version='1.0'?>\n<items>\n#{items}</items>"

puts output