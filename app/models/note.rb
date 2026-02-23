# == Schema Information
#
# Table name: notes
#
#  id         :bigint(8)        not null, primary key
#  title      :string
#  content    :text
#  user_id    :bigint(8)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  note_type  :integer          default(0), not null
#
class Note < ApplicationRecord
  belongs_to :user

  delegate :utility, to: :user
  enum note_type: { review: 0, critique: 1 }

  validates :title, :content, :note_type, :user, presence: true
  validate :validate_review_word_count, if: -> { review? && user.present? }

  def word_count
    return 0 if content.blank?
    content.split.size
  end

  def content_length
    return nil if user.blank?

    thresholds = utility.word_count_thresholds
    count = word_count

    if count <= thresholds[:short]
      'short'
    elsif count <= thresholds[:medium]
      'medium'
    else
      'long'
    end
  end

  private

  def validate_review_word_count
    limit = utility.review_max_words
    if word_count > limit
      errors.add(:content, I18n.t('errors.too_long', limit: limit, utility: utility.name))
    end
  end
end
