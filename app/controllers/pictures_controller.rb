class PicturesController < ApplicationController
  before_filter :authenticate_user!, only: [:create, :new, :update, :edit, :destroy]
  before_filter :find_user
  before_filter :find_album
  before_filter :find_picture, only: [:edit, :update, :show, :destroy]
  before_filter :ensure_proper_user, only: [:edit, :new, :create, :update, :destroy]
  before_filter :add_breadcrumbs 

  def index
    @pictures = @album.pictures.all
    
    respond_to do |format| 
      format.html # index.html.erb
      format.json { render json: @pictures}
    end
  end

  def show
    @picture = @album.pictures.find(params[:id])
    add_breadcrumb @picture, album_pictures_path(@album, @picture)

    respond_to do |format| 
      format.html # show.html.erb
      format.json { render json: @pictures}
    end
  end

  def new
    @picture = @album.pictures.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @picture }
    end
  end

  def edit
  end

  def create
    @picture = @album.pictures.new(params[:picture])
    
    respond_to do |format|
      if @picture.save
        current_user.create_activity @picture, 'created'
        format.html { redirect_to album_pictures_path(@album), notice: 'Picture was successfully created' }
        format.json { render json: @picture, status: :created, location: @picture}
      end
    end
  end

  def update
    
    respond_to do |format|
      if @picture.update_attributes(params[:picture])
        current_user.create_activity @picture, 'updated'
        format.html { redirect_to album_pictures_path(@album), notice: 'Picture was successfully updated'}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
    
  end

  def destroy
    @picture.destroy

    respond_to do |format|
      current_user.create_activity @picture, 'deleted'
      format.html { redirect_to album_pictures_url(@album) }
      format.json { head :no_content }
    end
  end

  def url_options
    { profile_name: params[:profile_name] }.merge(super)
  end

  private
    def ensure_proper_user
      if current_user !=  @user
        flash[:error] = "You don't have permissions to do that."
        redirect_to album_pictures_path
      end
    end

    def add_breadcrumbs
      add_breadcrumb @user.first_name, profile_path(@user)
      add_breadcrumb "Albums", albums_path
      add_breadcrumb "Pictures", album_pictures_path(@album)
    end

    def find_user
      @user = User.find_by_profile_name(params[:profile_name])
    end

    def find_album
      if signed_in? && current_user.profile_name == params[:profile_name]
        @album = current_user.albums.find(params[:album_id])
      else
        @album = @user.albums.find(params[:album_id])
      end
    end

    def find_picture
      @picture = @album.pictures.find(params[:id])
    end
end
