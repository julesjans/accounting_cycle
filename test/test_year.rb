require 'test/unit'
require 'accounting_cycle'

class TestYear < Test::Unit::TestCase
  
  def test_accounting_years_always_contain_the_correct_no_of_periods
    [12,6,4,3,2,1].each do |period|
      [1,2,3,4,5,6,7,8,9,10,11,12].each do |month|
                
        AccountingCycle::Financial::Year.config do |config|
          config.set = false
          config.month = month
          config.period_count = period
        end
  
        AccountingCycle::Vat::Year.config do |config|
          config.set = false
          config.month = month
          config.period_count = period
        end

        ((Date.today.year-2)..(Date.today.year+2)).each do |year|
          assert_equal(AccountingCycle::Financial::Year.new(year).periods.size, AccountingCycle::Financial::Year.period_count)
          assert_equal(AccountingCycle::Vat::Year.new(year).periods.size, AccountingCycle::Vat::Year.period_count)
        end
      end
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
  
  def test_next_year
    assert_equal(AccountingCycle::Financial::Year.new(Date.today.year).next_year, AccountingCycle::Financial::Year.new(Date.today.year).next_year(1))
    assert_equal(AccountingCycle::Financial::Year.new(Date.today.year).next_year.next_year, AccountingCycle::Financial::Year.new(Date.today.year).next_year(2))
    assert_equal(AccountingCycle::Financial::Year.new(Date.today.year), AccountingCycle::Financial::Year.new(Date.today.year).next_year.prev_year)
    [AccountingCycle::Vat::Year, AccountingCycle::Financial::Year].each do |year|
      year.config do |config|
        config.set = false
        config.month = 1
        config.period_count = 4
        config.day = 1
      end
    end  
  end
  
  def test_prev_year
    assert_equal(AccountingCycle::Vat::Year.new(Date.today.year).prev_year, AccountingCycle::Vat::Year.new(Date.today.year).prev_year(1))
    assert_equal(AccountingCycle::Vat::Year.new(Date.today.year).prev_year.prev_year, AccountingCycle::Vat::Year.new(Date.today.year).prev_year(2))
    assert_equal(AccountingCycle::Vat::Year.new(Date.today.year), AccountingCycle::Vat::Year.new(Date.today.year).prev_year.next_year)
    [AccountingCycle::Vat::Year, AccountingCycle::Financial::Year].each do |year|
      year.config do |config|
        config.set = false
        config.month = 1
        config.period_count = 4
        config.day = 1
      end
    end  
  end
  
  def test_year_for_date
    AccountingCycle::Financial::Year.config do |config|
      config.set = false
      config.month = 1
      config.period_count = 4
    end
    year_one = AccountingCycle::Financial::Year.new(Date.today.year)
    year_two = AccountingCycle::Financial::Year.year_for_date(Date.today)
    assert_equal(year_one, year_two)
    [AccountingCycle::Vat::Year, AccountingCycle::Financial::Year].each do |year|
      year.config do |config|
        config.set = false
        config.month = 1
        config.period_count = 4
        config.day = 1
      end
    end  
  end
  
  def test_period_for_date
    AccountingCycle::Financial::Year.config do |config|
      config.set = false
      config.month = 1
      config.period_count = 4
    end
    AccountingCycle::Financial::Year.period_count.times do |i|
      assert_equal(AccountingCycle::Financial::Year.new(Date.today.year).periods[i], AccountingCycle::Financial::Year.year_for_date(Date.today).periods[i])
    end
    AccountingCycle::Vat::Year.config do |config|
      config.set = false
      config.month = 6
      config.period_count = 3
    end
    AccountingCycle::Vat::Year.period_count.times do |i|
      assert_equal(AccountingCycle::Vat::Year.new(Date.today.year).periods[i], AccountingCycle::Vat::Year.year_for_date(Date.today).periods[i])
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