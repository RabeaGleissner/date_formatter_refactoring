require "date"
require "fixnum"

class DateRangeFormatter
  def initialize(start_date, end_date, start_time = nil, end_time = nil)
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @start_time = start_time
    @end_time = end_time
    @full_start_date = @start_date.strftime("#{@start_date.day.ordinalize} %B %Y")
    @full_end_date = @end_date.strftime("#{@end_date.day.ordinalize} %B %Y")
  end

  def to_s
    if @start_date == @end_date
      if @start_time && @end_time
        "#{@full_start_date} at #{@start_time} to #{@end_time}"
      elsif @start_time
        "#{@full_start_date} at #{@start_time}"
      elsif @end_time
        "#{@full_start_date} until #{@end_time}"
      else
        @full_start_date
      end
    elsif @start_date.month == @end_date.month && @start_date.year == @end_date.year
      get_date_range(:same_month)
    elsif @start_date.year == @end_date.year
      get_date_range(:same_year)
    else
      get_date_range(:default)
    end
  end

  private

  def get_date_range(option)
    range_for_option = {
      default: "#{@full_start_date} - #{@full_end_date}",
      same_year:
        @start_date.strftime("#{@start_date.day.ordinalize} %B - ") + @end_date.strftime("#{@end_date.day.ordinalize} %B %Y"),
        same_month: @start_date.strftime("#{@start_date.day.ordinalize} - #{@end_date.day.ordinalize} %B %Y"),
    }
    if @start_time && @end_time
      full_dates_with_both_times
    elsif @start_time
      full_dates_with_start_time
    elsif @end_time
      full_dates_with_end_time
    else
      range_for_option[option]
    end
  end

  def full_dates_with_start_time
    "#{@full_start_date} at #{@start_time} - #{@full_end_date}"
  end

  def full_dates_with_end_time
    "#{@full_start_date} - #{@full_end_date} at #{@end_time}"
  end

  def full_dates_with_both_times
    "#{@full_start_date} at #{@start_time} - #{@full_end_date} at #{@end_time}"
  end
end
