module AccountingCycle

  module Vat
    
    class Year < AccountingCycle::Year
      extend AccountingCycle::Settings
      extend AccountingCycle::Compare::ClassMethods
    end
    
    class Period < AccountingCycle::Period

    end

  end

end