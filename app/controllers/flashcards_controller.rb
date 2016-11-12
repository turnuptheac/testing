class FlashcardsController < ApplicationController
  # GET
  def index
    render :json => Flashcard.all
  end

  # PUT
  def create
    render :json => Flashcard.create(flashcard_params)
  end

  # POST
  def mark_correct
    flashcard = Flashcard.find_by_id(params[:flashcard_id])
    flashcard.mark_correct
    flashcard.save!
    render :json => flashcard
  end

  # POST
  def mark_incorrect
    flashcard = Flashcard.find_by_id(params[:flashcard_id])
    flashcard.mark_incorrect
    flashcard.save!

    render :json => flashcard
  end

  # GET
  def next_card_to_review
    flashcard = Flashcard.next_card_to_review
    if flashcard
      render :json => flashcard
    elsif Flashcard.has_future_cards
      render :json => { msg: "You are temporarily done; please come back later to review more words." }
    else
      render :json => { msg: "You have no more words to review; you are permanently done!" }
    end
  end

  def flashcard_params
    params.permit(:question, :answer)
  end
end
