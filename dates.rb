class So
  attr_reader :dob

  def dob_string
    @dob_string || (dob ? dob.strftime("%m/%d/%Y") : "")
  end

  def dob=(other)
    case other
    when Date
      @dob = other
    when Time, DateTime
      @dob = other.to_date
    else
      raise ArgumentError # , "Must be Date, Time, or DateTime, was #{other.class}"
    end
  end

  def dob_string=(dob_s)
    # I assume you only want to assign @dob_string if it was a valid date
    unless convert_preferred_date(dob_s) || convert_acceptable_date(dob_s)
      puts "Oops!"
      # errors.add(:dob, 'The birth date is not in the correct format (MM/DD/YYYY)')
      @dob_string = dob_s
    end
    dob
  end

  private

  def convert_preferred_date(dob_s)
    convert_date(dob_s, "%m/%d/%Y")
  end

  def convert_acceptable_date(dob_s)
    convert_date(dob_s, "%m-%d-%Y")
  end

  def convert_date(dob_s, format)
    puts "convert_date format #{format}"
    self.dob = (dob_s && !dob_s.empty? ? Date.strptime(dob_s, format) : nil)
  rescue ArgumentError
    nil
  end
end
