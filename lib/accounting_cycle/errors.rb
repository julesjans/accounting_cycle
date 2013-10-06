module AccountingCycle
  
  class CycleAlreadySet < StandardError
    def message
      "The accounting cycle has already been set. You cannot modify this at runtime."
    end
  end
  
  class InvalidPeriodRequest < StandardError
    def message
      "Iteration through the requested periods has failed."
    end
  end

  class InvalidPeriodCount < StandardError
    def message
      "The accounting cycle period count you have chosen is invalid, please choose a number that divides 12 (months) into a whole number."
    end
  end
  
  class InvalidComparison < StandardError
    def message
      "Only compare periods that belong to the same scope, i.e. VAT or financial."
    end
  end

  class PeriodError < StandardError
    def message
      "The periods you comparing are not the same."
    end
  end
  
  class MultiplePeriodError < StandardError
    def message
      "The periods you comparing are not the same."
    end
  end
  
  class YearError < StandardError
    def message
      "The periods you comparing are not the same."
    end
  end

end