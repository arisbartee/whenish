module HumanRecord
  module ActsAsWhenish 
    extend ActiveSupport::Concern
    included do
    end

    module ClassMethods
      def acts_as_whenish(when_name)

        month_exists = lambda do
          not self.send("#{when_name}_month").nil?
        end
        day_exists = lambda do
          not self.send("#{when_name}_day").nil?
        end
        year_exists = lambda do
          not self.send("#{when_name}_year").nil?
        end

        when_method = lambda do 
          ttime = Time.now
          yyear = self.send("#{when_name}_year") || ttime.year
          dday = self.send("#{when_name}_day") || ttime.day
          mmonth = self.send("#{when_name}_month") || ttime.month
          ttime = Time.local(yyear,mmonth,dday)
        end

        completely_exists = lambda do
          exists = self.send("#{when_name}_year").nil? || self.send("#{when_name}_day").nil? || self.send("#{when_name}_month").nil?
          not exists
        end

        all_absent = lambda do
          self.send("#{when_name}_year").nil? && self.send("#{when_name}_day").nil? && self.send("#{when_name}_month").nil?
        end
        format_when = lambda do 
          month = "???"
          day = "??"
          year = "????"
          if  self.send("#{when_name}_date?")
            month = Date::MONTHNAMES[self.send("#{when_name}_month")]
            day = self.send("#{when_name}_day").ordinalize
            year = self.send("#{when_name}_year")
          elsif self.send("no_#{when_name}_date?")
            return " "
          elsif  self.send("#{when_name}_month") and self.send("#{when_name}_day")
            month = Date::MONTHNAMES[self.send("#{when_name}_month")]
            day = self.send("#{when_name}_day").ordinalize
          elsif  self.send("#{when_name}_month") and self.send("#{when_name}_year")
            month = Date::MONTHNAMES[self.send("#{when_name}_month")]
            year = self.send("#{when_name}_year")
          elsif  self.send("#{when_name}_day") and self.send("#{when_name}_year")
            day = self.send("#{when_name}_day").ordinalize
            year = self.send("#{when_name}_year")
          elsif  self.send("#{when_name}_month")
            month = Date::MONTHNAMES[self.send("#{when_name}_month")]
          elsif  self.send("#{when_name}_day")
            day = self.send("#{when_name}_day").ordinalize
          elsif  self.send("#{when_name}_year")
            year = self.send("#{when_name}_year")
          end
          "#{month} #{day}, #{year}"
        end
        sentence_format_when = lambda do 
          if  self.send("#{when_name}_date?")
            month = Date::MONTHNAMES[self.send("#{when_name}_month")]
            day = self.send("#{when_name}_day").ordinalize
            year = self.send("#{when_name}_year")
            "on the #{day} of #{month} #{year}"
          elsif self.send("no_#{when_name}_date?")
            ""
          elsif  self.send("#{when_name}_month") and self.send("#{when_name}_day")
            month = Date::MONTHNAMES[self.send("#{when_name}_month")]
            day = self.send("#{when_name}_day").ordinalize
            "on the #{day} of #{month}"
          elsif  self.send("#{when_name}_month") and self.send("#{when_name}_year")
            month = Date::MONTHNAMES[self.send("#{when_name}_month")]
            year = self.send("#{when_name}_year")
            "in #{month} of #{year}"
          elsif  self.send("#{when_name}_day") and self.send("#{when_name}_year")
            day = self.send("#{when_name}_day").ordinalize
            year = self.send("#{when_name}_year")
            "in #{year} on a #{day}"
          elsif  self.send("#{when_name}_month")
            month = Date::MONTHNAMES[self.send("#{when_name}_month")]
            "in #{month}"
          elsif  self.send("#{when_name}_day")
            day = self.send("#{when_name}_day").ordinalize
            "on the #{day}"
          elsif  self.send("#{when_name}_year")
            year = self.send("#{when_name}_year")
            "in #{year}"
          end
        end


        define_method("#{when_name}_month?",month_exists)
        define_method("#{when_name}_day?",day_exists)
        define_method("#{when_name}_year?",year_exists)
        define_method("#{when_name}_date?",completely_exists)
        define_method("no_#{when_name}_date?",all_absent)
        define_method("#{when_name}_date",when_method)
        define_method("format_#{when_name}_date",format_when)
        define_method("sentence_#{when_name}_date",sentence_format_when)
      end
    end
  end
end
ActiveRecord::Base.send :include, HumanRecord::ActsAsWhenish
