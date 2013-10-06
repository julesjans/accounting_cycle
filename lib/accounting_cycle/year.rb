module AccountingCycle
  
  class Year
    
    include AccountingCycle::Compare
    include AccountingCycle::Helpers
    
    attr_accessor :name, :start, :finish, :year
  
    def initialize(year)
      @year = year
      @start  = Date.civil(self.year, self.class.month, self.class.day)
      @finish = (@start >> 12) - 1
      @name = @start.year == @finish.year ? "#{@start.year}" : "#{@start.year}/#{@finish.year}" 
    end
    
    def next_year(count=1)
      self.class.new(self.year + count)
    end
    
    def prev_year(count=1)
      self.class.new(self.year - count)
    end

    def periods
      divisor = (12 / self.class.period_count)
      periods = self.class.period_count.times.each_with_index.collect do |quarter, index|
        period_start = (self.start >> (divisor * index))
        period_end   = (period_start >> divisor) - 1      
        self.parent_class('period').new((index + 1), period_start, period_end, self)
      end
    end
  
    def self.year_for_date(date)
      ((date.year - 1)..(date.year + 1)).each do |year|
        this_year = self.new(year)
        return this_year if date >= this_year.start && date <= this_year.finish
      end
    end
  
    def self.period_for_date(date)  
      year_for_date(date).periods.find do |period|
        date >= period.start && date <= period.finish
      end
    end
    
  end
  
end