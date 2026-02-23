class SouthUtility < Utility
  def word_count_thresholds
    { short: 60, medium: 120 }
  end

  def review_max_words
    60
  end
end
