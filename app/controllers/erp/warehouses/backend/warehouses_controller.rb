require_dependency "erp/application_controller"

module Erp
  module Warehouses
    module Backend
      class WarehousesController < Erp::Backend::BackendController
        before_action :set_warehouse, only: [:archive, :unarchive, :show, :edit, :update, :destroy]
        before_action :set_warehouses, only: [:delete_all, :archive_all, :unarchive_all]
    
        # GET /warehouses
        def index
          @warehouses = Warehouse.all
        end
    
        # GET /warehouses/1
        def show
        end
        
        # POST /warehouses/list
        def list
          @warehouses = Warehouse.search(params).paginate(:page => params[:page], :per_page => 5)
          
          render layout: nil
        end
    
        # GET /warehouses/new
        def new
          @warehouse = Warehouse.new
        end
    
        # GET /warehouses/1/edit
        def edit
        end
    
        # POST /warehouses
        def create
          @warehouse = Warehouse.new(warehouse_params)
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
            puts @warehouse.errors.to_json
            render :new
          end
        end
    
        # PATCH/PUT /warehouses/1
        def update
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
        def destroy
          @warehouse.destroy
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        def archive
          @warehouse.archive
          
          respond_to do |format|
            format.html { redirect_to erp_warehouses.backend_warehouses_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        def unarchive
          @warehouse.unarchive
          
          respond_to do |format|
            format.html { redirect_to erp_warehouses.backend_warehouses_path, notice: t('.success') }
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end
        end
        
        # Archive /warehouses/archive_all?ids=1,2,3
        def archive_all         
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
        
        # Unarchive /warehouses/unarchive_all?ids=1,2,3
        def unarchive_all
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
        def delete_all
          @warehouses = Warehouse.where(id: params[:ids])          
          @warehouses.destroy_all
          
          respond_to do |format|
            format.json {
              render json: {
                'message': t('.success'),
                'type': 'success'
              }
            }
          end          
        end
        
        def dataselect
          respond_to do |format|
            format.json {
              render json: Warehouses.dataselect(params[:keyword])
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
