require 'test/unit'
require 'accounting_cycle'

class TestSettings < Test::Unit::TestCase
  
  def test_divising_of_the_months_by_period_count
    [12,6,4,3,2,1].each do |period_count|
      assert_nothing_raised do
        AccountingCycle::Financial::Year.config {|config| config.set = false; config.period_count = period_count;}
        AccountingCycle::Vat::Year.config {|config| config.set = false; config.period_count = period_count;}
      end
    end
    [11,10,9,8,7,5].each do |period_count|
      assert_raise(AccountingCycle::InvalidPeriodCount) do
        AccountingCycle::Financial::Year.config {|config| config.set = false; config.period_count = period_count;}
        AccountingCycle::Vat::Year.config {|config| config.set = false; config.period_count = period_count;}
      end
    end 
    AccountingCycle::Financial::Year.config do |config|
      config.set = false
      config.month = 1
      config.period_count = 4
      config.day = 1
    end 
  end
  
  def test_error_if_configuring_after_set 
    assert_raise(AccountingCycle::CycleAlreadySet) do
      AccountingCycle::Financial::Year.config {|config| config.month = 1; config.period_count = 4; config.day = 2}
      AccountingCycle::Financial::Year.config {|config| config.month = 2; config.period_count = 4; config.day = 2}
    end
    assert_raise(AccountingCycle::CycleAlreadySet) do
      AccountingCycle::Vat::Year.config {|config| config.month = 1; config.period_count = 4; config.day = 2}
      AccountingCycle::Vat::Year.config {|config| config.month = 2; config.period_count = 4; config.day = 2}
    end
    AccountingCycle::Financial::Year.config do |config|
      config.set = false
      config.month = 1
      config.period_count = 4
      config.day = 1
    end
  end

end