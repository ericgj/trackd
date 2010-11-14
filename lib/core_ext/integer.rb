class Integer
  
  def seconds_to_hhmm
    "#{'%02d' % (self/(60*60))}:#{'%02d' % ((self % (60*60))/60)}"
  end
  
end