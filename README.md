A gem to calculate financial periods in accounting years. Quite useful for VAT.

###Installation

This gem is not distributed built. Either clone & build, or use bundler:

```ruby	

gem 'accounting_cycle', :git => 'https://github.com/julesjans/accounting_cycle.git'
```

###Usage

####Configuring an accounting cycle

Configure a VAT year cycle. Periods default to quarterly, begining 1 Jan, but can be adjusted (e.g. 5 April - 4 April). Can only be set once, or will raise error (AccountingCycle::CycleAlreadySet): 

```ruby
require 'accounting_cycle'

AccountingCycle::Vat::Year.config do |config|
	config.day 			= 5
	config.month 		= 4
	config.period_count = 4
end
```
Period count can only be a number that divides 12 (months) into a whole number.


Get the VAT year that starts in 2011:

```ruby
year = AccountingCycle::Vat::Year.new(2011)

puts year.start		# => "2011-04-05"
```

Or find out which VAT year a specific date falls in:

```ruby
date = Date.new(2012,1,1)
year = AccountingCycle::Vat::Year.year_for_date(date)

puts year.start		# => "2011-04-05"
```

Get the specific VAT period (e.g. quarter):

```ruby
date 	= Date.new(2012,1,1)
period 	= AccountingCycle::Vat::Year.period_for_date(date)

puts period.start	# => "2011-10-05"
```

Access all the periods (AccountingCycle::Vat::Period) within the year cycle:

```ruby
date 	= Date.new(2012,1,1)
year 	= AccountingCycle::Vat::Year.new(2011)
periods = year.periods

puts periods.collect {|period| "#{period.start}"} .join(', ')	# => "2011-04-05", "2011-07-05", "2011-10-05", "2012-01-05"
```

Iterate through years:

```ruby
year = AccountingCycle::Vat::Year.new(2011)

one_year_later 		= year.next_year
one_year_earlier 	= year.prev_year

puts one_year_later.start 						# => "2012-04-05"
puts one_year_earlier.start						# => "2010-04-05"

two_years_later = year.next_year(2)
two_years_later == year.next_year.next_year 	# => true
```

Or periods:

```ruby
date = Date.new(2012,1,1)
year = AccountingCycle::Vat::Year.new(2011)
period = year.periods.first

one_period_later 	= period.next_period
one_period_earlier 	= period.prev_period

puts one_period_later.start								# => "2011-07-05"
puts one_period_earlier.start							# => "2011-01-05"

two_periods_later = period.next_period(2)
two_periods_later == period.next_period.next_period		# => true
```

####Attributes of years & periods

Years:

```ruby
year 	= AccountingCycle::Vat::Year.new(2011)

puts year.year			# => "2011"
puts year.name			# => "2011/2012"
puts year.start			# => "2011-04-05"
puts year.start.class	# => Date
puts year.finish		# => 2012-04-04
```

Periods:

```ruby
period 	= AccountingCycle::Vat::Year.new(2011).periods.first

puts period.year.class	# => AccountingCycle::Vat::Year
puts period.name		# => "2011/2012 (1)"
puts period.start		# => "2011-04-05"
puts period.start.class	# => Date
puts period.finish		# => "2011-07-04"
```

####Comparing dates & cycles

Compare periods as to whether they are same, or how many periods there are between them:

```ruby
period = AccountingCycle::Vat::Year.period_for_date(Date.new(2012,1,1))

period.same_period_as?(period)									# => true
period.same_period_as?(period.next_period)						# => false
period.count_periods_between(period.next_period.next_period)	# => 2
```

Raise specific errors according to how many periods there are between dates:

```ruby
period = AccountingCycle::Vat::Year.period_for_date(Date.new(2012,5,1))

period.check_period!(period.next_period(1))		# => AccountingCycle::PeriodError
period.check_period!(period.next_period(2))		# => AccountingCycle::MultiplePeriodError
period.check_period!(period.next_period(4))		# => AccountingCycle::YearError
```

Comparison methods can take dates as well as AccountingCycle::Vat::Period objects:

```ruby
date 	= Date.new(2012,6,4)
period 	= AccountingCycle::Vat::Year.new(2012).periods.first

period.same_period_as?(date)										# => true
period.count_periods_between(period.next_period.next_period, date) 	# => 2
```

And they can take multiple values as parameters

```ruby
date_one 	= Date.new(2012,6,4)
date_two 	= Date.new(2012,7,4)
date_three 	= Date.new(2012,7,8)

period 	 	= AccountingCycle::Vat::Year.new(2012).periods.first

period.same_period_as?(date_one, date_two)					# => true
period.same_period_as?(date_one, date_two, date_three)		# => false
period.check_period!(date_one, date_two, date_three)		# => AccountingCycle::PeriodError
```

Comparisons are also available as class methods:

```ruby
date_one    = Date.new(2012,6,4)
date_two    = Date.new(2012,7,4)
date_three  = Date.new(2012,7,8)
date_four   = Date.new(2013,7,8)

AccountingCycle::Vat::Year.same_periods?(date_one, date_two)			# => true
AccountingCycle::Vat::Year.same_periods?(date_one, date_three)			# => false
AccountingCycle::Vat::Year.check_periods!(date_one, date_three)			# => AccountingCycle::PeriodError
AccountingCycle::Vat::Year.count_periods_between(date_one, date_four) 	# => 5
```

####But what is the point?

Two main uses:

1. A neat way of organising dates for accounts reporting.

2. Controlling the possibility of making edits to records that will affect prior VAT return payments.


####Yet to come...

1. Include dates for VAT return submission.

1. Include support for HMRC annual accounting times [http://www.hmrc.gov.uk/vat/start/schemes/annual.htm](http://www.hmrc.gov.uk/vat/start/schemes/annual.htm)

1. Full documentation
