class Integer
  
  def seconds_to_hhmm
    "#{(self < 0 ? '-' : '')}#{(self.abs/(60*60))}:#{'%02d' % ((self.abs % (60*60))/60)}"
  end
  
end