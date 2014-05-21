class TermsController < ApplicationController
  def new
    @term = Term.new
  end

  def create
    @term = Term.new(terms_params)
    if @term.save
      redirect_to nestle_input_path, notice: '期間の設定に成功しました。'
    end
  end

  def show
    @term = Term.new
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def terms_params
      params.require(:term).permit(:beginning, :deadline)
    end
end
