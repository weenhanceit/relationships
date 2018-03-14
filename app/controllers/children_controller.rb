class ChildrenController < ApplicationController
  def index
    @person = Person.find(params[:id])
    respond_to do |format|
      format.js { head :ok }
    end
  end
end
