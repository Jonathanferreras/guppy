require "date"

module ApplicationHelper
  def format_time(timestamp)
    datetime = DateTime.parse(timestamp)
    formatted_time = datetime.strftime("%H:%M:%S %m/%d/%y")
    formatted_time
  end
end
