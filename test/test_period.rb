require 'test/unit'
require 'accounting_cycle'

class TestPeriod < Test::Unit::TestCase
  
  def test_next_period_function
    [AccountingCycle::Financial::Year.new(Date.today.year), AccountingCycle::Financial::Year.new(Date.today.year)].each do |p|
      periods = p.periods
      p.class.period_count.times do |count|
        assert_equal(periods[count], periods[count])
        assert_equal(periods[count], periods[count].next_period(0))
        assert_not_equal(periods[count], periods[count].next_period)
        assert_not_equal(periods[count], periods[count].next_period(count+1))
      end
      (1..100).each do |count|
        assert_equal(periods[0].next_period(count).class, AccountingCycle::Financial::Period )
      end
      (-100..1).each do |count|
        assert_equal(periods[0].next_period(count).class, AccountingCycle::Financial::Period )
      end
      assert_equal(periods[0].next_period, periods[0].next_period(1))
      assert_equal(periods[0].next_period.next_period, periods[0].next_period(2))
      assert_equal(periods[0].next_period.next_period.next_period.next_period.next_period.next_period, periods[0].next_period(6))
      assert_not_equal(periods[0].next_period, periods[0].prev_period)
    end
    AccountingCycle::Financial::Year.config do |config|
      config.set = false
      config.month = 1
      config.period_count = 4
      config.day = 1
    end
  end
  
  def test_prev_period_function
    [AccountingCycle::Financial::Year.new(Date.today.year), AccountingCycle::Financial::Year.new(Date.today.year)].each do |p|
      periods = p.periods
      p.class.period_count.times do |count|
        assert_equal(periods[count], periods[count])
        assert_equal(periods[count], periods[count].prev_period(0))
        assert_not_equal(periods[count], periods[count].prev_period)
        assert_not_equal(periods[count], periods[count].prev_period(count+1))
      end
      (1..30).each do |count|
        assert_equal(periods[0].prev_period(count).class, AccountingCycle::Financial::Period )
      end
      (-30..1).each do |count|
        assert_equal(periods[0].prev_period(count).class, AccountingCycle::Financial::Period )
      end
      assert_equal(periods[0].prev_period, periods[0].prev_period(1))
      assert_equal(periods[0].prev_period.prev_period, periods[0].prev_period(2))
      assert_equal(periods[0].prev_period.prev_period.prev_period.prev_period.prev_period.prev_period, periods[0].prev_period(6))
      assert_not_equal(periods[0].prev_period, periods[0].next_period)
    end
    [AccountingCycle::Vat::Year, AccountingCycle::Financial::Year].each do |year|
      year.config do |config|
        config.set = false
        config.month = 1
        config.period_count = 4
        config.day = 1
      end
    end  
  end

end