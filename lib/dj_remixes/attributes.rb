module DJ
  class Worker
    
    attr_accessor :id
    attr_accessor :attributes
    
    def initialize(attributes = {})
      self.attributes = attributes
      self.attributes = self.attributes.stringify_keys
      self.id = self.attributes['id']
    end
    
    def method_missing(sym, *args, &block)
      attribute = sym.to_s
      case attribute
      when /(.+)\=$/
        self.attributes[$1] = args.first
      when /(.+)\?$/
        # self.attributes.has_key?($1.to_sym)
        return self.attributes[$1]
      else
        return self.attributes[attribute]
      end
    end
    
  end # Worker
end # DJ