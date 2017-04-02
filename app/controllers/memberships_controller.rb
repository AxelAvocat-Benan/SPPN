class MembershipsController < ApplicationController
  before_action :authenticate_user!, only: :new
  before_action :set_membership, only: [:show, :edit, :update, :destroy]

  # GET /memberships
  # GET /memberships.json
  def index
    # @memberships = Membership.all
    @memberships = policy_scope(Membership).order("RANDOM()")
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    authorize @membership
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    # @membership = current_user.memberships.build(membership_params)
    @membership = Membership.new(membership_params)
    @membership.user = current_user
    authorize @membership

    respond_to do |format|
      if @membership.save
        MembershipMailer.creation_confirmation(@membership).deliver_now
        format.html { redirect_to memberships_path, notice: 'Membership was successfully created.' }
        format.json { render :show, status: :created, location: @membership }
      else
        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    @membership = Membership.find(params[:id])
    @membership.update(membership_params)
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to memberships_url, notice: 'Membership was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
      authorize @membership
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:first_name, :last_name, :diplome, :age, :activity, :massif, :periode, :passmorgiou, :passsormiou, :siret, :description, :photo, :photo_cache)
    end
end
