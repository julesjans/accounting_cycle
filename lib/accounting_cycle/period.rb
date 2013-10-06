module AccountingCycle

  class Period
    
    include AccountingCycle::Compare
    include AccountingCycle::Helpers
  
    attr_accessor :id, :start, :finish, :year, :name
  
    def initialize(id, start, finish, year)
      @start  = start
      @finish = finish
      @year   = year
      @id     = id
      @name   = "#{year.name} (#{id})"
    end
  
    def next_period(count=1)
      year    = self.parent_class('year').year_for_date(finish)
      periods = year.periods
      index   = periods.index(self)
      period  = self.dup
      count.times do
        index += 1
        if (index) == periods.size
          if (AccountingCycle::Vat::Year.day == 1 && AccountingCycle::Vat::Year.month == 1) 
            periods += self.parent_class('year').new(period.start.year + 1).periods 
          else
            periods += self.parent_class('year').new(period.finish.year).periods 
          end
        end
        period = periods.at(index)  
      end
      period
    end
  
    def prev_period(count=1)      
      periods = self.parent_class('year').year_for_date(start).periods.reverse
      index   = periods.index(self)
      period  = self.dup
      count.times do
        index += 1
        if (index) == periods.size
          periods += self.parent_class('year').new(period.start.year - 1).periods.reverse 
        end
        period = periods.at(index)  
      end
      period
    end
  
  end

end