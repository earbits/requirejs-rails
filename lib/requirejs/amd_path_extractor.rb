require 'rkelly'
require 'set'
module Requirejs
  class AmdPathExtractor
    
  def self.is_amd_node?(node)
    %w{ require define }.include?(node.value)
  end
  
  def self.reserved_name?(name)
    %w{ exports module require }.include?(name)
  end
  
  def self.url?(name)
    name =~ /^https?:\/\//
  end  
    def self.parse(body)
      
      parser = RKelly::Parser.new
      parsed = parser.parse(body)
      
      
      module_names = Set.new
      
      ## Scan every node for function calls
      parsed.each do |node|
        
       if node.kind_of?(RKelly::Nodes::FunctionCallNode)

         call_node = node.value
         # Extract the "ResoveNodes" ( my_function(x), not a.f(x)) that are 
         # 'require' and 'define' calls
           if call_node.kind_of?(RKelly::Nodes::ResolveNode) && is_amd_node?(call_node)
            function_name = call_node.value

            # pull first argument, may be nil
            function_argument = node.arguments.value.first 
            
            
            ## if argument is an array, assume it is an array of dependencies
            if function_argument && function_argument.value.kind_of?(Array)
              ## for each array element
              function_argument.value.each do |array_item|
                dep_node = array_item.value
                
                #extract string and trim leading/trailing quotes
                if dep_node.kind_of?(RKelly::Nodes::StringNode)
                  module_name =  dep_node.value.gsub(/^['"]|['"]$/,"")
                  
                  module_name.gsub!(/!$/,"") # pluging form
                  
                  unless module_name.empty? || reserved_name?(module_name) || url?(module_name)
                    module_names << module_name 
                  end
                end
              end
            end

          end
         
        end
      end
      module_names.to_a
    end
  end
end