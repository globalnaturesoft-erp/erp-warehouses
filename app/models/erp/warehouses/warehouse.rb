module Erp::Warehouses
  class Warehouse < ApplicationRecord
    belongs_to :creator, class_name: "Erp::User"
    validates :name, :presence => true

    if Erp::Core.available?("contacts")
			validates :contact_id, :presence => true
			belongs_to :contact, class_name: 'Erp::Contacts::Contact', foreign_key: :contact_id

			# display contact address name
			def contact_name
				contact.present? ? contact.name : ""
			end
		end

    # Filters
    def self.filter(query, params)
      params = params.to_unsafe_hash
      and_conds = []

      # show archived items condition - default: false
      show_archived = false

      #filters
      if params["filters"].present?
        params["filters"].each do |ft|
          or_conds = []
          ft[1].each do |cond|
            # in case filter is show archived
            if cond[1]["name"] == 'show_archived'
              show_archived = true
            else
              or_conds << "#{cond[1]["name"]} = '#{cond[1]["value"]}'"
            end
          end
          and_conds << '('+or_conds.join(' OR ')+')' if !or_conds.empty?
        end
      end

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

			# join with users table for search creator
      query = query.joins(:creator)

      if Erp::Core.available?("contacts")
				# join with contacts table for search contact
				query = query.joins(:contact)
			end

      # showing archived items if show_archived is not true
      query = query.where(archived: false) if show_archived == false

      # add conditions to query
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
    def self.dataselect(keyword='', params={})
      query = self.all

      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ? OR LOWER(short_name) LIKE ?', "%#{keyword}%", "%#{keyword}%")
      end

      if params[:current_value].present?
        query = query.where.not(id: params[:current_value].split(','))
      end

      query = query.limit(8).map{|warehouse| {value: warehouse.id, text: warehouse.warehouse_name} }
    end

    def archive
			update_attributes(archived: true)
		end

    def unarchive
			update_attributes(archived: false)
		end

    def self.archive_all
			update_all(archived: true)
		end

    def self.unarchive_all
			update_all(archived: false)
		end

    # display name
    def warehouse_name
			short_name.present? ? short_name : name
		end

  end
end
