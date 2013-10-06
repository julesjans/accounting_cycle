require 'test/unit'
require 'accounting_cycle'

class TestCompare < Test::Unit::TestCase

  def test_comparisons_of_different_cycles_in_class_methods
    assert_raise(AccountingCycle::InvalidComparison) do
      periods = AccountingCycle::Vat::Year.new(Date.today.year).periods
      AccountingCycle::Financial::Year.same_periods?(periods[0], periods[0])
    end
    assert_raise(AccountingCycle::InvalidComparison) do
      periods = AccountingCycle::Financial::Year.new(Date.today.year).periods
      AccountingCycle::Vat::Year.same_periods?(periods[0], periods[0])
    end
    assert_nothing_raised do
      periods = AccountingCycle::Financial::Year.new(Date.today.year).periods
      AccountingCycle::Financial::Year.same_periods?(periods[0], periods[0])
    end
    assert_nothing_raised do
      periods = AccountingCycle::Vat::Year.new(Date.today.year).periods
      AccountingCycle::Vat::Year.same_periods?(periods[0], periods[0])
    end
    assert_raise(AccountingCycle::InvalidComparison) do
      periods1 = AccountingCycle::Vat::Year.new(Date.today.year).periods
      periods2 = AccountingCycle::Financial::Year.new(Date.today.year).periods
      AccountingCycle::Financial::Year.same_periods?(periods1[0], periods2[0])
    end
    assert_raise(AccountingCycle::InvalidComparison) do
      periods1 = AccountingCycle::Vat::Year.new(Date.today.year).periods
      periods2 = AccountingCycle::Financial::Year.new(Date.today.year).periods
      AccountingCycle::Financial::Year.check_periods!(periods1[0], periods2[0])
    end
    assert_raise(AccountingCycle::InvalidComparison) do
      periods1 = AccountingCycle::Vat::Year.new(Date.today.year).periods
      periods2 = AccountingCycle::Financial::Year.new(Date.today.year).periods
      AccountingCycle::Financial::Year.count_periods_between(periods1[0], periods2[0])
    end
  end
  
  def test_comparisons_of_different_cycles_in_instance_methods
    vat_periods = AccountingCycle::Vat::Year.new(Date.today.year).periods
    fin_periods = AccountingCycle::Financial::Year.new(Date.today.year).periods
    assert_raise(AccountingCycle::InvalidComparison) do
      vat_periods[0].same_period_as?(fin_periods[0])
    end
    assert_nothing_raised do
      vat_periods[0].same_period_as?(vat_periods[0])
    end
    assert_raise(AccountingCycle::InvalidComparison) do
      vat_periods[0].count_periods_between(fin_periods[0])
    end
    assert_nothing_raised do
      vat_periods[0].count_periods_between(vat_periods[0])
    end
    assert_raise(AccountingCycle::InvalidComparison) do
      vat_periods[0].check_period!(fin_periods[0])
    end
    assert_nothing_raised do
      vat_periods[0].check_period!(vat_periods[0])
    end
  end
  
  def test_same_period_as_with_periods
    periods = AccountingCycle::Financial::Year.new(Date.today.year).periods
    assert(periods[0].same_period_as?(periods[0]))
    assert(periods[0].same_period_as?(periods[0], periods[0]))
    assert(!periods[0].same_period_as?(periods[0].next_period.start))
    assert(!periods[0].same_period_as?(periods[0].prev_period.finish))
    assert(!periods[0].same_period_as?(periods[0].next_period.start, periods[0].next_period.next_period.start))
  end
  
  def test_same_period_as_with_dates
    date   = Date.today
    period = AccountingCycle::Financial::Year.period_for_date(date)
    assert(period.same_period_as?(date))
    assert(!period.same_period_as?(period.next_period.start))
    assert(!period.same_period_as?(period.prev_period.finish)) 
  end
  
  def test_same_period_as_with_periods_and_dates
    date   = Date.today
    period = AccountingCycle::Financial::Year.period_for_date(date)
    assert(period.same_period_as?(date, period))
    assert(!period.same_period_as?(period.next_period.start, period.prev_period))
  end
  
  def test_count_periods_between
    # TODO: fail if negative number
    date   = Date.today
    period = AccountingCycle::Financial::Year.period_for_date(date)
    assert_equal(period.count_periods_between(period.next_period), 1)
    assert_equal(period.count_periods_between(period.prev_period), 1)
    (1..20).each do |i|
      assert_equal(period.count_periods_between(period.next_period(i)), i)
      assert_equal(period.count_periods_between(period.prev_period(i)), i)
    end 
  end
  
  def test_check_period!
    date   = Date.today
    period = AccountingCycle::Financial::Year.period_for_date(date)
    assert_raise(AccountingCycle::YearError) do
      period.check_period!(period.next_period(AccountingCycle::Financial::Year.period_count))
      period.check_period!(period.next_period(AccountingCycle::Financial::Year.period_count).start)
      period.check_period!(period.prev_period(AccountingCycle::Financial::Year.period_count).finish)
    end
    assert_nothing_raised do
      period.check_period!(period)
      period.check_period!(period.start)
      period.check_period!(period.finish)
      period.check_period!(period.finish, period.start)
    end
  end
  
  def test_class_method_same_periods
    periods = AccountingCycle::Financial::Year.new(Date.today.year).periods
    assert(AccountingCycle::Financial::Year.same_periods?(periods[0], periods[0]))
    assert(AccountingCycle::Financial::Year.same_periods?(periods[0], periods[0].start))
    assert(AccountingCycle::Financial::Year.same_periods?(periods[0], periods[0].finish))
    assert(!AccountingCycle::Financial::Year.same_periods?(periods[0], periods[0].next_period.start))
    assert(!AccountingCycle::Financial::Year.same_periods?(periods[0], periods[0].prev_period.finish))
    assert(!AccountingCycle::Financial::Year.same_periods?(periods[0], periods[0].next_period.start, periods[0].next_period.next_period.start))
  end
  
  def test_class_method_count_periods_between
    # TODO: fail if negative number
    date   = Date.today
    period = AccountingCycle::Financial::Year.period_for_date(date)
    assert_equal(AccountingCycle::Financial::Year.count_periods_between(period, period.next_period), 1)
    assert_equal(AccountingCycle::Financial::Year.count_periods_between(period, period.prev_period), 1)
    (1..20).each do |i|
      assert_equal(AccountingCycle::Financial::Year.count_periods_between(period, period.next_period(i)), i)
      assert_equal(AccountingCycle::Financial::Year.count_periods_between(period, period.prev_period(i)), i)
    end
  end
  
  def test_class_check_periods!
    date   = Date.today
    period = AccountingCycle::Financial::Year.period_for_date(date)
    assert_raise(AccountingCycle::YearError) do
      AccountingCycle::Financial::Year.check_periods!(period, period.next_period(AccountingCycle::Financial::Year.period_count))
      AccountingCycle::Financial::Year.check_periods!(period, period.next_period(AccountingCycle::Financial::Year.period_count).start)
      AccountingCycle::Financial::Year.check_periods!(period, period.prev_period(AccountingCycle::Financial::Year.period_count).finish)
    end
    assert_nothing_raised do
      AccountingCycle::Financial::Year.check_periods!(period, period)
      AccountingCycle::Financial::Year.check_periods!(period, period.start)
      AccountingCycle::Financial::Year.check_periods!(period, period.finish)
      AccountingCycle::Financial::Year.check_periods!(period, period.finish, period.start)
    end
  end

  def test_arbitrary_periods
    
    # Test vanilla settings, on Day today
    
    AccountingCycle::Financial::Year.config do |config|
      config.set = false
      config.month = 1
      config.period_count = 4
      config.day = 1
    end
    
    date = Date.today
    
    year = AccountingCycle::Financial::Year.new(date.year)
    
    assert_equal(year.start.to_s, "#{date.year}-01-01")
    assert_equal(year.finish.to_s, "#{date.year}-12-31")
    
    period = year.periods[0]
    
    assert_equal(period.start.to_s, "#{date.year}-01-01")
    assert_equal(period.finish.to_s, "#{date.year}-03-31")
    
    
    new_date = period.finish.next
    assert_equal(period.count_periods_between(AccountingCycle::Financial::Year.period_for_date(new_date)), 1)
    
    period = year.periods[3]
    
    assert_equal(period.start.to_s, "#{date.year}-10-01")
    assert_equal(period.finish.to_s, "#{date.year}-12-31")
    
    # Test specific day, using UK income tax periods, on a random date
    
    AccountingCycle::Financial::Year.config do |config|
      config.set = false
      config.month = 4
      config.period_count = 4
      config.day = 6
    end
    
    date = Date.new(2009,1,4)

    year = AccountingCycle::Financial::Year.year_for_date(date)
    
    assert_equal(year.start.to_s, "2008-04-06")
    assert_equal(year.finish.to_s, "2009-04-05")
    
    period = year.periods[0]
    
    assert_equal(period.start.to_s, "2008-04-06")
    assert_equal(period.finish.to_s, "2008-07-05")
    
    new_date = period.finish.next
    assert_equal(period.count_periods_between(AccountingCycle::Financial::Year.period_for_date(new_date)), 1)
    
    period = year.periods[3]
    
    assert_equal(period.start.to_s, "2009-01-06")
    assert_equal(period.finish.to_s, "2009-04-05")
    
    [AccountingCycle::Vat::Year, AccountingCycle::Financial::Year].each do |year|
      year.config do |config|
        config.set = false
        config.month = 1
        config.period_count = 4
        config.day = 1
      end
    end      
  end
  
  def test_next_period_during_first_january_quarters
    
    AccountingCycle::Vat::Year.config do |config|
      config.set          = false
      config.day          = 1
      config.month        = 1
      config.period_count = 4
    end
    
    # Get a day towards the end of a financial year:
    date_one    = Date.new(2011,12,28)
    
    # Get a day towards the beginning of the following financial year:
    date_two    = Date.new(2012,1,3)
    
    # Get a day towards the middle of the following financial year:
    date_three  = Date.new(2012,5,6)
    
    # A date in the future:
    date_four   = Date.new(2017,6,3)
    
    # A date later in the year:
    date_five   = Date.new(2012,12,15)
    
    
    assert_raise(AccountingCycle::YearError) do 
      AccountingCycle::Vat::Year.check_periods!(date_one, date_two)
    end
    assert_raise(AccountingCycle::PeriodError) do 
      AccountingCycle::Vat::Year.check_periods!(date_two, date_three)
    end
    assert_raise(AccountingCycle::MultiplePeriodError) do 
      AccountingCycle::Vat::Year.check_periods!(date_two, date_five)
    end
    assert_raise(AccountingCycle::YearError) do 
      AccountingCycle::Vat::Year.check_periods!(date_one, date_four)
    end
    
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(date_one, date_two), 1)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(date_one, date_three), 2)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(date_one, date_four), 22)
  
    period = AccountingCycle::Vat::Year.period_for_date(date_one)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(period.next_period(22), date_four), nil)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(period.next_period(22).prev_period(22), date_four), 22)
  end
  
  def test_next_period_during_first_january_thirds
    
    AccountingCycle::Vat::Year.config do |config|
      config.set          = false
      config.day          = 1
      config.month        = 1
      config.period_count = 3
    end
    
    # Get a day towards the end of a financial year:
    date_one    = Date.new(2011,12,28)
    
    # Get a day towards the beginning of the following financial year:
    date_two    = Date.new(2012,1,3)
    
    # Get a day towards the middle of the following financial year:
    date_three  = Date.new(2012,5,6)
    
    # A date in the future:
    date_four   = Date.new(2017,6,3)
    
    # A date later in the year:
    date_five   = Date.new(2012,12,15)
    
  
    assert_raise(AccountingCycle::YearError) do 
      AccountingCycle::Vat::Year.check_periods!(date_one, date_two)
    end
    assert_raise(AccountingCycle::PeriodError) do 
      AccountingCycle::Vat::Year.check_periods!(date_two, date_three)
    end
    assert_raise(AccountingCycle::YearError) do 
      AccountingCycle::Vat::Year.check_periods!(date_two, date_four)
    end
    assert_raise(AccountingCycle::MultiplePeriodError) do 
      AccountingCycle::Vat::Year.check_periods!(date_two, date_five)
    end
    
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(date_one, date_two), 1)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(date_one, date_three), 2)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(date_one, date_four), 17)

    period = AccountingCycle::Vat::Year.period_for_date(date_one)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(period.next_period(17), date_four), nil)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(period.next_period(17).prev_period(22), date_four), 22)
  end
  
  def test_next_period_during_april_quarters
    
    AccountingCycle::Vat::Year.config do |config|
      config.set          = false
      config.day          = 5
      config.month        = 4
      config.period_count = 4
    end
    
    # Get a day towards the end of a financial year:
    date_one    = Date.new(2012,3,29)
    
    # Get a day towards the beginning of the following financial year:
    date_two    = Date.new(2012,4,6)
    
    # Get a day towards the middle of the following financial year:
    date_three  = Date.new(2012,8,6)
    
    # A date in the future:
    date_four   = Date.new(2017,6,3)
    
    # A date later in the year:
    date_five   = Date.new(2013,1,12)
    
    
    assert_raise(AccountingCycle::YearError) do 
      AccountingCycle::Vat::Year.check_periods!(date_one, date_two)
    end
    assert_raise(AccountingCycle::YearError) do 
      AccountingCycle::Vat::Year.check_periods!(date_two, date_four)
    end
    assert_raise(AccountingCycle::PeriodError) do 
      AccountingCycle::Vat::Year.check_periods!(date_two, date_three)
    end
    assert_raise(AccountingCycle::MultiplePeriodError) do 
      AccountingCycle::Vat::Year.check_periods!(date_two, date_five)
    end
    
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(date_one, date_two), 1)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(date_one, date_three), 2)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(date_one, date_four), 21)

    period = AccountingCycle::Vat::Year.period_for_date(date_one)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(period.next_period(21), date_four), nil)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(period.next_period(21).prev_period(21), date_four), 21)
  end
  
  def test_next_period_during_november_quarters
    
    AccountingCycle::Vat::Year.config do |config|
      config.set          = false
      config.day          = 5
      config.month        = 11
      config.period_count = 4
    end
    
    # Get a day towards the end of a financial year:
    date_one    = Date.new(2011,10,15)
    
    # Get a day towards the beginning of the following financial year:
    date_two    = Date.new(2011,12,2)
    
    # Get a day towards the middle of the following financial year:
    date_three  = Date.new(2012,2,6)
    
    # A date in the future:
    date_four   = Date.new(2017,6,3)
    
    # A date later in the year:
    date_five   = Date.new(2012,10,12)
    

    assert_raise(AccountingCycle::YearError) do 
      AccountingCycle::Vat::Year.check_periods!(date_one, date_two)
    end
    assert_raise(AccountingCycle::YearError) do 
      AccountingCycle::Vat::Year.check_periods!(date_one, date_four)
    end
    assert_raise(AccountingCycle::PeriodError) do 
      AccountingCycle::Vat::Year.check_periods!(date_two, date_three)
    end
    assert_raise(AccountingCycle::MultiplePeriodError) do 
      AccountingCycle::Vat::Year.check_periods!(date_two, date_five)
    end
    assert_raise(AccountingCycle::YearError) do 
      AccountingCycle::Vat::Year.check_periods!(date_two, date_five, date_four)
    end
    
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(date_one, date_two), 1)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(date_one, date_three), 2)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(date_one, date_four), 23)
  
    period = AccountingCycle::Vat::Year.period_for_date(date_one)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(period.next_period(23), date_four), nil)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(period.next_period(23).prev_period(23), date_four), 23)
  end

  def test_next_period_last_day_of_december
    AccountingCycle::Vat::Year.config do |config|
      config.set       = false
      config.day       = 31
      config.month     = 12
      config.period_count = 4
    end
    
    
    # Get a day towards the end of a financial year:
    date_one    = Date.new(2011,12,28)
    
    # Get a day towards the beginning of the following financial year:
    date_two    = Date.new(2012,1,3)
    
    # Get a day towards the middle of the following financial year:
    date_three  = Date.new(2012,5,6)
    
    # A date in the future:
    date_four   = Date.new(2017,6,3)
    
    # A date later in the year:
    date_five   = Date.new(2012,12,20)
    

    assert_raise(AccountingCycle::YearError) do 
      AccountingCycle::Vat::Year.check_periods!(date_one, date_two)
    end
    assert_raise(AccountingCycle::YearError) do 
      AccountingCycle::Vat::Year.check_periods!(date_one, date_four)
    end
    assert_raise(AccountingCycle::PeriodError) do 
      AccountingCycle::Vat::Year.check_periods!(date_two, date_three)
    end
    assert_raise(AccountingCycle::MultiplePeriodError) do 
      AccountingCycle::Vat::Year.check_periods!(date_two, date_five)
    end

    assert_equal(AccountingCycle::Vat::Year.count_periods_between(date_one, date_two), 1)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(date_one, date_three), 2)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(date_one, date_four), 22)

    period = AccountingCycle::Vat::Year.period_for_date(date_one)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(period.next_period(22), date_four), nil)
    assert_equal(AccountingCycle::Vat::Year.count_periods_between(period.next_period(22).prev_period(22), date_four), 22)
  end
  
end