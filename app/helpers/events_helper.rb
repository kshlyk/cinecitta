module EventsHelper
  def calendar(date = Date.today, &block)
    Calendar.new(self, date, block).table
  end

  def previous_events_month_link(date)
    date = date.prev_month
    link_to "&#8592; #{l(date, :format => '%B')}".html_safe, events_calendar_path(date.month == Date.today.month ? nil : date.strftime('%m.%Y')), :class => 'previous'
  end

  def next_events_month_link(date)
    date = date.next_month
    link_to "#{l(date, :format => '%B')} &#8594; ".html_safe, events_calendar_path(date.month == Date.today.month ? nil : date.strftime('%m.%Y')), :class => 'next'
  end

  class Calendar < Struct.new(:view, :date, :callback)
    delegate :content_tag, :to => :view
    delegate :t, :to => :view

    def table
      content_tag :table, :class => 'calendar' do
        header + week_rows
      end
    end

    def header
      content_tag :tr do
        cols = []
        %w(mon tue wed thu fri sat sun).each_with_index do |day, i|
          cols << content_tag(:th, t('date.standalone_day_names')[i == 6 ? 0 : (i + 1)])
        end
        cols.join.html_safe
      end
    end

    def week_rows
      weeks.map do |week|
        content_tag :tr do
          week.map { |day| day_cell(day) }.join.html_safe
        end
      end.join.html_safe
    end

    def day_cell(day)
      content_tag :td, view.capture(day, &callback), :class => day_classes(day)
    end

    def day_classes(day)
      classes = []
      classes << 'today' if day == Date.today
      classes << 'other-month' if day.month != date.month
      classes.empty? ? nil : classes.join(' ')
    end

    def weeks
      first = date.beginning_of_month.beginning_of_week
      last = date.end_of_month.end_of_week
      (first..last).to_a.in_groups_of(7)
    end
  end
end