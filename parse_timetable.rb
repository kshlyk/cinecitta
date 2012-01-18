#!/usr/bin/env ruby1.8
# -*- encoding:utf-8 -*-
require 'rubygems'
require 'iconv'
require 'open-uri'
require 'hpricot'
require 'config/environment'

puts "All loaded ............... Lets GO!"
added_count = 0;

Event.delete_all

(2011..Time.now.year).each do |year|
  (9..12).each do |month|
    @url = "http://www.artbanda.com/school/timetable/?month=#{month}&year=#{year}"
    printf "Loading #{@url} ........"
    if @hp = Hpricot(open(@url))
      i=0;
      (@hp/'td.cld_').each do |td|
        (td/"div.day_event").each do |event|
          title = Iconv.iconv('utf-8', 'windows-1251', (event/"span.title").inner_html).to_s
          time = (event/"span.time").inner_html.to_s
          date = Date.parse("#{year}/#{month}/#{(td/"p.date").inner_html}", "%Y/%m/%d")
          puts title
          Event.create({:title=>title, :begin_event=>date})
          added_count+=1; i+=1;
  #        puts "#{date} : #{time} : #{title}"
        end
      end
      printf "DONE  #{i}\n"
    else
      printf "FAILED\n"
    end
    
  end #EO month cicle
end # EO years cicle

puts "All parsed. Total records: #{added_count}"



