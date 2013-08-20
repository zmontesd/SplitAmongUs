class BillsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @lists = current_user.lists
  end
  
  def create 
    @bill = Bill.new(bill_params)
    @bill.list_id = params[:list_id]
    if @bill.save
      if request.xhr?
        render partial: 'bill', locals: { bill: @bill }
      end
    else
      flash[:error] = @bill.errors.full_messages.join('')
      redirect_to list_path(@bill.list)
    end
  end

  def edit
    @bill = Bill.find(params[:id])
  end

  def update
    @bill = Bill.find(params[:id])
    @bill.update_attributes(bill_params)
    redirect_to dashboard_index_path
  end

  def destroy
    @bill = Bill.find(params[:id])
    @bill.destroy
    redirect_to dashboard_index_path
  end

  private
  def bill_params
    params.require(:bill).permit(:description, :amount, :date)
  end
end