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

  BIN_TO_TIME_INTERVAL = [
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

  def self.next_card_to_review(current_time = nil)
    current_time ||= Time.now
    ret = self.where(
        "date(scheduled_time_to_revisit) < ? AND times_wrong < 10",
        current_time
      ).
      order(bin: :desc).
      take

    if (ret.nil?)
      self.where(bin: 0).order(created_at: :asc).take
    end
  end

  def self.has_future_cards(current_time = nil)
    current_time ||= Time.now
    ret = self.where(
        "(date(scheduled_time_to_revisit) > ? OR bin = ?) AND times_wrong < 10",
        current_time,
        0
      )

    !ret.nil? && !ret.empty?
  end

  def update_scheduled_time_to_revisit
    time_interval = get_time_interval_for_bin
    self.scheduled_time_to_revisit = time_interval.nil? ? nil : Time.now + time_interval
  end
  private :update_scheduled_time_to_revisit

  def get_time_interval_for_bin
    BIN_TO_TIME_INTERVAL[self.bin]
  end
  private :get_time_interval_for_bin
end
