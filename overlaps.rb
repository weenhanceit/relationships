# Monkey-patch class Range. Some people don't like you doing this. :-)
class Range
  # if self ends before the other begins, or the other ends before self
  # begins, then they *don't* overlap. So return the negation of the
  # previous sentence
  # This assumes the end of the range is included in the range, what
  # mathematicians call a closed interval, I believe.
  # That's a good assumption for ranges that are dates, but not necessarily
  # for ranges that are time intervals.
  def overlaps?(other)
    ! (self.end < other.begin || other.end < self.begin)
  end
end
