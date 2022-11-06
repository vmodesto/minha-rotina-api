class Event < ApplicationRecord
  validates :title, :start_date, presence: true
  belongs_to :user
  belongs_to :parent, class_name: "Event", optional: true
  has_many :children, class_name: "Event", foreign_key: :parent_id
  belongs_to :event_category

  enum priority: {normal: "normal", moderate: "moderate", urgent: "urgent"}, _default: "normal"
  enum status: {created: "created", progress: "progress", finished: "finished"}, _default: "created"

  def self.by_start_date_and_user_id(start_date:, user_id:)
    start_date = Time.zone.parse(start_date.to_s)
    start_date ||= Time.zone.now
    self.where(start_date: start_date.beginning_of_day...start_date.end_of_day, user_id: user_id)
  end
end
