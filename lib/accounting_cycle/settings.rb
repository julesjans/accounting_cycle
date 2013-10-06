module AccountingCycle

  module Settings
    
    def config(&block)
      instance_eval &block
      @set = true
    end
    
    def month
      @month || 1
    end
  
    def day
      @day || 1
    end
  
    def period_count
      @period_count || 4
    end
    
    protected
    
    def set?
      @set
    end
    
    def set=(set)
      @set = set
    end
    
    def month=(month)
      raise CycleAlreadySet if set?
      @month = month
    end
    
    def day=(day)
      raise CycleAlreadySet if set?
      @day = day
    end
    
    def period_count=(period_count)
      raise CycleAlreadySet if set?
      raise InvalidPeriodCount unless 12.modulo(period_count).zero?
      @period_count = period_count
    end

  end
  
end