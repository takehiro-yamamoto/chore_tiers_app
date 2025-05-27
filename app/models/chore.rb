class Chore < ApplicationRecord
  belongs_to :tier
  belongs_to :assigned_to
end
