require "sinatra"
require "feedalizer"
require "time"
require "kconv"

get "/" do
  begin
    url = "http://zozo.jp/news/"
    rss = feedalize(url + "list_order.html") do
      feed.title = "ZOZOTOWN NEW!"
      feed.about = "zozotown"
      feed.description = "ZOZOTOWN"

      scrape_items("div.listOrderBox ul.cf li") do |item, li|
        a = (li/"dl dd div.label a").first
        date = Time.parse( "20" + (li/"p.date").first.inner_html)

        item.link = url + a.attributes['href']
        item.date = date
        item.title = a.inner_html.toutf8.strip
        content = li.inner_html.toutf8
        content.gsub! /\?w=[0-9]+&h=[0-9]+/, ""
        content.gsub! /(width|height)="[0-9]+"/, ""
        item.description = content
      end
    end
    content_type :rss
    rss.output
  rescue => e
    "Error"
  end
end
