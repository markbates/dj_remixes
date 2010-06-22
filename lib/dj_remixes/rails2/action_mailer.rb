if defined?(ActionMailer)
  module ActionMailer
    class Base
        
      class << self
        
        def inherited(klass)
          super
          eval %{
            class ::#{klass}Worker < DJ::Worker
              
              priority :urgent
              run_at {1.year.ago}

              attr_accessor :called_method
              attr_accessor :args

              def initialize(called_method, *args)
                self.called_method = called_method
                self.args = args
              end

              def perform
                # ::#{klass}.send(self.called_method, *self.args)
                ::#{klass}.send(:new, self.called_method, *self.args).deliver!
              end

              class << self

                def method_missing(sym, *args)
                  ::#{klass}Worker.enqueue(sym, *args)
                end

              end

            end
          }
        end
        
        def method_missing_with_extras(method_symbol, *parameters) #:nodoc:
          if ActionMailer::Base.delivery_method == :test
            return method_missing_without_extras(method_symbol, *parameters)
          end
          
          if match = matches_dynamic_method?(method_symbol)
            case match[1]
              when 'deliver'# then new(match[2], *parameters).deliver!
                "#{self.name}Worker".constantize.enqueue(match[2], *parameters)
              else
                method_missing_without_extras(method_symbol, *parameters)
            end
          else
            super
          end
        end
        
        alias_method_chain :method_missing, :extras
        
      end # class << self
      
    end # Base
  end # ActionMailer
end