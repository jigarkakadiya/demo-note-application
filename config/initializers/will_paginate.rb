# config/initializers/will_paginate.rb
if defined?(WillPaginate)
  module WillPaginate
    module ActiveRecord
      module RelationMethods
        def per(value = nil) per_page(value) end
        def total_count() count end
      end
      module CollectionMethods
        #alias_method :num_pages, :pages
      end
    end
  end
end
