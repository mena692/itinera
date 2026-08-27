class Activity < ApplicationRecord
  belongs_to :trip_day

  def formatted_duration
    total_minutes = ((end_date - start_date) / 60).round

    if total_minutes < 60
      "#{total_minutes} #{'minute'.pluralize(total_minutes)}"
    else
      hours = total_minutes / 60.0
      hours = hours == hours.to_i ? hours.to_i : hours.round(1)
      "#{hours} #{'hour'.pluralize(hours)}"
    end
  end
end
