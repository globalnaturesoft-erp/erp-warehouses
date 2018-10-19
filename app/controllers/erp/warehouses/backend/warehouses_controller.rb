module Erp
  module Warehouses
    module Backend
      class WarehousesController < Erp::Backend::BackendController
        before_action :set_warehouse, only: [:archive, :unarchive, :edit, :update]
        before_action :set_warehouses, only: [:delete_all, :archive_all, :unarchive_all]

        # GET /warehouses
        def index
          if Erp::Core.available?("ortho_k")
            authorize! :inventory_products_warehouses_index, nil
          end
        end

        # POST /warehouses/list
        def list
          if Erp::Core.available?("ortho_k")
            authorize! :inventory_products_warehouses_index, nil
          end
          
          @warehouses = Warehouse.search(params).paginate(:page => params[:page], :per_page => 5)

          render layout: nil
        end

        # GET /warehouses/new
        def new
          @warehouse = Warehouse.new
          
          authorize! :creatable, @warehouse
        end

        # GET /warehouses/1/edit
        def edit
          authorize! :updatable, @warehouse
        end

        # POST /warehouses
        def create
          @warehouse = Warehouse.new(warehouse_params)
          
          authorize! :creatable, @warehouse
          
          @warehouse.creator = current_user

          if @warehouse.save
            if request.xhr?
              render json: {
                status: 'success',
                text: @warehouse.name,
                value: @warehouse.id
              }
            else
              redirect_to erp_warehouses.edit_backend_warehouse_path(@warehouse), notice: t('.success')
            end
          else
            render :new
          end
        end

        # PATCH/PUT /warehouses/1
        def update
          authorize! :updatable, @warehouse
          
          if @warehouse.update(warehouse_params)
            if request.xhr?
              render json: {
                status: 'success',
                text: @warehouse.name,
                value: @warehouse.id
              }
            else
              redirect_to erp_warehouses.edit_backend_warehouse_path(@warehouse), notice: t('.success')
            end
          else
            render :edit
          end
        end

        # DELETE /warehouses/1
        #def destroy
        #  @warehouse.destroy
        #  respond_to do |format|
        #    format.json {
        #      render json: {
        #        'message': t('.success'),
        #        'type': 'success'
        #      }
        #    }
        #  end
        #end

        # Archive /warehouses/archive?id=1
        def archive
          authorize! :archive, @warehouse
          
          @warehouse.archive

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # Unarchive /warehouses/unarchive?id=1
        def unarchive
          authorize! :unarchive, @warehouse
          
          @warehouse.unarchive

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # Archive all /warehouses/archive_all?ids=1,2,3
        def archive_all
          authorize! :archivexxxxxxxxxxxxxxxxxxxxxxx, @warehouses
          
          @warehouses.archive_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # Unarchive all /warehouses/unarchive_all?ids=1,2,3
        def unarchive_all
          authorize! :archivexxxxxxxxxxxxxxxxxxxxxxxxxx, @warehouses
          
          @warehouses.unarchive_all

          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end

        # DELETE /warehouses/delete_all
        #def delete_all
        #  @warehouses = Warehouse.where(id: params[:ids])
        #  @warehouses.destroy_all
        #
        #  respond_to do |format|
        #    format.json {
        #      render json: {
        #        'message': t('.success'),
        #        'type': 'success'
        #      }
        #    }
        #  end
        #end

        def dataselect
          respond_to do |format|
            format.json {
              render json: Warehouse.dataselect(params[:keyword], params)
            }
          end
        end

        private
          # Use callbacks to share common setup or constraints between actions.
          def set_warehouse
            @warehouse = Warehouse.find(params[:id])
          end

          def set_warehouses
            @warehouses = Warehouse.where(id: params[:ids])
          end

          # Only allow a trusted parameter "white list" through.
          def warehouse_params
            params.fetch(:warehouse, {}).permit(:name, :short_name, :contact_id)
          end
      end
    end
  end
end
