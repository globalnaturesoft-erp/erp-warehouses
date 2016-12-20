module Erp::Warehouses
  class Warehouse < ApplicationRecord
    belongs_to :creator, class_name: "Erp::User"
    belongs_to :contact, class_name: 'Erp::Contacts::Contact', foreign_key: :contact_id
    
    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []
      
      #keywords
      if params["keywords"].present?
        params["keywords"].each do |kw|
          or_conds = []
          kw[1].each do |cond|
            or_conds << "LOWER(#{cond[1]["name"]}) LIKE '%#{cond[1]["value"].downcase.strip}%'"
          end
          and_conds << '('+or_conds.join(' OR ')+')'
        end
      end

      query = query.where(and_conds.join(' AND ')) if !and_conds.empty?
      
      return query
    end
    
    def self.search(params)
      query = self.all
      query = self.filter(query, params)
      
      # order
      if params[:sort_by].present?
        order = params[:sort_by]
        order += " #{params[:sort_direction]}" if params[:sort_direction].present?
        
        query = query.order(order)
      end
      
      return query
    end
    
    # data for dataselect ajax
    def self.dataselect(keyword='')
      query = self.all
      
      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ? OR LOWER(short_name) LIKE ?', "%#{keyword}%", "%#{keyword}%")
      end
      
      query = query.limit(8).map{|warehouse| {value: warehouse.id, text: warehouse.display_name} }
    end
    
    def archive
			update_columns(archived: false)
		end
    
    def unarchive
			update_columns(archived: true)
		end
    
    def self.archive_all
			update_all(archived: false)
		end
    
    def self.unarchive_all
			update_all(archived: true)
		end
    
    # display name
    def display_name
			short_name.present? ? short_name : name
		end
  end
end
