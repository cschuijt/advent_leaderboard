# Adding another method to TimeWithZone to be able to change this formatting
# across the entire app without having to track down 900 strftime calls.

class ActiveSupport::TimeWithZone
  def to_scoreboard_format
    self.strftime('%e %b, %H:%M:%S')
  end
end

class Time
  def to_time_taken
    self.strftime('%-Hh, %-Mm, %-Ss')
  end
end
