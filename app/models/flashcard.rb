# == Schema Information
#
# Table name: flashcards
#
#  id                        :integer          not null, primary key
#  bin                       :integer
#  question                  :string
#  answer                    :string
#  scheduled_time_to_revisit :datetime
#  times_wrong               :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class Flashcard < ApplicationRecord
  validates :question, :answer, presence: true

  bin_to_time_interval = [
    # cards in bin 0 are shown only when no cards are up for review
    nil,
    5.seconds,
    25.seconds,
    2.minutes,
    10.minutes,
    1.hour,
    5.hours,
    1.day,
    5.days,
    25.days,
    4.months,
    # cards in bin 11 are not scheduled for future review
    nil
  ]

  before_create do
    self.bin = 0
    self.times_wrong = 0
  end

  def mark_correct
    self.bin += 1
    update_scheduled_time_to_revisit
  end

  def mark_incorrect
    self.bin = 1
    self.times_wrong += 1
    update_scheduled_time_to_revisit
  end

  def next_card_to_review
    # scheduled_time_to_revisit < Now
    # sort by bin DESC
    # WHERE times_wrong < 10

    # if none, WHERE bin = 0
    # sort by created ASC
  end

  def has_future_cards
    # scheduled_time_to_revisit > Now OR bin = 0 AND times_wrong < 10
  end

  def update_scheduled_time_to_revisit
    # switch bin different cases set scheduled_time_to_revisit to Now + time_interval
    time_interval = get_time_interval_for_bin
    self.scheduled_time_to_revisit = time_interval.nil? ? nil : Time.now + time_interval
  end

  def get_time_interval_for_bin
    bin_to_time_interval[self.bin]
  end
end
