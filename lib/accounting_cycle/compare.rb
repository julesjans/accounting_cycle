module AccountingCycle
  
  # TODO: compare parameters by class:
  # args.each     {|a| raise InvalidComparison unless self.to_s.include? a.parent_class.to_s }  

  module Compare
    
    def ==(other)
      raise AccountingCycle::InvalidComparison unless other.class == self.class
      self.start == other.start && self.finish == other.finish
    end
    
    def same_period_as?(*args)
      args.collect! {|a| a.instance_of?(Date) ? self.parent_class('year').period_for_date(a) : a }
      args.all? {|a| a == self} ? true : false  
    end
    
    def count_periods_between(*args)
      unless same_period_as?(*args)
        args.collect! {|a| a.instance_of?(Date) ? self.parent_class('year').period_for_date(a) : a }
        args << self
        args.sort! {|a, b| a.start <=> b.start}
        
        first = args.first
        last  = args.reverse.first
        
        count = 0
        until first == last
          
          # TODO: break, there is a better way to handle this...
          raise AccountingCycle::InvalidPeriodRequest if count > 1000

          first = first.next_period
          count +=1
        end      
        count
      end
    end
    
    def check_period!(*args)
      # TODO: neaten this up a little
      # Class method?
      args.collect! {|a| a.instance_of?(Date) ? self.parent_class('year').period_for_date(a) : a }
      args.sort!    {|a, b| a.start <=> b.start}
      raise AccountingCycle::YearError if self.year.start != args.reverse.first.year.start
      
      unless args.all? {|a| a == self}
        period_count = self.parent_class('year').period_count 
        count        = count_periods_between(*args)
        case     
        when count > 1
          raise AccountingCycle::MultiplePeriodError
        when count > 0
          raise AccountingCycle::PeriodError
        end 
      end
    end    
    
    module ClassMethods
    
      def same_periods?(*args) 
        sort_args(args)  
        # TODO: As this class method does not compare all the instances, must check here and throw exception.
        args.each     {|a| raise InvalidComparison unless self.to_s.include? a.parent_class.to_s } 
        args.all?     {|a| a == args[0]} ? true : false      
      end
    
      def count_periods_between(*args)        
        sort_args(args)
        args.first.count_periods_between(args.reverse.first)
      end
      
      def check_periods!(*args)
        sort_args(args)
        args.first.check_period!(args.reverse.first)
      end
      
      private
      
      def sort_args(args)
        args.collect! {|a| a.instance_of?(Date) ? self.period_for_date(a) : a }
        args.sort!    {|a, b| a.start <=> b.start}
        args
      end
      
    end
        
  end

end