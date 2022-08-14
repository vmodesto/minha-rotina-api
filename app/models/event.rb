class Event < ApplicationRecord
  belongs_to :user

  enum priority: {normal: "normal", moderate: "moderate", urgent: "urgent"}, _default: "normal"
  enum status: {created: "created", progress: "progress", finished: "finished"}, _default: "created"
end
