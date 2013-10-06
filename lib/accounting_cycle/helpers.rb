module AccountingCycle
  
  module Helpers
    
    def parent_class(child_class=nil)
      names = self.class.to_s.split('::')
      names.pop
      names << child_class.capitalize if child_class
      constant = Object
      names.each do |name|
        constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
      end
      constant
    end
    
  end
  
end