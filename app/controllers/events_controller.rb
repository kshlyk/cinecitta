class EventsController < Spree::BaseController

  layout 'school'

  def calendar
    @date = params[:month].present? ? Date.parse("1.#{params[:month]}") : Date.today
    @events = Event.where('date BETWEEN ? AND ?', @date.beginning_of_month.beginning_of_week, @date.end_of_month.end_of_week).order(:date)
  end

end
