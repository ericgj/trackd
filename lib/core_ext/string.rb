class String

  def hhmm_to_seconds
    return unless self =~ /(-*)(\d+):(\d\d)/
    ($1 == '-' ? -1 : 1) * ($2.to_i*60*60 + $3.to_i*60)
  end
  
end