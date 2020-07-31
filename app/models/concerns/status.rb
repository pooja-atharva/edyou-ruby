module Status
  extend ActiveSupport::Concern
  STATUSES = { pending: 0, approved: 1, declined: 2, cancelled: 3, active: 4, in_active: 5}
  included do
    enum status: STATUSES
  end
end
