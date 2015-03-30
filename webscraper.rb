require 'rubygems'
require 'nokogiri'
require 'open-uri'

BASE_WIKIPEDIA_URL = "http://en.wikipedia.org"
AWARDS_URL = "#{BASE_WIKIPEDIA_URL}/wiki/Academy_Award_for_Best_Picture"
HEADERS_HASH = {"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.104 Safari/537.36"}
UK_POUND_EXCHANGE_RATE = 1.48

begin
	File.open("output.txt", 'w') do |file|
		page = Nokogiri::HTML(open(AWARDS_URL, HEADERS_HASH))

		winner_rows = page.css("div.mw-content-ltr table.wikitable tr:eq(2)") 

		budget_total = 0
		film_count = 0

		winner_rows.each do |row|
			 hrefs = row.css("td:eq(1) a[href^='/wiki']").map{|a| a['href']}

			 hrefs.each do |href|
			 	winner_link_url = BASE_WIKIPEDIA_URL + href
			 	wiki_film_page = Nokogiri::HTML(open(winner_link_url, HEADERS_HASH))

			 	#----Title extraction----
			 	title = wiki_film_page.css('table.infobox th.summary').first.text
			 	title = title.strip.gsub(/\r\n|\n|\r/," ")

			 	#----Film Award Year extraction----
			 		award_year = row.ancestors("table").first.css("caption big").text
			 		award_year = award_year.match(/\d{4}(?:\/\d{2})?/)[0]

			 	#----Budget extraction----
			 	budget = wiki_film_page.css('table.infobox tr:contains("Budget") td').text.strip.gsub("\u00A0", " ")
			 	budget = "Not Available" if budget ==""

			 	case budget
			 	when /\$/
				 	exchange_rate, currency_symbol = 1.0, "\\$"
				when /£/
				 	exchange_rate, currency_symbol = UK_POUND_EXCHANGE_RATE, "£"
				end

			 	budget_amount_match = budget.match(/#{currency_symbol}([\d,.]+)(?:[\–\-])?(\d)?\s?(million)?/i)

			 	if !budget_amount_match.nil?
			 		if budget_amount_match[3].nil? #use amount as is
			 			budget_total += budget_amount_match[1].gsub(/[^\d^\.]/, '').to_f * exchange_rate
			 		else
			 			if budget_amount_match[2].nil? #amount in millions
			 				budget_total += (budget_amount_match[1].to_f * 1000000 * exchange_rate) if budget_amount_match[3].downcase == "million"
			 			
			 			else #amount in millions range
			 				range_avg = (budget_amount_match[2].to_f + budget_amount_match[1].to_f)/2
			 				budget_total += (range_avg * 1000000 * exchange_rate) if budget_amount_match[3].downcase == "million"
			 			end
			 		end
			 		budget = budget_amount_match[0].gsub(/[^0-9Nn]$/,"")
					film_count += 1
			 	end

			 	puts "Year: #{award_year} | Title: #{title} | Budget: #{budget}"
			 	file.write("Year: #{award_year} | Title: #{title} | Budget: #{budget}\n")
			 	sleep 0.1 + rand #wait a little for each link request
			 end
		end
		#----Average film budget calculation
			average_budget = (budget_total / film_count).round
			average_budget = average_budget.to_s.reverse.scan(/\d{3}|.+/).join(",").reverse
		puts "Average film budget: $#{average_budget}"
		file.write("Average film budget: $#{average_budget}\n")
	end
rescue => e
	puts "Something isn't right....Error: #{e}"
end # done: begin/rescue
