module ApplicationHelper
  def entry_permalink(e)
    d = e.created_at
    entry_permalink_path :year => d.year, :month => d.month, :day => d.day, :slug => e.permalink
  end


  def link_to_cart(text = t('cart'))
    #return "" if current_page?(cart_path)
    css_class = nil
    if current_order.nil? or current_order.line_items.empty?
      text = "#{text}"
      css_class = 'empty'
    else
      text = "#{text}"
      css_class = 'full'
    end
    link_to text, cart_path, :class => css_class
  end



  def timetable
    timetable = "";
    params["month"] = Date.today.month unless params["month"]
    params["year"] = Date.today.year unless params["year"]
    require 'net/http'
    h = Net::HTTP.new("www.artbanda.com", 80)
    h.read_timeout = 500
    resp = h.get("/school/timetable/?month=#{params["month"]}&year=#{params["year"]}",nil)
    timetable = Iconv.iconv('utf-8', 'windows-1251',  resp.read_body).to_s.match(/(<table)([^>]*)(class="cld_month">)(.*?)(<\/table>)/)
    pre_link = Iconv.iconv('utf-8', 'windows-1251',  resp.read_body).to_s.match(/(<a class="prev" href=")([^">]*)(">&larr; )(.*?)(<\/a>)/)
    next_link = Iconv.iconv('utf-8', 'windows-1251',  resp.read_body).to_s.match(/(<a class="next" href=")([^">]*)(">)(.*?)( &rarr;<\/a>)/)
    "<table class='timetable'>#{timetable[4].html_safe.gsub(/h1/,'b').gsub(/font:14px arial;/, 'font:14px arial; text-align: center;').gsub(/style="font: 12px arial;"/,'').gsub(/span><span class="title"/, 'span><br/><span class="cld_title"')}</table><a class='pre_school_link' href='/school/timetable#{pre_link[2]}'>&larr; #{pre_link[4]}</a><a class='next_school_link' href='/school/timetable#{next_link[2]}'>#{next_link[4]}&rarr;</a>".html_safe
  end
end
