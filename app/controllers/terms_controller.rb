class TermsController < ApplicationController
  def new
    @term = Term.new
  end

  def create
    beginning_builder = []
    deadline_builder = []
    5.times do |n|
      beginning_builder << params[:term]["beginning(#{n+1}i)"].to_i
      deadline_builder << params[:term]["deadline(#{n+1}i)"].to_i
    end

    beginning = DateTime.new(beginning_builder[0],beginning_builder[1],beginning_builder[2],beginning_builder[3],beginning_builder[4])
    deadline = DateTime.new(deadline_builder[0],deadline_builder[1],deadline_builder[2],deadline_builder[3],deadline_builder[4])

    @term = Term.new(beginning: beginning, deadline: deadline)
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

end
