class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:index]



  # GET /lists
  # GET /lists.json
  def index
    @lists = List.all

      if(current_user)
      @shared_lists = SharedList.all
      #where(friend_id: current_user.id).map(&:list)
      # @filtered_list = SharedList.where(list_id: @lists.id)
      end
    #@items = Item.all
  end

  # GET /lists/1
  # GET /lists/1.json
  def show

    @items = Item.where(:list_id => params[:id])
    @item = Item.new
    @item.list_id = @list.id

  end


  # GET /lists/new
  def new
    @list = List.new
    @item = Item.new
    @item.list_id = @list.id
    @categories = Category.all
  end

  # GET /lists/1/edit
  def edit
    @categories = Category.all
    @items = Item.where(:list_id => params[:id])
  end

  def basicCal
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = List.new(list_params)

    respond_to do |format| 
      if @list.save
        format.html { redirect_to :action=>"new", :controller=>"items", :notice=>"Success", id: @list.to_param}
        # format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list, notice: 'List was successfully updated.' }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @shared_lists = SharedList.all
    @list.destroy
    @list.items.each do |item|
        item.destroy
      end
    @shared_lists.each do |shared|
      if shared.list_id == @list.id
        shared.destroy
      end
    end
    respond_to do |format|
      format.html { redirect_to lists_url, notice: 'List was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_params
      params.require(:list).permit(:name, :due_date, :category_id, :user_id)
    end
end
