require 'yaml'

class Module
	def is_complex_yaml? 
		false
	end
	
	def to_yaml(opts = {})
		YAML::quick_emit( nil, opts ) { |out| 
      out << "!ruby/module " 
      self.name.to_yaml( :Emitter => out ) 
    } 
	end
end

YAML.add_ruby_type(/^module/) do |type, val| 
	subtype, subclass = YAML.read_type_class(type, Module) 
	val.split(/::/).inject(Object) { |p, n| p.const_get(n)} 
end

class Class 
	def to_yaml(opts = {})
		YAML::quick_emit( nil, opts ) { |out| 
      out << "!ruby/class "
      self.name.to_yaml( :Emitter => out ) 
    } 
	end 
end

YAML.add_ruby_type(/^class/) do |type, val| 
	subtype, subclass = YAML.read_type_class(type, Class) 
	val.split(/::/).inject(Object) { |p, n| p.const_get(n)} 
end 
