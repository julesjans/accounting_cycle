module AccountingCycle

  module Financial
    
    class Year < AccountingCycle::Year
      extend AccountingCycle::Settings
      extend AccountingCycle::Compare::ClassMethods
    end
    
    class Period < AccountingCycle::Period
      
    end

  end

end