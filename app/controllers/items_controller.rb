class ItemsController < ApplicationController

  # ensure user logged in
  authorize_resource

  include BbInventoryHelpers::Cart

  before_action :set_item, only: [:show, :edit, :update, :destroy]
  # before_action :check_login

  # GET /items
  # GET /items.json
  def index

    # create cart
    create_cart

    # age list with only keys
    al = Item::AGE_LIST.to_h
    gl = Item::GENDER_LIST.to_h
    @gender_list = Item::GENDER_LIST.to_h
    @age_list = Item::AGE_LIST.to_h 

    # Filter record OR Return all items
    @filterrific = initialize_filterrific( Item, params[:filterrific], 
      select_options: { 
        by_category: Category.alphabetical.all.pluck(:name),
        by_age_category: @age_list,
        by_gender: @gender_list 
      },
      persistence_id: false) or return
    if !params[:filterrific].nil? && params[:filterrific][:search_by_quantity]==""
      @items = @filterrific.find.alphabetical
    elsif params[:filterrific].nil?
      @items = @filterrific.find.alphabetical
    else
      @items = Array.new
      Item.search_by_quantity(params[:filterrific][:search_by_quantity].to_i).each do |i|
        item = Item.find(i)
        @items << item
      end
    end
    
    # paginate: different function if array
    if @items.instance_of?(Array)
      @items=Kaminari.paginate_array(@items).page(params[:page]).per(10)
    else
      @items = @items.page(params[:page])
    end

  end

  # export items to csv
  def export_items
    @items = Item.dump_to_csv
    timestamp = Time.now.to_s
    fname = 'Items '+ timestamp + '.csv'
    respond_to do |format|
      format.csv { send_data @items.to_csv, filename: fname }
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    @gender_list = Item::GENDER_LIST.to_h
    @age_list = Item::AGE_LIST.to_h 
    @item_checkins = @item.item_checkins.chronological
    @item_checkin_archives = @item.item_checkin_archives.chronological
  end

  # GET /items/new
  def new
    redirect_to get_new_barcode_path
  end

  # NEW ITEM -> BARCODE -> FORM -> SAVE ITEM

  def get_new_barcode

  end

  def get_new_item_info
    @categories = Category.alphabetical
    barcode = params[:barcode]
    name = params[:name]
    # if item doesn't have barcode, don't autopopulate form
    # Barcode takes precedence over name
    if barcode != ''
      @item = Item.find_by barcode: barcode 
    elsif name !=''
      @item = Item.search_by_name(name).first
    else
      @item=nil
    end

    if @item.nil?
      @item = Item.new
      @item.barcode = barcode
      @total_quantity = 0
      render 'new'
    else
      redirect_to edit_item_path(@item.id)
    end

  end

  # GET /items/1/edit
  def edit
    @total_quantity = @item.total_quantity_remaining
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save

        #create item_checkin
        info = {item_id: @item.id, quantity_checkedin: item_params['check_in_quantity'], donated: item_params['donated'], unit_price: item_params['unit_price'], quantity_remaining: item_params['check_in_quantity'], checkin_date: Date.today}
        @item_checkin = ItemCheckin.create(info)

        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update

    respond_to do |format|
      if @item.update(item_params)

        # get latest itemCheckin record
        @latest_item_checkin = @item.item_checkins.chronological.first()
        # create new item_checkin record
        # if quantity of item edited: new check_in record only consists of item increment
        if item_params['check_in_quantity'].to_i > 0
          info = {item_id: @item.id, quantity_checkedin: item_params['check_in_quantity'], donated: item_params['donated'], unit_price: item_params['unit_price'], quantity_remaining: item_params['check_in_quantity'], checkin_date: Date.today}
          print('Info: ', info)
          @item_checkin = ItemCheckin.create(info)
        # else: if donated field of item edited: edit last entry
        elsif item_params['donated']!=@latest_item_checkin.donated
          @latest_item_checkin.update({donated: item_params['donated']})
          @latest_item_checkin.save!
        end 

        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:barcode, :unit_price, :check_in_quantity, :name, :gender, :donated, :notes, :category_id, :age=>[])
    end
end
